CREATE OR REPLACE FUNCTION MAP_CURRENCY(p_currency VARCHAR2) 
RETURN VARCHAR2 IS
    v_mapped_currency VARCHAR2(32);
BEGIN
    IF p_currency IS NULL OR LENGTH(TRIM(p_currency)) = 0 THEN
        RETURN NULL;
    END IF;
    
    v_mapped_currency := CASE 
        WHEN UPPER(p_currency) LIKE '%UNITED STATES DOLLAR%' OR UPPER(p_currency) = 'USD' THEN 'USD'
        WHEN UPPER(p_currency) LIKE '%EUROPEAN EURO%' OR UPPER(p_currency) LIKE '%EURO%' OR UPPER(p_currency) = 'EUR' THEN 'EUR'
        WHEN UPPER(p_currency) LIKE '%POUND STERLING%' OR UPPER(p_currency) = 'GBP' THEN 'GBP'
        WHEN UPPER(p_currency) LIKE '%AUSTRALIAN DOLLAR%' OR UPPER(p_currency) = 'AUD' THEN 'AUD'
        WHEN UPPER(p_currency) LIKE '%CANADIAN DOLLAR%' OR UPPER(p_currency) = 'CAD' THEN 'CAD'
        WHEN UPPER(p_currency) LIKE '%SWISS FRANC%' OR UPPER(p_currency) = 'CHF' THEN 'CHF'
        WHEN UPPER(p_currency) LIKE '%JAPANESE YEN%' OR UPPER(p_currency) = 'JPY' THEN 'JPY'
        WHEN UPPER(p_currency) LIKE '%CHINESE YUAN%' OR UPPER(p_currency) LIKE '%CHINESE YUAN RENMINBI%' OR UPPER(p_currency) = 'CNY' THEN 'CNY'
        WHEN UPPER(p_currency) LIKE '%NEW ZEALAND DOLLAR%' OR UPPER(p_currency) = 'NZD' THEN 'NZD'
        WHEN UPPER(p_currency) LIKE '%SINGAPORE DOLLAR%' OR UPPER(p_currency) = 'SGD' THEN 'SGD'
        WHEN UPPER(p_currency) LIKE '%HONG KONG DOLLAR%' OR UPPER(p_currency) = 'HKD' THEN 'HKD'
        WHEN UPPER(p_currency) LIKE '%SOUTH KOREAN WON%' OR UPPER(p_currency) = 'KRW' THEN 'KRW'
        WHEN UPPER(p_currency) LIKE '%NORWEGIAN KRONE%' OR UPPER(p_currency) = 'NOK' THEN 'NOK'
        WHEN UPPER(p_currency) LIKE '%SWEDISH KRONA%' OR UPPER(p_currency) = 'SEK' THEN 'SEK'
        WHEN UPPER(p_currency) LIKE '%DANISH KRONE%' OR UPPER(p_currency) = 'DKK' THEN 'DKK'
        WHEN UPPER(p_currency) LIKE '%ICELANDIC KRONA%' OR UPPER(p_currency) = 'ISK' THEN 'ISK'
        WHEN UPPER(p_currency) LIKE '%CZECH KORUNA%' OR UPPER(p_currency) = 'CZK' THEN 'CZK'
        WHEN UPPER(p_currency) LIKE '%HUNGARIAN FORINT%' OR UPPER(p_currency) = 'HUF' THEN 'HUF'
        WHEN UPPER(p_currency) LIKE '%POLISH ZLOTY%' OR UPPER(p_currency) = 'PLN' THEN 'PLN'
        WHEN UPPER(p_currency) LIKE '%ROMANIAN LEU%' OR UPPER(p_currency) = 'RON' THEN 'RON'
        WHEN UPPER(p_currency) LIKE '%BULGARIAN LEV%' OR UPPER(p_currency) = 'BGN' THEN 'BGN'
        WHEN UPPER(p_currency) LIKE '%CROATIAN KUNA%' OR UPPER(p_currency) = 'HRK' THEN 'HRK'
        WHEN UPPER(p_currency) LIKE '%SERBIAN DINAR%' OR UPPER(p_currency) = 'RSD' THEN 'RSD'
        WHEN UPPER(p_currency) LIKE '%MACEDONIAN DENAR%' OR UPPER(p_currency) = 'MKD' THEN 'MKD'
        WHEN UPPER(p_currency) LIKE '%MOLDOVAN LEU%' OR UPPER(p_currency) = 'MDL' THEN 'MDL'
        WHEN UPPER(p_currency) LIKE '%ALBANIAN LEK%' OR UPPER(p_currency) = 'ALL' THEN 'ALL'
        WHEN UPPER(p_currency) LIKE '%BOSNIA AND HERZEGOVINA CONVERTIBLE MARK%' OR UPPER(p_currency) = 'BAM' THEN 'BAM'
        WHEN UPPER(p_currency) LIKE '%UKRAINIAN HRYVNIA%' OR UPPER(p_currency) = 'UAH' THEN 'UAH'
        WHEN UPPER(p_currency) LIKE '%RUSSIAN RUBLE%' OR UPPER(p_currency) = 'RUB' THEN 'RUB'
        WHEN UPPER(p_currency) LIKE '%BELARUSIAN RUBLE%' OR UPPER(p_currency) = 'BYN' THEN 'BYN'
        WHEN UPPER(p_currency) LIKE '%KAZAKHSTANI TENGE%' OR UPPER(p_currency) = 'KZT' THEN 'KZT'
        WHEN UPPER(p_currency) LIKE '%UZBEKISTANI SOM%' OR UPPER(p_currency) = 'UZS' THEN 'UZS'
        WHEN UPPER(p_currency) LIKE '%KYRGYZSTANI SOM%' OR UPPER(p_currency) = 'KGS' THEN 'KGS'
        WHEN UPPER(p_currency) LIKE '%TAJIKISTANI SOMONI%' OR UPPER(p_currency) = 'TJS' THEN 'TJS'
        WHEN UPPER(p_currency) LIKE '%TURKMEN MANAT%' OR UPPER(p_currency) = 'TMT' THEN 'TMT'
        WHEN UPPER(p_currency) LIKE '%ARMENIAN DRAM%' OR UPPER(p_currency) = 'AMD' THEN 'AMD'
        WHEN UPPER(p_currency) LIKE '%AZERBAIJAN MANAT%' OR UPPER(p_currency) = 'AZN' THEN 'AZN'
        WHEN UPPER(p_currency) LIKE '%GEORGIAN LARI%' OR UPPER(p_currency) = 'GEL' THEN 'GEL'
        WHEN UPPER(p_currency) LIKE '%TURKISH LIRA%' OR UPPER(p_currency) = 'TRY' THEN 'TRY'
        WHEN UPPER(p_currency) LIKE '%ISRAELI NEW SHEKEL%' OR UPPER(p_currency) = 'ILS' THEN 'ILS'
        WHEN UPPER(p_currency) LIKE '%SAUDI ARABIAN RIYAL%' OR UPPER(p_currency) = 'SAR' THEN 'SAR'
        WHEN UPPER(p_currency) LIKE '%UNITED ARAB EMIRATES DIRHAM%' OR UPPER(p_currency) = 'AED' THEN 'AED'
        WHEN UPPER(p_currency) LIKE '%QATARI RIYAL%' OR UPPER(p_currency) = 'QAR' THEN 'QAR'
        WHEN UPPER(p_currency) LIKE '%KUWAITI DINAR%' OR UPPER(p_currency) = 'KWD' THEN 'KWD'
        WHEN UPPER(p_currency) LIKE '%BAHRAIN DINAR%' OR UPPER(p_currency) = 'BHD' THEN 'BHD'
        WHEN UPPER(p_currency) LIKE '%OMANI RIAL%' OR UPPER(p_currency) = 'OMR' THEN 'OMR'
        WHEN UPPER(p_currency) LIKE '%JORDANIAN DINAR%' OR UPPER(p_currency) = 'JOD' THEN 'JOD'
        WHEN UPPER(p_currency) LIKE '%LEBANESE POUND%' OR UPPER(p_currency) = 'LBP' THEN 'LBP'
        WHEN UPPER(p_currency) LIKE '%SYRIAN POUND%' OR UPPER(p_currency) = 'SYP' THEN 'SYP'
        WHEN UPPER(p_currency) LIKE '%IRAQI DINAR%' OR UPPER(p_currency) = 'IQD' THEN 'IQD'
        WHEN UPPER(p_currency) LIKE '%IRANIAN RIAL%' OR UPPER(p_currency) = 'IRR' THEN 'IRR'
        WHEN UPPER(p_currency) LIKE '%YEMENI RIAL%' OR UPPER(p_currency) = 'YER' THEN 'YER'
        WHEN UPPER(p_currency) LIKE '%EGYPTIAN POUND%' OR UPPER(p_currency) = 'EGP' THEN 'EGP'
        WHEN UPPER(p_currency) LIKE '%SUDANESE POUND%' OR UPPER(p_currency) = 'SDG' THEN 'SDG'
        WHEN UPPER(p_currency) LIKE '%SOUTH SUDANESE POUND%' OR UPPER(p_currency) = 'SSP' THEN 'SSP'
        WHEN UPPER(p_currency) LIKE '%LIBYAN DINAR%' OR UPPER(p_currency) = 'LYD' THEN 'LYD'
        WHEN UPPER(p_currency) LIKE '%TUNISIAN DINAR%' OR UPPER(p_currency) = 'TND' THEN 'TND'
        WHEN UPPER(p_currency) LIKE '%ALGERIAN DINAR%' OR UPPER(p_currency) = 'DZD' THEN 'DZD'
        WHEN UPPER(p_currency) LIKE '%MOROCCAN DIRHAM%' OR UPPER(p_currency) = 'MAD' THEN 'MAD'
        WHEN UPPER(p_currency) LIKE '%MAURITANIAN OUGUIYA%' OR UPPER(p_currency) = 'MRU' THEN 'MRU'
        WHEN UPPER(p_currency) LIKE '%WEST AFRICAN CFA FRANC%' OR UPPER(p_currency) = 'XOF' THEN 'XOF'
        WHEN UPPER(p_currency) LIKE '%CENTRAL AFRICAN CFA FRANC%' OR UPPER(p_currency) = 'XAF' THEN 'XAF'
        WHEN UPPER(p_currency) LIKE '%CFP FRANC%' OR UPPER(p_currency) = 'XPF' THEN 'XPF'
        WHEN UPPER(p_currency) LIKE '%NIGERIAN NAIRA%' OR UPPER(p_currency) = 'NGN' THEN 'NGN'
        WHEN UPPER(p_currency) LIKE '%GHANAIAN CEDI%' OR UPPER(p_currency) = 'GHS' THEN 'GHS'
        WHEN UPPER(p_currency) LIKE '%KENYAN SHILLING%' OR UPPER(p_currency) = 'KES' THEN 'KES'
        WHEN UPPER(p_currency) LIKE '%UGANDAN SHILLING%' OR UPPER(p_currency) = 'UGX' THEN 'UGX'
        WHEN UPPER(p_currency) LIKE '%TANZANIAN SHILLING%' OR UPPER(p_currency) = 'TZS' THEN 'TZS'
        WHEN UPPER(p_currency) LIKE '%RWANDAN FRANC%' OR UPPER(p_currency) = 'RWF' THEN 'RWF'
        WHEN UPPER(p_currency) LIKE '%BURUNDI FRANC%' OR UPPER(p_currency) = 'BIF' THEN 'BIF'
        WHEN UPPER(p_currency) LIKE '%CONGOLESE FRANC%' OR UPPER(p_currency) = 'CDF' THEN 'CDF'
        WHEN UPPER(p_currency) LIKE '%DJIBOUTIAN FRANC%' OR UPPER(p_currency) = 'DJF' THEN 'DJF'
        WHEN UPPER(p_currency) LIKE '%COMORIAN FRANC%' OR UPPER(p_currency) = 'KMF' THEN 'KMF'
        WHEN UPPER(p_currency) LIKE '%ETHIOPIAN BIRR%' OR UPPER(p_currency) = 'ETB' THEN 'ETB'
        WHEN UPPER(p_currency) LIKE '%ERITREAN NAKFA%' OR UPPER(p_currency) = 'ERN' THEN 'ERN'
        WHEN UPPER(p_currency) LIKE '%SOMALI SHILLING%' OR UPPER(p_currency) = 'SOS' THEN 'SOS'
        WHEN UPPER(p_currency) LIKE '%SOUTH AFRICAN RAND%' OR UPPER(p_currency) = 'ZAR' THEN 'ZAR'
        WHEN UPPER(p_currency) LIKE '%NAMIBIAN DOLLAR%' OR UPPER(p_currency) = 'NAD' THEN 'NAD'
        WHEN UPPER(p_currency) LIKE '%BOTSWANA PULA%' OR UPPER(p_currency) = 'BWP' THEN 'BWP'
        WHEN UPPER(p_currency) LIKE '%LESOTHO LOTI%' OR UPPER(p_currency) = 'LSL' THEN 'LSL'
        WHEN UPPER(p_currency) LIKE '%SWAZI LILANGENI%' OR UPPER(p_currency) = 'SZL' THEN 'SZL'
        WHEN UPPER(p_currency) LIKE '%ZAMBIAN KWACHA%' OR UPPER(p_currency) = 'ZMW' THEN 'ZMW'
        WHEN UPPER(p_currency) LIKE '%MALAWIAN KWACHA%' OR UPPER(p_currency) = 'MWK' THEN 'MWK'
        WHEN UPPER(p_currency) LIKE '%MOZAMBIQUE METICAL%' OR UPPER(p_currency) = 'MZN' THEN 'MZN'
        WHEN UPPER(p_currency) LIKE '%MADAGASCAR ARIARY%' OR UPPER(p_currency) = 'MGA' THEN 'MGA'
        WHEN UPPER(p_currency) LIKE '%MAURITIAN RUPEE%' OR UPPER(p_currency) = 'MUR' THEN 'MUR'
        WHEN UPPER(p_currency) LIKE '%SEYCHELLES RUPEE%' OR UPPER(p_currency) = 'SCR' THEN 'SCR'
        WHEN UPPER(p_currency) LIKE '%INDIAN RUPEE%' OR UPPER(p_currency) = 'INR' THEN 'INR'
        WHEN UPPER(p_currency) LIKE '%PAKISTANI RUPEE%' OR UPPER(p_currency) = 'PKR' THEN 'PKR'
        WHEN UPPER(p_currency) LIKE '%BANGLADESHI TAKA%' OR UPPER(p_currency) = 'BDT' THEN 'BDT'
        WHEN UPPER(p_currency) LIKE '%SRI LANKAN RUPEE%' OR UPPER(p_currency) = 'LKR' THEN 'LKR'
        WHEN UPPER(p_currency) LIKE '%NEPALESE RUPEE%' OR UPPER(p_currency) = 'NPR' THEN 'NPR'
        WHEN UPPER(p_currency) LIKE '%BHUTANESE NGULTRUM%' OR UPPER(p_currency) = 'BTN' THEN 'BTN'
        WHEN UPPER(p_currency) LIKE '%MALDIVES RUFIYAA%' OR UPPER(p_currency) = 'MVR' THEN 'MVR'
        WHEN UPPER(p_currency) LIKE '%MYANMAR KYAT%' OR UPPER(p_currency) = 'MMK' THEN 'MMK'
        WHEN UPPER(p_currency) LIKE '%THAI BAHT%' OR UPPER(p_currency) = 'THB' THEN 'THB'
        WHEN UPPER(p_currency) LIKE '%VIETNAMESE DONG%' OR UPPER(p_currency) = 'VND' THEN 'VND'
        WHEN UPPER(p_currency) LIKE '%CAMBODIAN RIEL%' OR UPPER(p_currency) = 'KHR' THEN 'KHR'
        WHEN UPPER(p_currency) LIKE '%LAO KIP%' OR UPPER(p_currency) = 'LAK' THEN 'LAK'
        WHEN UPPER(p_currency) LIKE '%MONGOLIAN TUGRIK%' OR UPPER(p_currency) = 'MNT' THEN 'MNT'
        WHEN UPPER(p_currency) LIKE '%PHILIPPINE PESO%' OR UPPER(p_currency) = 'PHP' THEN 'PHP'
        WHEN UPPER(p_currency) LIKE '%MALAYSIAN RINGGIT%' OR UPPER(p_currency) = 'MYR' THEN 'MYR'
        WHEN UPPER(p_currency) LIKE '%INDONESIAN RUPIAH%' OR UPPER(p_currency) = 'IDR' THEN 'IDR'
        WHEN UPPER(p_currency) LIKE '%BRUNEI DOLLAR%' OR UPPER(p_currency) = 'BND' THEN 'BND'
        WHEN UPPER(p_currency) LIKE '%ARGENTINE PESO%' OR UPPER(p_currency) = 'ARS' THEN 'ARS'
        WHEN UPPER(p_currency) LIKE '%BRAZILIAN REAL%' OR UPPER(p_currency) = 'BRL' THEN 'BRL'
        WHEN UPPER(p_currency) LIKE '%CHILEAN PESO%' OR UPPER(p_currency) = 'CLP' THEN 'CLP'
        WHEN UPPER(p_currency) LIKE '%COLOMBIAN PESO%' OR UPPER(p_currency) = 'COP' THEN 'COP'
        WHEN UPPER(p_currency) LIKE '%PERUVIAN SOL%' OR UPPER(p_currency) = 'PEN' THEN 'PEN'
        WHEN UPPER(p_currency) LIKE '%BOLIVIAN BOLIVIANO%' OR UPPER(p_currency) = 'BOB' THEN 'BOB'
        WHEN UPPER(p_currency) LIKE '%VENEZUELAN BOLIVAR%' OR UPPER(p_currency) = 'VES' THEN 'VES'
        WHEN UPPER(p_currency) LIKE '%URUGUAYAN PESO%' OR UPPER(p_currency) = 'UYU' THEN 'UYU'
        WHEN UPPER(p_currency) LIKE '%PARAGUAYAN GUARANI%' OR UPPER(p_currency) = 'PYG' THEN 'PYG'
        WHEN UPPER(p_currency) LIKE '%MEXICAN PESO%' OR UPPER(p_currency) = 'MXN' THEN 'MXN'
        WHEN UPPER(p_currency) LIKE '%GUATEMALAN QUETZAL%' OR UPPER(p_currency) = 'GTQ' THEN 'GTQ'
        WHEN UPPER(p_currency) LIKE '%HONDURAN LEMPIRA%' OR UPPER(p_currency) = 'HNL' THEN 'HNL'
        WHEN UPPER(p_currency) LIKE '%NICARAGUAN CORDOBA%' OR UPPER(p_currency) = 'NIO' THEN 'NIO'
        WHEN UPPER(p_currency) LIKE '%COSTA RICAN COLON%' OR UPPER(p_currency) = 'CRC' THEN 'CRC'
        WHEN UPPER(p_currency) LIKE '%CUBAN PESO%' OR UPPER(p_currency) = 'CUP' THEN 'CUP'
        WHEN UPPER(p_currency) LIKE '%BAHAMIAN DOLLAR%' OR UPPER(p_currency) = 'BSD' THEN 'BSD'
        WHEN UPPER(p_currency) LIKE '%BERMUDIAN DOLLAR%' OR UPPER(p_currency) = 'BMD' THEN 'BMD'
        WHEN UPPER(p_currency) LIKE '%CAYMAN ISLANDS DOLLAR%' OR UPPER(p_currency) = 'KYD' THEN 'KYD'
        WHEN UPPER(p_currency) LIKE '%ARUBAN FLORIN%' OR UPPER(p_currency) = 'AWG' THEN 'AWG'
        WHEN UPPER(p_currency) LIKE '%NETHERLANDS ANTILLEAN GUILDER%' OR UPPER(p_currency) = 'ANG' THEN 'ANG'
        WHEN UPPER(p_currency) LIKE '%SURINAMESE DOLLAR%' OR UPPER(p_currency) = 'SRD' THEN 'SRD'
        WHEN UPPER(p_currency) LIKE '%GUYANESE DOLLAR%' OR UPPER(p_currency) = 'GYD' THEN 'GYD'
        WHEN UPPER(p_currency) LIKE '%FALKLAND ISLANDS POUND%' OR UPPER(p_currency) = 'FKP' THEN 'FKP'
        WHEN UPPER(p_currency) LIKE '%GIBRALTAR POUND%' OR UPPER(p_currency) = 'GIP' THEN 'GIP'
        WHEN UPPER(p_currency) LIKE '%JERSEY POUND%' OR UPPER(p_currency) = 'JEP' THEN 'JEP'
        WHEN UPPER(p_currency) LIKE '%MANX POUND%' OR UPPER(p_currency) = 'IMP' THEN 'IMP'
        WHEN UPPER(p_currency) LIKE '%FIJIAN DOLLAR%' OR UPPER(p_currency) = 'FJD' THEN 'FJD'
        WHEN UPPER(p_currency) LIKE '%TONGA PA''ANGA%' OR UPPER(p_currency) = 'TOP' THEN 'TOP'
        WHEN UPPER(p_currency) LIKE '%SAMOAN TALA%' OR UPPER(p_currency) = 'WST' THEN 'WST'
        WHEN UPPER(p_currency) LIKE '%VANUATU VATU%' OR UPPER(p_currency) = 'VUV' THEN 'VUV'
        WHEN UPPER(p_currency) LIKE '%LIBERIAN DOLLAR%' OR UPPER(p_currency) = 'LRD' THEN 'LRD'
        WHEN UPPER(p_currency) LIKE '%SIERRA LEONE LEONE%' OR UPPER(p_currency) = 'SLL' THEN 'SLL'
        WHEN UPPER(p_currency) LIKE '%MACANESE PATACA%' OR UPPER(p_currency) = 'MOP' THEN 'MOP'
        WHEN UPPER(p_currency) LIKE '%SPECIAL DRAWING RIGHTS%' OR UPPER(p_currency) = 'XDR' THEN 'XDR'
        WHEN UPPER(p_currency) LIKE '%EAST CARIBBEAN DOLLAR%' OR UPPER(p_currency) = 'XCD' THEN 'XCD'
        ELSE p_currency
    END;
    
    RETURN v_mapped_currency;
