BEGIN;

INSERT INTO ministerio.doadores (id, nome, email, origem)
VALUES
    ('00000000-0000-4000-8000-000000000001', 'Ana Exemplo', 'ana@example.com', 'excel'),
    ('00000000-0000-4000-8000-000000000002', 'Bruno Exemplo', 'bruno@example.com', 'excel')
ON CONFLICT (id) DO NOTHING;

INSERT INTO ministerio.participacoes
    (id, doador_id, orando, contribuindo, frequencia, forma, valor_declarado_centavos, origem)
VALUES
    ('00000000-0000-4000-8000-000000000011', '00000000-0000-4000-8000-000000000001',
     false, true, 'nao_regular', 'pix', 5000, 'excel'),
    ('00000000-0000-4000-8000-000000000012', '00000000-0000-4000-8000-000000000002',
     true, false, NULL, NULL, NULL, 'excel')
ON CONFLICT (id) DO NOTHING;

INSERT INTO ministerio.doacoes_recebidas
    (id, doador_id, data_pagamento, valor_recebido_centavos, forma, situacao)
VALUES
    ('00000000-0000-4000-8000-000000000021', '00000000-0000-4000-8000-000000000001',
     '2026-01-15', 5000, 'pix', 'confirmado')
ON CONFLICT (id) DO NOTHING;

COMMIT;
