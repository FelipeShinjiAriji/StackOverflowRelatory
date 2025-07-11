EXPLAIN PLAN FOR
WITH salarios_por_linguagem AS (
    SELECT r.ano,
           l.linguagem,
           COUNT(*) as total_respondentes,
           AVG(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) as media_salario_usd,
           MIN(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) as min_salario_usd,
           MAX(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) as max_salario_usd
    FROM Resposta r
         JOIN Resposta_Linguagem rl ON r.id = rl.resposta_id
         JOIN Linguagem l ON rl.linguagem_id = l.id
         LEFT JOIN Moeda m ON r.moeda_id = m.id
    WHERE r.salario_anual IS NOT NULL
      AND r.salario_anual <> 'NA'
      AND r.ano IS NOT NULL
      AND MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual)) BETWEEN 1000 AND 1000000
    GROUP BY r.ano, l.linguagem
    HAVING COUNT(*) >= 100
),
salarios_com_diferenca AS (
    SELECT s1.ano,
           s1.linguagem,
           s1.total_respondentes,
           ROUND(s1.media_salario_usd, 2) as media_salario_usd,
           s1.min_salario_usd,
           s1.max_salario_usd,
           s2.media_salario_usd as media_ano_anterior,
           CASE
               WHEN s2.media_salario_usd IS NOT NULL THEN ROUND(s1.media_salario_usd - s2.media_salario_usd, 2)
           END as diferenca_absoluta,
           CASE
               WHEN s2.media_salario_usd IS NOT NULL AND s2.media_salario_usd > 0 THEN ROUND(((s1.media_salario_usd - s2.media_salario_usd) / s2.media_salario_usd) * 100, 2)
           END as variacao_percentual
    FROM salarios_por_linguagem s1
         LEFT JOIN salarios_por_linguagem s2 ON s1.linguagem = s2.linguagem AND s1.ano = s2.ano + 1
)
SELECT ano,
       linguagem,
       total_respondentes,
       '$' || media_salario_usd as media_salario_usd,
       '$' || min_salario_usd   as min_salario_usd,
       '$' || max_salario_usd   as max_salario_usd,
       CASE
           WHEN diferenca_absoluta IS NOT NULL THEN
               CASE
                   WHEN diferenca_absoluta > 0 THEN '+$' || diferenca_absoluta
                   ELSE '-$' || ABS(diferenca_absoluta)
               END
           ELSE 'N/A'
       END as diferenca_absoluta,
       CASE
           WHEN variacao_percentual IS NOT NULL THEN
               CASE
                   WHEN variacao_percentual > 0 THEN '+' || variacao_percentual || '%'
                   ELSE variacao_percentual || '%'
               END
           ELSE 'N/A'
       END as variacao_percentual
FROM salarios_com_diferenca
ORDER BY ano DESC, media_salario_usd DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta(ano);
CREATE INDEX idx_resposta_linguagem_resposta_id ON Resposta_Linguagem(resposta_id);
CREATE INDEX idx_resposta_linguagem_linguagem_id ON Resposta_Linguagem(linguagem_id);

EXPLAIN PLAN FOR
WITH salarios_por_linguagem AS (
    SELECT r.ano,
           l.linguagem,
           COUNT(*) as total_respondentes,
           AVG(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) as media_salario_usd,
           MIN(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) as min_salario_usd,
           MAX(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) as max_salario_usd
    FROM Resposta r
         JOIN Resposta_Linguagem rl ON r.id = rl.resposta_id
         JOIN Linguagem l ON rl.linguagem_id = l.id
         LEFT JOIN Moeda m ON r.moeda_id = m.id
    WHERE r.salario_anual IS NOT NULL
      AND r.salario_anual <> 'NA'
      AND r.ano IS NOT NULL
      AND MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual)) BETWEEN 1000 AND 1000000
    GROUP BY r.ano, l.linguagem
    HAVING COUNT(*) >= 100
),
salarios_com_diferenca AS (
    SELECT s1.ano,
           s1.linguagem,
           s1.total_respondentes,
           ROUND(s1.media_salario_usd, 2) as media_salario_usd,
           s1.min_salario_usd,
           s1.max_salario_usd,
           s2.media_salario_usd as media_ano_anterior,
           CASE
               WHEN s2.media_salario_usd IS NOT NULL THEN ROUND(s1.media_salario_usd - s2.media_salario_usd, 2)
           END as diferenca_absoluta,
           CASE
               WHEN s2.media_salario_usd IS NOT NULL AND s2.media_salario_usd > 0 THEN ROUND(((s1.media_salario_usd - s2.media_salario_usd) / s2.media_salario_usd) * 100, 2)
           END as variacao_percentual
    FROM salarios_por_linguagem s1
         LEFT JOIN salarios_por_linguagem s2 ON s1.linguagem = s2.linguagem AND s1.ano = s2.ano + 1
)
SELECT ano,
       linguagem,
       total_respondentes,
       '$' || media_salario_usd as media_salario_usd,
       '$' || min_salario_usd   as min_salario_usd,
       '$' || max_salario_usd   as max_salario_usd,
       CASE
           WHEN diferenca_absoluta IS NOT NULL THEN
               CASE
                   WHEN diferenca_absoluta > 0 THEN '+$' || diferenca_absoluta
                   ELSE '-$' || ABS(diferenca_absoluta)
               END
           ELSE 'N/A'
       END as diferenca_absoluta,
       CASE
           WHEN variacao_percentual IS NOT NULL THEN
               CASE
                   WHEN variacao_percentual > 0 THEN '+' || variacao_percentual || '%'
                   ELSE variacao_percentual || '%'
               END
           ELSE 'N/A'
       END as variacao_percentual
FROM salarios_com_diferenca
ORDER BY ano DESC, media_salario_usd DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_linguagem_resposta_id;
DROP INDEX idx_resposta_linguagem_linguagem_id;
