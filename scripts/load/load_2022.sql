/*
    1 - ResponseId
    2 - MainBranch
    3 - Employment
    4 - RemoteWork
    5 - CodingActivities
    6 - EdLevel
    7 - LearnCode
    8 - LearnCodeOnline
    9 - LearnCodeCoursesCert
    10 - YearsCode
    11 - YearsCodePro
    12 - DevType
    13 - OrgSize
    14 - PurchaseInfluence
    15 - BuyNewTool
    16 - Country
    17 - Currency
    18 - CompTotal
    19 - CompFreq
    20 - LanguageHaveWorkedWith
    21 - LanguageWantToWorkWith
    22 - DatabaseHaveWorkedWith
    23 - DatabaseWantToWorkWith
    24 - PlatformHaveWorkedWith
    25 - PlatformWantToWorkWith
    26 - WebframeHaveWorkedWith
    27 - WebframeWantToWorkWith
    28 - MiscTechHaveWorkedWith
    29 - MiscTechWantToWorkWith
    30 - ToolsTechHaveWorkedWith
    31 - ToolsTechWantToWorkWith
    32 - NEWCollabToolsHaveWorkedWith
    33 - NEWCollabToolsWantToWorkWith
    34 - OpSysProfessional use
    35 - OpSysPersonal use
    36 - VersionControlSystem
    37 - VCInteraction
    38 - VCHostingPersonal use
    39 - VCHostingProfessional use
    40 - OfficeStackAsyncHaveWorkedWith
    41 - OfficeStackAsyncWantToWorkWith
    42 - OfficeStackSyncHaveWorkedWith
    43 - OfficeStackSyncWantToWorkWith
    44 - Blockchain
    45 - NEWSOSites
    46 - SOVisitFreq
    47 - SOAccount
    48 - SOPartFreq
    49 - SOComm
    50 - Age
    51 - Gender
    52 - Trans
    53 - Sexuality
    54 - Ethnicity
    55 - Accessibility
    56 - MentalHealth
    57 - TBranch
    58 - ICorPM
    59 - WorkExp
    60 - Knowledge_1
    61 - Knowledge_2
    62 - Knowledge_3
    63 - Knowledge_4
    64 - Knowledge_5
    65 - Knowledge_6
    66 - Knowledge_7
    67 - Frequency_1
    68 - Frequency_2
    69 - Frequency_3
    70 - TimeSearching
    71 - TimeAnswering
    72 - Onboarding
    73 - ProfessionalTech
    74 - TrueFalse_1
    75 - TrueFalse_2
    76 - TrueFalse_3
    77 - SurveyLength
    78 - SurveyEase
    79 - ConvertedCompYearly
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
    v_anos_programando   VARCHAR2(512);
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
    file_handle := UTL_FILE.FOPEN('DATASETS_2022', 'survey_results_public.csv', 'R', 32767);
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

        v_idade := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 48);
        v_trabalho_remoto := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 4);
        v_formacao := MAP_FORMACAO(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 6));
        v_anos_programando := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 10);
        v_pais := MAP_COUNTRY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 16));
        v_cargo := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 12);
        v_moeda := MAP_CURRENCY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 17));
        v_salario_anual := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 18);
        v_linguagens := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 20);

        IF NOT IS_VALID_VALUE(v_salario_anual) THEN
            v_salario_anual := NULL;
        END IF;

        v_anos_programando := MAP_YEARS_OF_PROGRAMMING(v_anos_programando);
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
        VALUES (unique_id, resposta_id, 2022,
                v_salario_anual, v_anos_programando,
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