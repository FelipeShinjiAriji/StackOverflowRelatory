DECLARE
    file_handle UTL_FILE.FILE_TYPE;
    line_buffer VARCHAR2(8000);
    respondent_id NUMBER;
    is_first_line BOOLEAN := TRUE;
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

        respondent_id := TO_NUMBER(REGEXP_SUBSTR(line_buffer, '^[^,]+'));

        INSERT INTO Respondent (id, respondent_id, year)
        VALUES (respondent_seq.NEXTVAL, respondent_id, 2019);
    END LOOP;
    UTL_FILE.FCLOSE(file_handle);
END;
/
COMMIT;