END MAP_CURRENCY;
/

CREATE OR REPLACE FUNCTION MAP_CURRENCY_TO_USD(p_currency VARCHAR2, p_amount NUMBER) 
RETURN NUMBER IS
    v_usd_amount NUMBER;
    v_mapped_currency VARCHAR2(32);
BEGIN
    IF p_amount IS NULL OR p_currency IS NULL OR LENGTH(TRIM(p_currency)) = 0 THEN
        RETURN NULL;
    END IF;
    
    v_mapped_currency := MAP_CURRENCY(p_currency);
    
    v_usd_amount := CASE 
        WHEN v_mapped_currency = 'USD' THEN p_amount
        WHEN v_mapped_currency = 'EUR' THEN p_amount * 1.08  
        WHEN v_mapped_currency = 'GBP' THEN p_amount * 1.27  
        WHEN v_mapped_currency = 'AUD' THEN p_amount * 0.66  
        WHEN v_mapped_currency = 'CAD' THEN p_amount * 0.74  
        WHEN v_mapped_currency = 'JPY' THEN p_amount * 0.007
        WHEN v_mapped_currency = 'CNY' THEN p_amount * 0.14 
        WHEN v_mapped_currency = 'BRL' THEN p_amount * 0.20  
    END;
    
    RETURN v_usd_amount;
