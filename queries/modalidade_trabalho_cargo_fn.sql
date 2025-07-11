CREATE OR REPLACE TYPE tp_modalidade_trabalho_cargo AS OBJECT
(
    ano                   NUMBER,
    modalidade_trabalho   VARCHAR2(100),
    cargo                 VARCHAR2(100),
    percentual_no_cargo   VARCHAR2(20),
    percentual_modalidade VARCHAR2(20)
);
/
CREATE OR REPLACE TYPE tbl_modalidade_trabalho_cargo AS TABLE OF tp_modalidade_trabalho_cargo;
/

CREATE OR REPLACE FUNCTION fn_modalidade_trabalho_cargo
    RETURN tbl_modalidade_trabalho_cargo
    PIPELINED
AS
BEGIN
    FOR rec IN (
        SELECT ano,
               trabalho_remoto                                                                AS modalidade_trabalho,
               cargo,
               ROUND(100 * cnt / SUM(cnt) OVER (PARTITION BY ano, cargo), 2) || '%'           AS percentual_no_cargo,
               ROUND(100 * cnt / SUM(cnt) OVER (PARTITION BY ano, trabalho_remoto), 2) || '%' AS percentual_modalidade
        FROM (SELECT r.ano,
                     tr.trabalho_remoto,
                     c.cargo,
                     COUNT(*) AS cnt,
                     ROW_NUMBER() OVER (
                         PARTITION BY r.ano, tr.trabalho_remoto
                         ORDER BY COUNT(*) DESC
                         )    AS rn
              FROM Resposta r
                       JOIN Resposta_Cargo rc ON r.id = rc.resposta_id
                       JOIN Cargo c ON rc.cargo_id = c.id
                       LEFT JOIN TrabalhoRemoto tr ON r.trabalho_remoto_id = tr.id
              WHERE r.ano IS NOT NULL
                AND tr.trabalho_remoto IS NOT NULL
              GROUP BY r.ano, tr.trabalho_remoto, c.cargo)
        WHERE rn <= 5
        ORDER BY ano DESC, trabalho_remoto, rn
        )
        LOOP
            PIPE ROW (tp_modalidade_trabalho_cargo(
                    rec.ano,
                    rec.modalidade_trabalho,
                    rec.cargo,
                    rec.percentual_no_cargo,
                    rec.percentual_modalidade
                      ));
        END LOOP;
    RETURN;
END;
/

EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_modalidade_trabalho_cargo);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_resposta_ano ON Resposta(ano);
CREATE INDEX idx_resposta_cargo_resposta_id ON Resposta_Cargo(resposta_id);
CREATE INDEX idx_resposta_cargo_cargo_id ON Resposta_Cargo(cargo_id);

EXPLAIN PLAN FOR
SELECT *
FROM TABLE (fn_modalidade_trabalho_cargo);
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

DROP INDEX idx_resposta_ano;
DROP INDEX idx_resposta_cargo_resposta_id;
DROP INDEX idx_resposta_cargo_cargo_id;