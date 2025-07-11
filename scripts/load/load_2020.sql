/*
    1 - Respondent
    2 - MainBranch
    3 - Hobbyist
    4 - Age
    5 - Age1stCode
    6 - CompFreq
    7 - CompTotal
    8 - ConvertedComp
    9 - Country
    10 - CurrencyDesc
    11 - CurrencySymbol
    12 - DatabaseDesireNextYear
    13 - DatabaseWorkedWith
    14 - DevType
    15 - EdLevel
    16 - Employment
    17 - Ethnicity
    18 - Gender
    19 - JobFactors
    20 - JobSat
    21 - JobSeek
    22 - LanguageDesireNextYear
    23 - LanguageWorkedWith
    24 - MiscTechDesireNextYear
    25 - MiscTechWorkedWith
    26 - NEWCollabToolsDesireNextYear
    27 - NEWCollabToolsWorkedWith
    28 - NEWDevOps
    29 - NEWDevOpsImpt
    30 - NEWEdImpt
    31 - NEWJobHunt
    32 - NEWJobHuntResearch
    33 - NEWLearn
    34 - NEWOffTopic
    35 - NEWOnboardGood
    36 - NEWOtherComms
    37 - NEWOvertime
    38 - NEWPurchaseResearch
    39 - NEWPurpleLink
    40 - NEWSOSites
    41 - NEWStuck
    42 - OpSys
    43 - OrgSize
    44 - PlatformDesireNextYear
    45 - PlatformWorkedWith
    46 - PurchaseWhat
    47 - Sexuality
    48 - SOAccount
    49 - SOComm
    50 - SOPartFreq
    51 - SOVisitFreq
    52 - SurveyEase
    53 - SurveyLength
    54 - Trans
    55 - UndergradMajor
    56 - WebframeDesireNextYear
    57 - WebframeWorkedWith
    58 - WelcomeChange
    59 - WorkWeekHrs
    60 - YearsCode
    61 - YearsCodePro
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
    file_handle := UTL_FILE.FOPEN('DATASETS_2020', 'survey_results_public.csv', 'R', 32767);
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

        v_idade := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 4);
        v_trabalho_remoto := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 16);
        v_formacao := MAP_FORMACAO(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 15));
        v_yearscode := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 60);
        v_pais := MAP_COUNTRY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 9));
        v_cargo := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 14);
        v_moeda := MAP_CURRENCY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 10));
        v_salario_anual := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 8);
        v_linguagens := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 23);

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
        VALUES (unique_id, resposta_id, 2020,
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