END MAP_CURRENCY_TO_USD;
/

CREATE OR REPLACE FUNCTION MAP_COUNTRY(p_country VARCHAR2) 
RETURN VARCHAR2 IS
    v_mapped_country VARCHAR2(512);
BEGIN
    IF p_country IS NULL OR LENGTH(TRIM(p_country)) = 0 THEN
        RETURN NULL;
    END IF;
    
    v_mapped_country := CASE 
        WHEN UPPER(p_country) LIKE '%UNITED KINGDOM OF GREAT BRITAIN AND NORTHERN IRELAND%' THEN 'United Kingdom'
        WHEN UPPER(p_country) LIKE '%UNITED STATES OF AMERICA%' THEN 'United States'
        ELSE p_country
    END;
    
    RETURN v_mapped_country;
END MAP_COUNTRY;
/

CREATE OR REPLACE FUNCTION MAP_YEARS_OF_PROGRAMMING(p_years VARCHAR2) 
RETURN NUMBER IS
    v_mapped_years NUMBER;
BEGIN
    IF NOT IS_VALID_VALUE(p_years) THEN
        RETURN NULL;
    END IF;
    
    IF UPPER(TRIM(p_years)) LIKE '%LESS THAN 1 YEAR%' THEN 
        RETURN 0;
    END IF;
    
    BEGIN
        v_mapped_years := TO_NUMBER(TRIM(p_years));
        RETURN v_mapped_years;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
