CREATE OR REPLACE TYPE tp_faixa_etaria_linguagem AS OBJECT
(
    ano                     NUMBER,
    faixa_etaria            VARCHAR2(50),
    linguagem               VARCHAR2(100),
    total_respondentes      NUMBER,
    percentual_na_faixa     VARCHAR2(20),
    percentual_na_linguagem VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE tbl_faixa_etaria_linguagem AS TABLE OF tp_faixa_etaria_linguagem;
/

CREATE OR REPLACE FUNCTION fn_faixa_etaria_linguagem
    RETURN tbl_faixa_etaria_linguagem PIPELINED
AS
BEGIN
    FOR rec IN (
        SELECT r.ano,
               CASE
                   WHEN fe.inicio = fe.fim THEN TO_CHAR(fe.inicio)
                   ELSE TO_CHAR(fe.inicio) || '-' || TO_CHAR(fe.fim)
                   END  AS faixa_etaria,
               l.linguagem,
               COUNT(*) AS total_respondentes,
               ROUND(
                       COUNT(*) * 100.0
                           / SUM(COUNT(*)) OVER (PARTITION BY r.ano, fe.id),
                       2
               )        AS percentual_na_faixa,
               ROUND(
                       COUNT(*) * 100.0
                           / SUM(COUNT(*)) OVER (PARTITION BY r.ano, l.linguagem),
                       2
               )        AS percentual_na_linguagem,
               ROW_NUMBER() OVER (
                   PARTITION BY r.ano, fe.id
                   ORDER BY COUNT(*) DESC
                   )    AS rn
        FROM Resposta r
                 JOIN Resposta_Linguagem rl ON rl.resposta_id = r.id
                 JOIN Linguagem l ON l.id = rl.linguagem_id
                 JOIN FaixaEtaria fe ON fe.id = r.faixa_etaria_id
        WHERE r.ano IS NOT NULL
        GROUP BY r.ano,
                 fe.id, fe.inicio, fe.fim,
                 l.linguagem
        HAVING COUNT(*) >= 3
        )
        LOOP
            IF rec.rn <= 5 THEN
                PIPE ROW (
                    tp_faixa_etaria_linguagem(
                            rec.ano,
                            rec.faixa_etaria,
                            rec.linguagem,
                            rec.total_respondentes,
                            TO_CHAR(rec.percentual_na_faixa) || '%',
                            TO_CHAR(rec.percentual_na_linguagem) || '%'
                    )
                    );
            END IF;
        END LOOP;
    RETURN;
END fn_faixa_etaria_linguagem;
/


EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_faixa_etaria_linguagem);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta (ano);
CREATE INDEX idx_resposta_linguagem_resposta_id ON Resposta_Linguagem (resposta_id);
CREATE INDEX idx_resposta_linguagem_linguagem_id ON Resposta_Linguagem (linguagem_id);

EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_faixa_etaria_linguagem);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_linguagem_resposta_id;
DROP INDEX idx_resposta_linguagem_linguagem_id;

