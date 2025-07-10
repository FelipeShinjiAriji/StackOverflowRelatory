DROP TABLE Prog_Language;
DROP TABLE Respondent;
DROP SEQUENCE Respondent_Seq;

CREATE TABLE Respondent
(
    id            INT PRIMARY KEY,
    respondent_id INT NOT NULL,
    year          INT NOT NULL

--     UNIQUE (respondent_id, year)
);

CREATE TABLE Prog_Language
(
    id       INT PRIMARY KEY,
    language VARCHAR(16) NOT NULL
);

CREATE SEQUENCE Respondent_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


COMMIT;