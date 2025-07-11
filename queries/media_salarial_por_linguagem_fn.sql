CREATE OR REPLACE TYPE tp_media_salarial_por_linguagem AS OBJECT
(
    ano                 NUMBER,
    linguagem           VARCHAR2(100),
    total_respondentes  NUMBER,
    media_salario_usd   VARCHAR2(50),
    min_salario_usd     VARCHAR2(50),
    max_salario_usd     VARCHAR2(50),
    diferenca_absoluta  VARCHAR2(50),
    variacao_percentual VARCHAR2(50)
);
/
CREATE OR REPLACE TYPE tbl_media_salarial_por_linguagem AS TABLE OF tp_media_salarial_por_linguagem;
/

CREATE OR REPLACE FUNCTION fn_media_salarial_por_linguagem
    RETURN tbl_media_salarial_por_linguagem
    PIPELINED
AS
BEGIN
    FOR rec IN (
        SELECT ano,
               linguagem,
               total_respondentes,
               '$' || ROUND(media_salario_usd, 2) AS media_salario_usd,
               '$' || min_salario_usd             AS min_salario_usd,
               '$' || max_salario_usd             AS max_salario_usd,
               CASE
                   WHEN prev_media IS NOT NULL THEN
                       CASE
                           WHEN media_salario_usd - prev_media > 0 THEN '+$' || ROUND(media_salario_usd - prev_media, 2)
                           ELSE '-$' || ROUND(prev_media - media_salario_usd, 2)
                           END
                   ELSE 'N/A'
                   END                            AS diferenca_absoluta,
               CASE
                   WHEN prev_media IS NOT NULL AND prev_media > 0 THEN
                       CASE
                           WHEN (media_salario_usd - prev_media) / prev_media * 100 > 0
                               THEN '+' || ROUND((media_salario_usd - prev_media) / prev_media * 100, 2) || '%'
                           ELSE ROUND((media_salario_usd - prev_media) / prev_media * 100, 2) || '%'
                           END
                   ELSE 'N/A'
                   END                            AS variacao_percentual
        FROM (SELECT ano,
                     linguagem,
                     total_respondentes,
                     media_salario_usd,
                     min_salario_usd,
                     max_salario_usd,
                     LAG(media_salario_usd) OVER (PARTITION BY linguagem ORDER BY ano) AS prev_media
              FROM (SELECT r.ano,
                           l.linguagem,
                           COUNT(*)                                                      AS total_respondentes,
                           AVG(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) AS media_salario_usd,
                           MIN(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) AS min_salario_usd,
                           MAX(MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual))) AS max_salario_usd
                    FROM Resposta r
                             JOIN Resposta_Linguagem rl ON r.id = rl.resposta_id
                             JOIN Linguagem l ON rl.linguagem_id = l.id
                             LEFT JOIN Moeda m ON r.moeda_id = m.id
                    WHERE r.salario_anual IS NOT NULL
                      AND r.salario_anual <> 'NA'
                      AND r.ano IS NOT NULL
                      AND MAP_CURRENCY_TO_USD(m.moeda, TO_NUMBER(r.salario_anual)) BETWEEN 1000 AND 1000000
                    GROUP BY r.ano, l.linguagem
                    HAVING COUNT(*) >= 100))
        ORDER BY ano DESC, media_salario_usd DESC
        )
        LOOP
            PIPE ROW (tp_media_salarial_por_linguagem(
                    rec.ano,
                    rec.linguagem,
                    rec.total_respondentes,
                    rec.media_salario_usd,
                    rec.min_salario_usd,
                    rec.max_salario_usd,
                    rec.diferenca_absoluta,
                    rec.variacao_percentual
                      ));
        END LOOP;
    RETURN;
END;
/

EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_media_salarial_por_linguagem);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta(ano);
CREATE INDEX idx_resposta_linguagem_resposta_id ON Resposta_Linguagem(resposta_id);
CREATE INDEX idx_resposta_linguagem_linguagem_id ON Resposta_Linguagem(linguagem_id);

EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_media_salarial_por_linguagem);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_linguagem_resposta_id;
DROP INDEX idx_resposta_linguagem_linguagem_id;