END MAP_YEARS_OF_PROGRAMMING;
/

CREATE OR REPLACE FUNCTION MAP_FORMACAO(p_formacao VARCHAR2) 
RETURN VARCHAR2 IS
    v_mapped_formacao VARCHAR2(128);
    v_clean_formacao VARCHAR2(128);
BEGIN
    IF NOT IS_VALID_VALUE(p_formacao) THEN
        RETURN NULL;
    END IF;
    
    v_clean_formacao := TRIM(REGEXP_REPLACE(p_formacao, '^["'']+|["'']+$', ''));
    
    v_mapped_formacao := CASE 
        WHEN UPPER(v_clean_formacao) LIKE '%ASSOCIATE DEGREE%' THEN
            'Associate degree'
            
        WHEN UPPER(v_clean_formacao) LIKE '%BACHELOR%' THEN
            'Bachelor''s degree'
            
        WHEN UPPER(v_clean_formacao) LIKE '%MASTER%' THEN
            'Master''s degree'
            
        WHEN UPPER(v_clean_formacao) LIKE '%DOCTORAL%' THEN
            'Doctoral degree'
            
        WHEN UPPER(v_clean_formacao) LIKE '%PROFESSIONAL%' THEN
            'Professional degree'
            
        WHEN UPPER(v_clean_formacao) LIKE '%SECONDARY SCHOOL%' then
            'Secondary school'
            
        WHEN UPPER(v_clean_formacao) LIKE '%PRIMARY%' THEN
            'Primary/elementary school'
            
        ELSE v_clean_formacao
    END;
    
    RETURN v_mapped_formacao;
