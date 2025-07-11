/*
    1 - ResponseId
    2 - MainBranch
    3 - Employment
    4 - Country
    5 - US_State
    6 - UK_Country
    7 - EdLevel
    8 - Age1stCode
    9 - LearnCode
    10 - YearsCode
    11 - YearsCodePro
    12 - DevType
    13 - OrgSize
    14 - Currency
    15 - CompTotal
    16 - CompFreq
    17 - LanguageHaveWorkedWith
    18 - LanguageWantToWorkWith
    19 - DatabaseHaveWorkedWith
    20 - DatabaseWantToWorkWith
    21 - PlatformHaveWorkedWith
    22 - PlatformWantToWorkWith
    23 - WebframeHaveWorkedWith
    24 - WebframeWantToWorkWith
    25 - MiscTechHaveWorkedWith
    26 - MiscTechWantToWorkWith
    27 - ToolsTechHaveWorkedWith
    28 - ToolsTechWantToWorkWith
    29 - NEWCollabToolsHaveWorkedWith
    30 - NEWCollabToolsWantToWorkWith
    31 - OpSys
    32 - NEWStuck
    33 - NEWSOSites
    34 - SOVisitFreq
    35 - SOAccount
    36 - SOPartFreq
    37 - SOComm
    38 - NEWOtherComms
    39 - Age
    40 - Gender
    41 - Trans
    42 - Sexuality
    43 - Ethnicity
    44 - Accessibility
    45 - MentalHealth
    46 - SurveyLength
    47 - SurveyEase
    48 - ConvertedCompYearly
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
    file_handle := UTL_FILE.FOPEN('DATASETS_2021', 'survey_results_public.csv', 'R', 32767);
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

        IF is_first_line THEN
            is_first_line := FALSE;
            CONTINUE;
        END IF;

        unique_id := Resposta_seq.NEXTVAL;
        resposta_id := TO_NUMBER(REGEXP_SUBSTR(line_buffer, '^[^,]+'));

        v_idade := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 39);
        v_trabalho_remoto := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 3); -- Employment field
        v_formacao := MAP_FORMACAO(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 7));
        v_yearscode := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 10);
        v_pais := MAP_COUNTRY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 4));
        v_cargo := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 12);
        v_moeda := MAP_CURRENCY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 14));
        v_salario_anual := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 48); -- ConvertedCompYearly
        v_linguagens := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 17);

        IF NOT IS_VALID_VALUE(v_salario_anual) THEN
            v_salario_anual := NULL;
        END IF;

        v_yearscode := MAP_YEARS_OF_PROGRAMMING(v_yearscode);
        v_faixa_etaria_id := PROCESS_AGE_RANGE(v_idade);
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
        VALUES (unique_id, resposta_id, 2021,
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