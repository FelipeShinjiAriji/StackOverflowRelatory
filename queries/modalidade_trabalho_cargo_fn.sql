EXPLAIN PLAN FOR
WITH trabalho_remoto_cargo AS (
    SELECT r.ano,
           tr.trabalho_remoto,
           c.cargo,
           COUNT(*) as total_respondentes,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, tr.trabalho_remoto), 2) as percentual_modalidade,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, c.cargo), 2) as percentual_no_cargo
    FROM Resposta r
         JOIN Resposta_Cargo rc ON r.id = rc.resposta_id
         JOIN Cargo c ON rc.cargo_id = c.id
         LEFT JOIN TrabalhoRemoto tr ON r.trabalho_remoto_id = tr.id
    WHERE r.ano IS NOT NULL
      AND tr.trabalho_remoto IS NOT NULL
    GROUP BY r.ano, tr.trabalho_remoto, c.cargo
),
ranked_cargos_por_modalidade AS (
    SELECT ano,
           trabalho_remoto,
           cargo,
           ROW_NUMBER() OVER (PARTITION BY ano, trabalho_remoto ORDER BY total_respondentes DESC) as ranking
    FROM trabalho_remoto_cargo
)
SELECT t.ano,
       t.trabalho_remoto as modalidade_trabalho,
       t.cargo,
       t.percentual_no_cargo || '%' as percentual_no_cargo,
       t.percentual_modalidade || '%' as percentual_modalidade
FROM trabalho_remoto_cargo t
JOIN ranked_cargos_por_modalidade r ON t.ano = r.ano AND t.trabalho_remoto = r.trabalho_remoto AND t.cargo = r.cargo
WHERE r.ranking <= 5
ORDER BY t.ano DESC, t.trabalho_remoto, r.ranking;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta(ano);
CREATE INDEX idx_resposta_cargo_resposta_id ON Resposta_Cargo(resposta_id);
CREATE INDEX idx_resposta_cargo_cargo_id ON Resposta_Cargo(cargo_id);

EXPLAIN PLAN FOR
WITH trabalho_remoto_cargo AS (
    SELECT r.ano,
           tr.trabalho_remoto,
           c.cargo,
           COUNT(*) as total_respondentes,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, tr.trabalho_remoto), 2) as percentual_modalidade,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, c.cargo), 2) as percentual_no_cargo
    FROM Resposta r
         JOIN Resposta_Cargo rc ON r.id = rc.resposta_id
         JOIN Cargo c ON rc.cargo_id = c.id
         LEFT JOIN TrabalhoRemoto tr ON r.trabalho_remoto_id = tr.id
    WHERE r.ano IS NOT NULL
      AND tr.trabalho_remoto IS NOT NULL
    GROUP BY r.ano, tr.trabalho_remoto, c.cargo
),
ranked_cargos_por_modalidade AS (
    SELECT ano,
           trabalho_remoto,
           cargo,
           ROW_NUMBER() OVER (PARTITION BY ano, trabalho_remoto ORDER BY total_respondentes DESC) as ranking
    FROM trabalho_remoto_cargo
)
SELECT t.ano,
       t.trabalho_remoto as modalidade_trabalho,
       t.cargo,
       t.percentual_no_cargo || '%' as percentual_no_cargo,
       t.percentual_modalidade || '%' as percentual_modalidade
FROM trabalho_remoto_cargo t
JOIN ranked_cargos_por_modalidade r ON t.ano = r.ano AND t.trabalho_remoto = r.trabalho_remoto AND t.cargo = r.cargo
WHERE r.ranking <= 5
ORDER BY t.ano DESC, t.trabalho_remoto, r.ranking;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_cargo_resposta_id;
DROP INDEX idx_resposta_cargo_cargo_id;
