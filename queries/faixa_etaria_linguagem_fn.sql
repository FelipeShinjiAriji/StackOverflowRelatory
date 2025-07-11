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
           COUNT(*) AS total_respondentes,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, fe.id), 2) AS percentual_na_faixa,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, l.linguagem), 2) AS percentual_na_linguagem,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, fe.id), 2) AS percentual_na_faixa_etaria_que_usa_linguagem
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
           percentual_na_faixa,
           percentual_na_linguagem,
           percentual_na_faixa_etaria_que_usa_linguagem,
           ROW_NUMBER() OVER (PARTITION BY ano, faixa_etaria ORDER BY total_respondentes DESC) as ranking
    FROM faixa_etaria_linguagem
    WHERE total_respondentes >= 3
),
estatisticas_faixa AS (
    SELECT ano,
           faixa_etaria,
           idade_inicio,
           idade_fim,
           COUNT(DISTINCT linguagem) as total_linguagens,
           SUM(total_respondentes) as total_respondentes_faixa,
           ROUND(AVG(percentual_na_faixa), 2) as media_percentual_linguagens
    FROM faixa_etaria_linguagem
    GROUP BY ano, faixa_etaria, idade_inicio, idade_fim
)
SELECT r.ano,
       r.faixa_etaria,
       r.linguagem,
       r.total_respondentes,
       TO_CHAR(r.percentual_na_faixa) || '%' as percentual_na_faixa,
       TO_CHAR(r.percentual_na_linguagem) || '%' as percentual_na_linguagem,
       TO_CHAR(r.percentual_na_faixa_etaria_que_usa_linguagem) || '%' as percentual_na_faixa_etaria_que_usa_linguagem,
       e.total_linguagens,
       e.total_respondentes_faixa,
       TO_CHAR(e.media_percentual_linguagens) || '%' as media_percentual_linguagens,
       CASE
           WHEN r.percentual_na_faixa > e.media_percentual_linguagens THEN 'Popular na faixa'
           WHEN r.percentual_na_faixa < e.media_percentual_linguagens THEN 'Menos popular na faixa'
           ELSE 'Média na faixa'
       END as popularidade_na_faixa
FROM ranked_linguagens_por_faixa r
JOIN estatisticas_faixa e ON r.ano = e.ano AND r.faixa_etaria = e.faixa_etaria
WHERE r.ranking <= 5
ORDER BY r.ano DESC, r.idade_inicio, r.ranking;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta(ano);
CREATE INDEX idx_resposta_linguagem_resposta_id ON Resposta_Linguagem(resposta_id);
CREATE INDEX idx_resposta_linguagem_linguagem_id ON Resposta_Linguagem(linguagem_id);
CREATE INDEX idx_faixaetaria_id ON FaixaEtaria(id);

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
           COUNT(*) AS total_respondentes,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, fe.id), 2) AS percentual_na_faixa,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, l.linguagem), 2) AS percentual_na_linguagem,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.ano, fe.id), 2) AS percentual_na_faixa_etaria_que_usa_linguagem
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
           percentual_na_faixa,
           percentual_na_linguagem,
           percentual_na_faixa_etaria_que_usa_linguagem,
           ROW_NUMBER() OVER (PARTITION BY ano, faixa_etaria ORDER BY total_respondentes DESC) as ranking
    FROM faixa_etaria_linguagem
    WHERE total_respondentes >= 3
),
estatisticas_faixa AS (
    SELECT ano,
           faixa_etaria,
           idade_inicio,
           idade_fim,
           COUNT(DISTINCT linguagem) as total_linguagens,
           SUM(total_respondentes) as total_respondentes_faixa,
           ROUND(AVG(percentual_na_faixa), 2) as media_percentual_linguagens
    FROM faixa_etaria_linguagem
    GROUP BY ano, faixa_etaria, idade_inicio, idade_fim
)
SELECT r.ano,
       r.faixa_etaria,
       r.linguagem,
       r.total_respondentes,
       TO_CHAR(r.percentual_na_faixa) || '%' as percentual_na_faixa,
       TO_CHAR(r.percentual_na_linguagem) || '%' as percentual_na_linguagem,
       TO_CHAR(r.percentual_na_faixa_etaria_que_usa_linguagem) || '%' as percentual_na_faixa_etaria_que_usa_linguagem,
       e.total_linguagens,
       e.total_respondentes_faixa,
       TO_CHAR(e.media_percentual_linguagens) || '%' as media_percentual_linguagens,
       CASE
           WHEN r.percentual_na_faixa > e.media_percentual_linguagens THEN 'Popular na faixa'
           WHEN r.percentual_na_faixa < e.media_percentual_linguagens THEN 'Menos popular na faixa'
           ELSE 'Média na faixa'
       END as popularidade_na_faixa
FROM ranked_linguagens_por_faixa r
JOIN estatisticas_faixa e ON r.ano = e.ano AND r.faixa_etaria = e.faixa_etaria
WHERE r.ranking <= 5
ORDER BY r.ano DESC, r.idade_inicio, r.ranking;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_linguagem_resposta_id;
DROP INDEX idx_resposta_linguagem_linguagem_id;
DROP INDEX idx_faixaetaria_id;

