EXPLAIN PLAN FOR
WITH formacao_cargo AS (
    SELECT r.ano,
           f.formacao,
           c.cargo,
           COUNT(*) as total_respondentes
    FROM Resposta r
         JOIN Resposta_Cargo rc ON r.id = rc.resposta_id
         JOIN Cargo c ON rc.cargo_id = c.id
         LEFT JOIN Formacao f ON r.formacao_id = f.id
    WHERE r.ano IS NOT NULL
      AND f.id IS NOT NULL
    GROUP BY r.ano, f.formacao, c.cargo
),
ranked_cargos_por_formacao AS (
    SELECT ano,
           formacao,
           cargo,
           total_respondentes,
           ROW_NUMBER() OVER (PARTITION BY ano, formacao ORDER BY total_respondentes DESC) as ranking
    FROM formacao_cargo
    WHERE total_respondentes >= 3
),
estatisticas_formacao AS (
    SELECT ano,
           formacao,
           SUM(total_respondentes) as total_respondentes_formacao
    FROM formacao_cargo
    GROUP BY ano, formacao
),
estatisticas_ano AS (
    SELECT ano,
           SUM(total_respondentes) as total_respondentes_ano
    FROM formacao_cargo
    GROUP BY ano
)
SELECT r.ano,
       r.formacao,
       r.cargo,
       ROUND((100.0 * r.total_respondentes) / e.total_respondentes_formacao, 2) AS percentual_no_cargo,
       ROUND((100.0 * e.total_respondentes_formacao) / ea.total_respondentes_ano, 2) AS percentual_formacao
FROM ranked_cargos_por_formacao r
JOIN estatisticas_formacao e ON r.ano = e.ano AND r.formacao = e.formacao
JOIN estatisticas_ano ea ON r.ano = ea.ano
WHERE r.ranking <= 5
ORDER BY r.ano DESC, r.formacao, percentual_no_cargo DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta(ano);
CREATE INDEX idx_resposta_cargo_resposta_id ON Resposta_Cargo(resposta_id);
CREATE INDEX idx_resposta_cargo_cargo_id ON Resposta_Cargo(cargo_id);

EXPLAIN PLAN FOR
WITH formacao_cargo AS (
    SELECT r.ano,
           f.formacao,
           c.cargo,
           COUNT(*) as total_respondentes
    FROM Resposta r
         JOIN Resposta_Cargo rc ON r.id = rc.resposta_id
         JOIN Cargo c ON rc.cargo_id = c.id
         LEFT JOIN Formacao f ON r.formacao_id = f.id
    WHERE r.ano IS NOT NULL
      AND f.id IS NOT NULL
    GROUP BY r.ano, f.formacao, c.cargo
),
ranked_cargos_por_formacao AS (
    SELECT ano,
           formacao,
           cargo,
           total_respondentes,
           ROW_NUMBER() OVER (PARTITION BY ano, formacao ORDER BY total_respondentes DESC) as ranking
    FROM formacao_cargo
    WHERE total_respondentes >= 3
),
estatisticas_formacao AS (
    SELECT ano,
           formacao,
           SUM(total_respondentes) as total_respondentes_formacao
    FROM formacao_cargo
    GROUP BY ano, formacao
),
estatisticas_ano AS (
    SELECT ano,
           SUM(total_respondentes) as total_respondentes_ano
    FROM formacao_cargo
    GROUP BY ano
)
SELECT r.ano,
       r.formacao,
       r.cargo,
       ROUND((100.0 * r.total_respondentes) / e.total_respondentes_formacao, 2) AS percentual_no_cargo,
       ROUND((100.0 * e.total_respondentes_formacao) / ea.total_respondentes_ano, 2) AS percentual_formacao
FROM ranked_cargos_por_formacao r
JOIN estatisticas_formacao e ON r.ano = e.ano AND r.formacao = e.formacao
JOIN estatisticas_ano ea ON r.ano = ea.ano
WHERE r.ranking <= 5
ORDER BY r.ano DESC, r.formacao, percentual_no_cargo DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_cargo_resposta_id;
DROP INDEX idx_resposta_cargo_cargo_id;
