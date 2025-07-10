/*
    1 - Resposta
    2 - MainBranch
    3 - Hobbyist
    4 - OpenSourcer
    5 - OpenSource
    6 - Employment
    7 - pais
    8 - Student
    9 - Formacao
    10 - UndergradMajor
    11 - EduOther
    12 - OrgSize
    13 - Cargo
    14 - YearsCode
    15 - Age1stCode
    16 - YearsCodePro
    17 - CareerSat
    18 - JobSat
    19 - MgrIdiot
    20 - MgrMoney
    21 - MgrWant
    22 - JobSeek
    23 - LastHireDate
    24 - LastInt
    25 - FizzBuzz
    26 - JobFactors
    27 - ResumeUpdate
    28 - MoedaSymbol
    29 - MoedaDesc
    30 - CompTotal
    31 - CompFreq
    32 - ConvertedComp
    33 - WorkWeekHrs
    34 - WorkPlan
    35 - WorkChallenge
    36 - WorkRemote
    37 - WorkLoc
    38 - ImpSyn
    39 - CodeRev
    40 - CodeRevHrs
    41 - UnitTests
    42 - PurchaseHow
    43 - PurchaseWhat
    44 - linguagemWorkedWith
    45 - linguagemDesireNextYear
    46 - DatabaseWorkedWith
    47 - DatabaseDesireNextYear
    48 - PlatformWorkedWith
    49 - PlatformDesireNextYear
    50 - WebFrameWorkedWith
    51 - WebFrameDesireNextYear
    52 - MiscTechWorkedWith
    53 - MiscTechDesireNextYear
    54 - DevEnviron
    55 - OpSys
    56 - Containers
    57 - BlockchainOrg
    58 - BlockchainIs
    59 - BetterLife
    60 - ITperson
    61 - OffOn
    62 - SocialMedia
    63 - Extraversion
    64 - ScreenName
    65 - SOVisit1st
    66 - SOVisitFreq
    67 - SOVisitTo
    68 - SOFindAnswer
    69 - SOTimeSaved
    70 - SOHowMuchTime
    71 - SOAccount
    72 - SOPartFreq
    73 - SOJobs
    74 - EntTeams
    75 - SOComm
    76 - WelcomeChange
    77 - SONewContent
    78 - Age
    79 - Gender
    80 - Trans
    81 - Sexuality
    82 - Ethnicity
    83 - Dependents
    84 - SurveyLength
    85 - SurveyEase
*/
delete
from RESPOSTA_LINGUAGEM;
delete
from Resposta_Cargo;
delete
from Resposta;

DECLARE
    file_handle            UTL_FILE.FILE_TYPE;
    line_buffer            VARCHAR2(8000);
    unique_id              NUMBER;
    resposta_id            NUMBER;
    is_first_line          BOOLEAN := TRUE;
    v_idade                VARCHAR2(512);
    v_workremote           VARCHAR2(512);
    v_Formacao             VARCHAR2(512);
    v_yearscode            VARCHAR2(512);
    v_pais                 VARCHAR2(512);
    v_Cargo                VARCHAR2(512);
    v_Moeda                VARCHAR2(512);
    v_totalcomp            VARCHAR2(512);
    v_linguagemsworkedwith VARCHAR2(512);
BEGIN
    file_handle := UTL_FILE.FOPEN('DATASETS_2019', 'survey_results_public.csv', 'R', 32767);
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(file_handle, line_buffer);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;

        IF is_first_line THEN
            is_first_line := FALSE;
            CONTINUE;
        END IF;
        unique_id := Resposta_seq.NEXTVAL;
        resposta_id := TO_NUMBER(REGEXP_SUBSTR(line_buffer, '^[^,]+'));

        v_idade := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 78);
        v_workremote := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 37);
        v_Formacao := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 9);
        v_yearscode := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 14);
        v_pais := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 7);
        v_Cargo := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 13);
        v_Moeda := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 28);
        v_totalcomp := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 30);
        v_linguagemsworkedwith := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 44);

        IF v_totalcomp = 'NA' THEN
            v_totalcomp := NULL;
        END IF;
        IF v_yearscode = 'NA' THEN
            v_yearscode := NULL;
        END IF;

        --         DBMS_OUTPUT.PUT_LINE('OK Idade: ' || v_age);
--         DBMS_OUTPUT.PUT_LINE('OK Trabalho remoto: ' || v_workremote);
--         DBMS_OUTPUT.PUT_LINE('OK Grau de educação: ' || v_Formacao);
--         DBMS_OUTPUT.PUT_LINE('OK Anos programando: ' || v_yearscode);
--         DBMS_OUTPUT.PUT_LINE('OK País: ' || v_pais);
--         DBMS_OUTPUT.PUT_LINE('OK Cargo: ' || v_Cargo);
--         DBMS_OUTPUT.PUT_LINE('OK Moeda: ' || v_Moeda);
--         DBMS_OUTPUT.PUT_LINE('OK Salário: ' || v_totalcomp);
--         DBMS_OUTPUT.PUT_LINE('OK Linguagens trabalhadas: ' || v_linguagemsworkedwith);

        -- Faixa etária