END MAP_FORMACAO;
/

CREATE OR REPLACE FUNCTION CLEAN_CARGO(p_cargo VARCHAR2) 
RETURN VARCHAR2 IS
    v_clean_cargo VARCHAR2(512);
BEGIN
    IF p_cargo IS NULL OR LENGTH(TRIM(p_cargo)) = 0 THEN
        RETURN NULL;
    END IF;
    
    v_clean_cargo := TRIM(REGEXP_REPLACE(p_cargo, '^["'']+|["'']+$', ''));
    
    RETURN v_clean_cargo;
END CLEAN_CARGO;
/

CREATE OR REPLACE FUNCTION IS_VALID_VALUE(p_value VARCHAR2) 
RETURN BOOLEAN IS
BEGIN
    IF p_value IS NULL OR LENGTH(TRIM(p_value)) = 0 OR UPPER(TRIM(p_value)) = 'NA' THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END IS_VALID_VALUE;
/

CREATE OR REPLACE FUNCTION PROCESS_AGE_SINGLE(p_age IN VARCHAR2) RETURN NUMBER IS
    v_id NUMBER;
BEGIN
    IF NOT IS_VALID_VALUE(p_age) THEN
        RETURN NULL;
    END IF;
    BEGIN
        SELECT id INTO v_id FROM FaixaEtaria
        WHERE TO_NUMBER(p_age) BETWEEN inicio AND fim
        AND ROWNUM = 1;
        RETURN v_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
