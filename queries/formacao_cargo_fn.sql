CREATE OR REPLACE TYPE tp_formacao_cargo AS OBJECT
(
    ano                 NUMBER,
    formacao            VARCHAR2(100),
    cargo               VARCHAR2(100),
    percentual_no_cargo NUMBER,
    percentual_formacao NUMBER
);
/
CREATE OR REPLACE TYPE tbl_formacao_cargo AS TABLE OF tp_formacao_cargo;
/

CREATE OR REPLACE FUNCTION fn_formacao_cargo
    RETURN tbl_formacao_cargo
    PIPELINED
AS
BEGIN
    FOR rec IN (
        SELECT ano,
               formacao,
               cargo,
               ROUND(
                       100 * total_respondentes
                           / SUM(total_respondentes)
                                 OVER (PARTITION BY ano, formacao),
                       2
               ) AS percentual_no_cargo,
               ROUND(
                       100 * SUM(total_respondentes)
                                 OVER (PARTITION BY ano, formacao)
                           / SUM(total_respondentes)
                                 OVER (PARTITION BY ano),
                       2
               ) AS percentual_formacao
        FROM (SELECT r.ano,
                     f.formacao,
                     c.cargo,
                     COUNT(*)      AS total_respondentes,
                     ROW_NUMBER()
                             OVER (
                                 PARTITION BY r.ano, f.formacao
                                 ORDER BY COUNT(*) DESC
                                 ) AS rn
              FROM Resposta r
                       JOIN Resposta_Cargo rc ON r.id = rc.resposta_id
                       JOIN Cargo c ON rc.cargo_id = c.id
                       JOIN Formacao f ON r.formacao_id = f.id
              WHERE r.ano IS NOT NULL
                AND f.id IS NOT NULL
              GROUP BY r.ano, f.formacao, c.cargo
              HAVING COUNT(*) >= 3)
        WHERE rn <= 5
        ORDER BY ano DESC, formacao, percentual_no_cargo DESC
        )
        LOOP
            PIPE ROW (tp_formacao_cargo(
                    rec.ano,
                    rec.formacao,
                    rec.cargo,
                    rec.percentual_no_cargo,
                    rec.percentual_formacao
                      ));
        END LOOP;

    RETURN;
END;
/

EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_formacao_cargo);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta (ano);
CREATE INDEX idx_resposta_cargo_resposta_id ON Resposta_Cargo (resposta_id);
CREATE INDEX idx_resposta_cargo_cargo_id ON Resposta_Cargo (cargo_id);

EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_formacao_cargo);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_cargo_resposta_id;
DROP INDEX idx_resposta_cargo_cargo_id;