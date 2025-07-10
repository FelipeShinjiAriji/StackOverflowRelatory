DECLARE
    file_handle UTL_FILE.FILE_TYPE;
    line_buffer VARCHAR2(4000);
    Resposta_id NUMBER;
    is_first_line BOOLEAN := TRUE;
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

        Resposta_id := TO_NUMBER(REGEXP_SUBSTR(line_buffer, '^[^,]+'));

        INSERT INTO Resposta (id, Resposta_id, year)
        VALUES (Resposta_seq.NEXTVAL, Resposta_id, 2023);
    END LOOP;
    UTL_FILE.FCLOSE(file_handle);
END;
/
COMMIT;