END PROCESS_AGE_SINGLE;
/

CREATE OR REPLACE FUNCTION PROCESS_AGE_RANGE(p_age_range IN VARCHAR2) RETURN NUMBER IS
    v_id NUMBER;
    v_inicio NUMBER;
    v_fim NUMBER;
BEGIN
    IF NOT IS_VALID_VALUE(p_age_range) OR NOT REGEXP_LIKE(p_age_range, '^[0-9]+-[0-9]+') THEN
        RETURN NULL;
    END IF;
    v_inicio := TO_NUMBER(REGEXP_SUBSTR(p_age_range, '^[0-9]+'));
    v_fim := TO_NUMBER(REGEXP_SUBSTR(p_age_range, '[0-9]+', 1, 2));
    BEGIN
        SELECT id INTO v_id FROM FaixaEtaria
        WHERE inicio = v_inicio AND fim = v_fim AND ROWNUM = 1;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO FaixaEtaria (id, inicio, fim)
        VALUES (FaixaEtaria_Seq.NEXTVAL, v_inicio, v_fim);
        SELECT id INTO v_id FROM FaixaEtaria WHERE inicio = v_inicio AND fim = v_fim AND ROWNUM = 1;
        RETURN v_id;
    END;
END PROCESS_AGE_RANGE;
/

