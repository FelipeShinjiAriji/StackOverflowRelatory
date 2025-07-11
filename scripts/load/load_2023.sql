/*
    1 - ResponseId
    2 - Q120
    3 - MainBranch
    4 - Age
    5 - Employment
    6 - RemoteWork
    7 - CodingActivities
    8 - EdLevel
    9 - LearnCode
    10 - LearnCodeOnline
    11 - LearnCodeCoursesCert
    12 - YearsCode
    13 - YearsCodePro
    14 - DevType
    15 - OrgSize
    16 - PurchaseInfluence
    17 - TechList
    18 - BuyNewTool
    19 - Country
    20 - Currency
    21 - CompTotal
    22 - LanguageHaveWorkedWith
    23 - LanguageWantToWorkWith
    24 - DatabaseHaveWorkedWith
    25 - DatabaseWantToWorkWith
    26 - PlatformHaveWorkedWith
    27 - PlatformWantToWorkWith
    28 - WebframeHaveWorkedWith
    29 - WebframeWantToWorkWith
    30 - MiscTechHaveWorkedWith
    31 - MiscTechWantToWorkWith
    32 - ToolsTechHaveWorkedWith
    33 - ToolsTechWantToWorkWith
    34 - NEWCollabToolsHaveWorkedWith
    35 - NEWCollabToolsWantToWorkWith
    36 - OpSysPersonal use
    37 - OpSysProfessional use
    38 - OfficeStackAsyncHaveWorkedWith
    39 - OfficeStackAsyncWantToWorkWith
    40 - OfficeStackSyncHaveWorkedWith
    41 - OfficeStackSyncWantToWorkWith
    42 - AISearchHaveWorkedWith
    43 - AISearchWantToWorkWith
    44 - AIDevHaveWorkedWith
    45 - AIDevWantToWorkWith
    46 - NEWSOSites
    47 - SOVisitFreq
    48 - SOAccount
    49 - SOPartFreq
    50 - SOComm
    51 - SOAI
    52 - AISelect
    53 - AISent
    54 - AIAcc
    55 - AIBen
    56 - AIToolInterested in Using
    57 - AIToolCurrently Using
    58 - AIToolNot interested in Using
    59 - AINextVery different
    60 - AINextNeither different nor similar
    61 - AINextSomewhat similar
    62 - AINextVery similar
    63 - AINextSomewhat different
    64 - TBranch
    65 - ICorPM
    66 - WorkExp
    67 - Knowledge_1
    68 - Knowledge_2
    69 - Knowledge_3
    70 - Knowledge_4
    71 - Knowledge_5
    72 - Knowledge_6
    73 - Knowledge_7
    74 - Knowledge_8
    75 - Frequency_1
    76 - Frequency_2
    77 - Frequency_3
    78 - TimeSearching
    79 - TimeAnswering
    80 - ProfessionalTech
    81 - Industry
    82 - SurveyLength
    83 - SurveyEase
    84 - ConvertedCompYearly
*/

DECLARE
    file_handle          UTL_FILE.FILE_TYPE;
    line_buffer          VARCHAR2(16000);
    unique_id            NUMBER;
    resposta_id          NUMBER;
    is_first_line        BOOLEAN := TRUE;
    v_idade              VARCHAR2(512);
    v_trabalho_remoto    VARCHAR2(512);
    v_formacao           VARCHAR2(512);
    v_yearscode          VARCHAR2(512);
    v_pais               VARCHAR2(512);
    v_cargo              VARCHAR2(512);
    v_moeda              VARCHAR2(512);
    v_salario_anual      VARCHAR2(512);
    v_linguagens         VARCHAR2(512);
    v_trabalho_remoto_id NUMBER;
    v_formacao_id        NUMBER;
    v_pais_id            NUMBER;
    v_moeda_id           NUMBER;
    v_faixa_etaria_id    NUMBER;
BEGIN
    file_handle := UTL_FILE.FOPEN('DATASETS_2023', 'survey_results_public.csv', 'R', 32767);
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
        v_trabalho_remoto := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 6);
        v_formacao := MAP_FORMACAO(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 8));
        v_yearscode := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 12);
        v_pais := MAP_COUNTRY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 19));
        v_cargo := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 14);
        v_moeda := MAP_CURRENCY(REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 20));
        v_salario_anual := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 21);
        v_linguagens := REGEXP_SUBSTR(line_buffer, '"[^"]*"|[^,]+', 1, 22);

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
        VALUES (unique_id, resposta_id, 2023,
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
