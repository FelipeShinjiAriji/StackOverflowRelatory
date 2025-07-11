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

DECLARE
    file_handle          UTL_FILE.FILE_TYPE;
    line_buffer          VARCHAR2(32767);
    unique_id            NUMBER;
    resposta_id          NUMBER;
    is_first_line        BOOLEAN := TRUE;
    v_idade              VARCHAR2(512);
    v_trabalho_remoto    VARCHAR2(512);
    v_formacao           VARCHAR2(512);
    v_yearscode          VARCHAR2(512);
    v_pais               VARCHAR2(512);
    v_cargo              VARCHAR2(1024);
    v_moeda              VARCHAR2(512);
    v_salario_anual      VARCHAR2(512);
    v_linguagens         VARCHAR2(512);
    v_trabalho_remoto_id NUMBER;
    v_formacao_id        NUMBER;
    v_pais_id            NUMBER;
    v_moeda_id           NUMBER;
    v_faixa_etaria_id    NUMBER;
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
        v_trabalho_remoto := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 37);
        v_formacao := MAP_FORMACAO(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 9));
        v_yearscode := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 14);
        v_pais := MAP_COUNTRY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 7));
        v_cargo := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 13);
        v_moeda := MAP_CURRENCY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 28));
        v_salario_anual := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 30);
        v_linguagens := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 44);

        IF NOT IS_VALID_VALUE(v_salario_anual) THEN
            v_salario_anual := NULL;
        END IF;

        v_yearscode := MAP_YEARS_OF_PROGRAMMING(v_yearscode);
        v_faixa_etaria_id := PROCESS_AGE_SINGLE(v_idade);
        v_trabalho_remoto_id := INSERT_TRABALHO_REMOTO(v_trabalho_remoto);
        v_formacao_id := INSERT_FORMACAO(v_formacao);
        v_pais_id := INSERT_PAIS(v_pais);
        v_moeda_id := INSERT_MOEDA(v_moeda);

        INSERT INTO Resposta (id,
                              resposta,
                              ano,
                              salario_anual,
                              anos_programando,
                              trabalho_remoto_id,
                              pais_id,
                              moeda_id,
                              formacao_id,
                              faixa_etaria_id)
        VALUES (unique_id, resposta_id, 2019,
                v_salario_anual, v_yearscode,
                v_trabalho_remoto_id,
                v_pais_id,
                v_moeda_id,
                v_formacao_id,
                v_faixa_etaria_id);

        INSERT_LINGUAGENS(unique_id, v_linguagens);
        INSERT_CARGOS(unique_id, v_cargo);

    END LOOP;
    UTL_FILE.FCLOSE(file_handle);
END;
/
COMMIT;