CREATE OR REPLACE PROCEDURE INSERT_LINGUAGENS(
    p_resposta_id IN NUMBER,
    p_linguagens IN VARCHAR2
) IS
BEGIN
    IF p_linguagens IS NOT NULL AND LENGTH(TRIM(p_linguagens)) > 0 AND UPPER(TRIM(p_linguagens)) != 'NA' THEN
        FOR i IN 1 .. REGEXP_COUNT(p_linguagens, '[^;]+') LOOP
            DECLARE
                v_linguagem VARCHAR2(512);
            BEGIN
                v_linguagem := TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(p_linguagens, '[^;]+', 1, i), '^[''" ]+|[''" ]+$', ''));
                IF v_linguagem IS NOT NULL AND LENGTH(TRIM(v_linguagem)) > 0 AND UPPER(v_linguagem) != 'NA' THEN
                    BEGIN
                        INSERT INTO Linguagem (id, linguagem)
                        SELECT Linguagem_Seq.NEXTVAL, v_linguagem
                        FROM dual
                        WHERE NOT EXISTS (SELECT 1 FROM Linguagem WHERE linguagem = v_linguagem);
                    EXCEPTION WHEN OTHERS THEN NULL; END;
                    BEGIN
                        INSERT INTO Resposta_Linguagem (resposta_id, linguagem_id)
                        VALUES (p_resposta_id, (SELECT id FROM Linguagem WHERE linguagem = v_linguagem));
                    EXCEPTION WHEN OTHERS THEN NULL; END;
                END IF;
            END;
        END LOOP;
    END IF;
