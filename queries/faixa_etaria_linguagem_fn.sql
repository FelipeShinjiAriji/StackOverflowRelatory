EXPLAIN PLAN FOR
WITH faixa_etaria_linguagem AS (
    SELECT r.ano,
           fe.inicio AS idade_inicio,
           fe.fim AS idade_fim,
           CASE
               WHEN fe.inicio = fe.fim THEN CAST(fe.inicio AS VARCHAR2(10))
               ELSE CAST(fe.inicio AS VARCHAR2(10)) || '-' || CAST(fe.fim AS VARCHAR2(10))
           END AS faixa_etaria,
           l.linguagem,
           COUNT(*) AS total_respondentes
    FROM Resposta r
         JOIN Resposta_Linguagem rl ON r.id = rl.resposta_id
         JOIN Linguagem l ON rl.linguagem_id = l.id
         LEFT JOIN FaixaEtaria fe ON r.faixa_etaria_id = fe.id
    WHERE r.ano IS NOT NULL
      AND fe.id IS NOT NULL
    GROUP BY r.ano, fe.id, fe.inicio, fe.fim, l.linguagem
),
ranked_linguagens_por_faixa AS (
    SELECT ano,
           faixa_etaria,
           idade_inicio,
           idade_fim,
           linguagem,
           total_respondentes,
           ROW_NUMBER() OVER (PARTITION BY ano, faixa_etaria ORDER BY total_respondentes DESC) as ranking
    FROM faixa_etaria_linguagem
    WHERE total_respondentes >= 3
),
estatisticas_faixa AS (
    SELECT ano,
           faixa_etaria,
           SUM(total_respondentes) as total_respondentes_faixa
    FROM faixa_etaria_linguagem
    GROUP BY ano, faixa_etaria
),
estatisticas_ano AS (
    SELECT ano,
           SUM(total_respondentes) as total_respondentes_ano
    FROM faixa_etaria_linguagem
    GROUP BY ano
)
SELECT r.ano,
       r.faixa_etaria,
       r.linguagem,
       ROUND((100.0 * r.total_respondentes) / e.total_respondentes_faixa, 2) AS percentual_na_linguagem,
       ROUND((100.0 * e.total_respondentes_faixa) / ea.total_respondentes_ano, 2) AS percentual_faixa_etaria
FROM ranked_linguagens_por_faixa r
JOIN estatisticas_faixa e ON r.ano = e.ano AND r.faixa_etaria = e.faixa_etaria
JOIN estatisticas_ano ea ON r.ano = ea.ano
WHERE r.ranking <= 5
ORDER BY r.ano DESC, r.idade_inicio, percentual_na_linguagem DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta(ano);
CREATE INDEX idx_resposta_linguagem_resposta_id ON Resposta_Linguagem(resposta_id);
CREATE INDEX idx_resposta_linguagem_linguagem_id ON Resposta_Linguagem(linguagem_id);

EXPLAIN PLAN FOR
WITH faixa_etaria_linguagem AS (
    SELECT r.ano,
           fe.inicio AS idade_inicio,
           fe.fim AS idade_fim,
           CASE
               WHEN fe.inicio = fe.fim THEN CAST(fe.inicio AS VARCHAR2(10))
               ELSE CAST(fe.inicio AS VARCHAR2(10)) || '-' || CAST(fe.fim AS VARCHAR2(10))
           END AS faixa_etaria,
           l.linguagem,
           COUNT(*) AS total_respondentes
    FROM Resposta r
         JOIN Resposta_Linguagem rl ON r.id = rl.resposta_id
         JOIN Linguagem l ON rl.linguagem_id = l.id
         LEFT JOIN FaixaEtaria fe ON r.faixa_etaria_id = fe.id
    WHERE r.ano IS NOT NULL
      AND fe.id IS NOT NULL
    GROUP BY r.ano, fe.id, fe.inicio, fe.fim, l.linguagem
),
ranked_linguagens_por_faixa AS (
    SELECT ano,
           faixa_etaria,
           idade_inicio,
           idade_fim,
           linguagem,
           total_respondentes,
           ROW_NUMBER() OVER (PARTITION BY ano, faixa_etaria ORDER BY total_respondentes DESC) as ranking
    FROM faixa_etaria_linguagem
    WHERE total_respondentes >= 3
),
estatisticas_faixa AS (
    SELECT ano,
           faixa_etaria,
           SUM(total_respondentes) as total_respondentes_faixa
    FROM faixa_etaria_linguagem
    GROUP BY ano, faixa_etaria
),
estatisticas_ano AS (
    SELECT ano,
           SUM(total_respondentes) as total_respondentes_ano
    FROM faixa_etaria_linguagem
    GROUP BY ano
)
SELECT r.ano,
       r.faixa_etaria,
       r.linguagem,
       ROUND((100.0 * r.total_respondentes) / e.total_respondentes_faixa, 2) AS percentual_na_linguagem,
       ROUND((100.0 * e.total_respondentes_faixa) / ea.total_respondentes_ano, 2) AS percentual_faixa_etaria
FROM ranked_linguagens_por_faixa r
JOIN estatisticas_faixa e ON r.ano = e.ano AND r.faixa_etaria = e.faixa_etaria
JOIN estatisticas_ano ea ON r.ano = ea.ano
WHERE r.ranking <= 5
ORDER BY r.ano DESC, r.idade_inicio, percentual_na_linguagem DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_linguagem_resposta_id;
DROP INDEX idx_resposta_linguagem_linguagem_id;

