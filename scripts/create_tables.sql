DROP TABLE Resposta_Linguagem;
DROP TABLE Resposta_Cargo;
DROP TABLE Resposta;

DROP TABLE Linguagem;
DROP TABLE Moeda;
DROP TABLE Cargo;
DROP TABLE pais;
DROP TABLE Formacao;
DROP TABLE TrabalhoRemoto;
DROP TABLE FaixaEtaria;

DROP SEQUENCE Moeda_Seq;
DROP SEQUENCE Cargo_Seq;
DROP SEQUENCE pais_Seq;
DROP SEQUENCE Formacao_Seq;
DROP SEQUENCE TrabalhoRemoto_Seq;
DROP SEQUENCE FaixaEtaria_Seq;
DROP SEQUENCE Linguagem_Seq;
DROP SEQUENCE Resposta_Seq;

CREATE TABLE Linguagem
(
    id       INT PRIMARY KEY,
    linguagem VARCHAR(512) NOT NULL
);

CREATE TABLE FaixaEtaria
(
    id        INT PRIMARY KEY,
    inicio INT NOT NULL,
    fim   INT NOT NULL
);

CREATE TABLE TrabalhoRemoto
(
    id          INT PRIMARY KEY,
    trabalho_remoto VARCHAR(64) NOT NULL
);

CREATE TABLE Formacao
(
    id       INT PRIMARY KEY,
    formacao VARCHAR(128) NOT NULL
);

CREATE TABLE Pais
(
    id      INT PRIMARY KEY,
    pais VARCHAR(64) NOT NULL
);

CREATE TABLE Cargo
(
    id       INT PRIMARY KEY,
    cargo VARCHAR(128) NOT NULL
);

CREATE TABLE Moeda
(
    id       INT PRIMARY KEY,
    moeda VARCHAR(64) NOT NULL
);

CREATE TABLE Resposta
(
    id            INT PRIMARY KEY,
    resposta INT NOT NULL,
    ano          INT NOT NULL,
    salario_anual VARCHAR2(512),
    anos_programando INT,

    moeda_id INT,
    pais_id INT,
    formacao_id INT,
    trabalho_remoto_id INT,
    faixa_etaria_id INT,

    UNIQUE (resposta, ano),
    FOREIGN KEY (moeda_id) REFERENCES Moeda (id),
    FOREIGN KEY (pais_id) REFERENCES pais (id),
    FOREIGN KEY (formacao_id) REFERENCES Formacao (id),
    FOREIGN KEY (trabalho_remoto_id) REFERENCES TrabalhoRemoto (id),
    FOREIGN KEY (faixa_etaria_id) REFERENCES FaixaEtaria (id)
);

CREATE TABLE Resposta_Cargo
(
    resposta_id INT NOT NULL,
    cargo_id   INT NOT NULL,
    PRIMARY KEY (resposta_id, cargo_id),
    FOREIGN KEY (resposta_id) REFERENCES Resposta (id),
    FOREIGN KEY (cargo_id) REFERENCES Cargo (id)
);

CREATE TABLE Resposta_Linguagem
(
    resposta_id    INT NOT NULL,
    linguagem_id INT NOT NULL,
    PRIMARY KEY (resposta_id, linguagem_id),
    FOREIGN KEY (resposta_id) REFERENCES Resposta (id),
    FOREIGN KEY (linguagem_id) REFERENCES Linguagem (id)
);

CREATE SEQUENCE Resposta_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE Linguagem_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE FaixaEtaria_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE TrabalhoRemoto_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE Formacao_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE Pais_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE Cargo_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE Moeda_Seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

COMMIT;