END INSERT_LINGUAGENS;
/

CREATE OR REPLACE PROCEDURE INSERT_CARGOS(
    p_resposta_id IN NUMBER,
    p_cargos IN VARCHAR2
) IS
BEGIN
    IF p_cargos IS NOT NULL AND LENGTH(TRIM(p_cargos)) > 0 AND UPPER(TRIM(p_cargos)) != 'NA' THEN
        FOR i IN 1 .. REGEXP_COUNT(p_cargos, '[^;]+') LOOP
            DECLARE
                v_cargo VARCHAR2(512);
            BEGIN
                v_cargo := TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(p_cargos, '[^;]+', 1, i), '^[''" ]+|[''" ]+$', ''));
                IF v_cargo IS NOT NULL AND LENGTH(TRIM(v_cargo)) > 0 AND UPPER(v_cargo) != 'NA' THEN
                    BEGIN
                        INSERT INTO Cargo (id, cargo)
                        SELECT Cargo_Seq.NEXTVAL, v_cargo
                        FROM dual
                        WHERE NOT EXISTS (SELECT 1 FROM Cargo WHERE cargo = v_cargo);
                    EXCEPTION WHEN OTHERS THEN NULL; END;
                    BEGIN
                        INSERT INTO Resposta_Cargo (resposta_id, cargo_id)
                        VALUES (p_resposta_id, (SELECT id FROM Cargo WHERE cargo = v_cargo));
                    EXCEPTION WHEN OTHERS THEN NULL; END;
                END IF;
            END;
        END LOOP;
    END IF;
END INSERT_CARGOS;
/

CREATE OR REPLACE FUNCTION INSERT_TRABALHO_REMOTO(p_valor IN VARCHAR2) RETURN NUMBER IS
    v_id NUMBER;
BEGIN
    IF NOT IS_VALID_VALUE(p_valor) THEN
        RETURN NULL;
    END IF;
    BEGIN
        SELECT id INTO v_id FROM TrabalhoRemoto WHERE trabalho_remoto = p_valor;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO TrabalhoRemoto (id, trabalho_remoto)
        VALUES (TrabalhoRemoto_Seq.NEXTVAL, p_valor);
        SELECT id INTO v_id FROM TrabalhoRemoto WHERE trabalho_remoto = p_valor;
        RETURN v_id;
    END;
END INSERT_TRABALHO_REMOTO;
/

CREATE OR REPLACE FUNCTION INSERT_FORMACAO(p_valor IN VARCHAR2) RETURN NUMBER IS
    v_id NUMBER;
BEGIN
    IF NOT IS_VALID_VALUE(p_valor) THEN
        RETURN NULL;
    END IF;
    BEGIN
        SELECT id INTO v_id FROM Formacao WHERE formacao = p_valor;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO Formacao (id, formacao)
        VALUES (Formacao_Seq.NEXTVAL, p_valor);
        SELECT id INTO v_id FROM Formacao WHERE formacao = p_valor;
        RETURN v_id;
    END;
END INSERT_FORMACAO;
/

CREATE OR REPLACE FUNCTION INSERT_PAIS(p_valor IN VARCHAR2) RETURN NUMBER IS
    v_id NUMBER;
BEGIN
    IF NOT IS_VALID_VALUE(p_valor) THEN
        RETURN NULL;
    END IF;
    BEGIN
        SELECT id INTO v_id FROM Pais WHERE pais = p_valor;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO Pais (id, pais)
        VALUES (Pais_Seq.NEXTVAL, p_valor);
        SELECT id INTO v_id FROM Pais WHERE pais = p_valor;
        RETURN v_id;
    END;
END INSERT_PAIS;
/

CREATE OR REPLACE FUNCTION INSERT_MOEDA(p_valor IN VARCHAR2) RETURN NUMBER IS
    v_id NUMBER;
BEGIN
    IF NOT IS_VALID_VALUE(p_valor) THEN
        RETURN NULL;
    END IF;
    BEGIN
        SELECT id INTO v_id FROM Moeda WHERE moeda = p_valor;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO Moeda (id, moeda)
        VALUES (Moeda_Seq.NEXTVAL, p_valor);
        SELECT id INTO v_id FROM Moeda WHERE moeda = p_valor;
        RETURN v_id;
    END;
END INSERT_MOEDA;
/

COMMIT; 