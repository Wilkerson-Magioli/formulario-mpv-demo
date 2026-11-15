BEGIN;

CREATE OR REPLACE FUNCTION ministerio.confirmar_pix_simulado(chave uuid)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
DECLARE
    participacao ministerio.participacoes%ROWTYPE;
BEGIN
    SELECT * INTO participacao
    FROM ministerio.participacoes
    WHERE chave_envio = chave AND origem = 'formulario'
      AND contribuindo IS TRUE AND forma = 'pix'
      AND valor_declarado_centavos > 0;

    IF NOT FOUND THEN
        RETURN false;
    END IF;

    INSERT INTO ministerio.doacoes_recebidas
        (id, doador_id, data_pagamento, valor_recebido_centavos, forma, situacao)
    VALUES (md5('mpv-demo-pagamento:' || participacao.id::text)::uuid,
            participacao.doador_id, CURRENT_DATE,
            participacao.valor_declarado_centavos, 'pix', 'confirmado')
    ON CONFLICT (id) DO NOTHING;

    RETURN true;
END;
$$;

REVOKE ALL ON FUNCTION ministerio.confirmar_pix_simulado(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION ministerio.confirmar_pix_simulado(uuid) TO mpv_formulario;

COMMIT;