--         IF v_age IS NOT NULL AND v_age <> '' THEN
--             IF REGEXP_LIKE(v_age, '^[0-9]+-[0-9]+$') THEN
--                 v_age_start := TO_NUMBER(REGEXP_SUBSTR(v_age, '^[0-9]+'));
--                 v_age_end := TO_NUMBER(REGEXP_SUBSTR(v_age, '[0-9]+$'));
--             ELSE
--                 v_age_start := NULL;
--                 v_age_end := NULL;
--             END IF;
--             IF v_age_start IS NOT NULL AND v_age_end IS NOT NULL THEN
--                 BEGIN
--                     INSERT INTO AgeGroup (id, age_start, age_end)
--                     SELECT AgeGroup_Seq.NEXTVAL, v_age_start, v_age_end FROM dual
--                     WHERE NOT EXISTS (
--                         SELECT 1 FROM AgeGroup WHERE age_start = v_age_start AND age_end = v_age_end
--                     );
--                 EXCEPTION WHEN OTHERS THEN NULL; END;
--             END IF;

        -- Remoto/Híbrido (se null então é presencial, dá pra tratar em consultas)
        BEGIN
            IF v_workremote IS NOT NULL AND LENGTH(TRIM(v_workremote)) > 0 THEN
                INSERT INTO TrabalhoRemoto (id, trabalho_remoto)
                SELECT TrabalhoRemoto_Seq.NEXTVAL, v_workremote
                FROM dual
                WHERE NOT EXISTS (SELECT 1
                                  FROM TrabalhoRemoto
                                  WHERE trabalho_remoto = v_workremote);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;

        -- Formação
        BEGIN
            IF v_Formacao IS NOT NULL AND LENGTH(TRIM(v_Formacao)) > 0 THEN
                INSERT INTO Formacao (id, formacao)
                SELECT Formacao_Seq.NEXTVAL, v_Formacao
                FROM dual
                WHERE NOT EXISTS (SELECT 1
                                  FROM Formacao
                                  WHERE formacao = v_Formacao);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;

        -- País
        BEGIN
            IF v_pais IS NOT NULL AND LENGTH(TRIM(v_pais)) > 0 THEN
                INSERT INTO pais (id, pais)
                SELECT pais_Seq.NEXTVAL, v_pais
                FROM dual
                WHERE NOT EXISTS (SELECT 1
                                  FROM pais
                                  WHERE pais = v_pais);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;

        -- Moeda
        BEGIN
            IF v_Moeda IS NOT NULL AND LENGTH(TRIM(v_Moeda)) > 0 THEN
                INSERT INTO Moeda (id, Moeda)
                SELECT Moeda_Seq.NEXTVAL, v_Moeda
                FROM dual
                WHERE NOT EXISTS (SELECT 1
                                  FROM Moeda
                                  WHERE Moeda = v_Moeda);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;

        -- ID USUÁRIO
        -- Precisar inserir com o ano (hardcode 2019) pois o ID é unique para ano, mas a combinação não
        INSERT INTO Resposta (id,
                              resposta,
                              ano,
                              salario_anual,
                              anos_programando,
                              trabalho_remoto_id,
                              pais_id,
                              moeda_id,
                              formacao_id)
        VALUES (unique_id, resposta_id, 2019,
                v_totalcomp, v_yearscode,
                (SELECT id FROM TrabalhoRemoto WHERE trabalho_remoto = v_workremote),
                (SELECT id FROM Pais WHERE pais = v_pais),
                (SELECT id FROM Moeda WHERE moeda = v_Moeda),
                (SELECT id FROM Formacao WHERE formacao = v_Formacao));

        -- Linguagens
        BEGIN
            IF v_linguagemsworkedwith IS NOT NULL AND LENGTH(TRIM(v_linguagemsworkedwith)) > 0 THEN
                FOR lang IN (
                    SELECT TRIM(REGEXP_SUBSTR(v_linguagemsworkedwith, '[^;]+', 1, LEVEL)) AS linguagem
                    FROM dual
                    CONNECT BY REGEXP_SUBSTR(v_linguagemsworkedwith, '[^;]+', 1, LEVEL) IS NOT NULL
                    )
                    LOOP
                        INSERT INTO LINGUAGEM (id, linguagem)
                        SELECT LINGUAGEM_SEQ.NEXTVAL, lang.linguagem
                        FROM dual
                        WHERE NOT EXISTS (SELECT 1
                                          FROM linguagem
                                          WHERE linguagem = lang.linguagem);

                        INSERT INTO Resposta_linguagem (resposta_id, linguagem_id)
                        VALUES (unique_id, (SELECT id FROM linguagem WHERE linguagem = lang.linguagem));


                    END LOOP;
            END IF;
        END;

        -- Cargo
        BEGIN
            IF v_Cargo IS NOT NULL AND LENGTH(TRIM(v_Cargo)) > 0 THEN
                FOR dev IN (
                    SELECT TRIM(REGEXP_SUBSTR(v_Cargo, '[^;]+', 1, LEVEL)) AS cargo
                    FROM dual
                    CONNECT BY REGEXP_SUBSTR(v_Cargo, '[^;]+', 1, LEVEL) IS NOT NULL
                    )
                    LOOP
                        INSERT INTO Cargo (id, cargo)
                        SELECT Cargo_SEQ.NEXTVAL, dev.cargo
                        FROM dual
                        WHERE NOT EXISTS (SELECT 1
                                          FROM Cargo
                                          WHERE cargo = dev.cargo);

                        INSERT INTO Resposta_Cargo (resposta_id, cargo_id)
                        VALUES (unique_id, (SELECT id FROM Cargo WHERE cargo = dev.cargo));
                    END LOOP;
            END IF;
        END;

    END LOOP;
    UTL_FILE.FCLOSE(file_handle);
END;
/
COMMIT;
