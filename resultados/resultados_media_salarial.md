ANTES:

Plan hash value: 4182036136
 
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                | Name                      | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                           |    11 |  1177 |       |  5032  (27)| 00:00:01 |
|   1 |  TEMP TABLE TRANSFORMATION               |                           |       |       |       |            |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D673D_30A625 |       |       |       |            |          |
|*  3 |    FILTER                                |                           |       |       |       |            |          |
|   4 |     HASH GROUP BY                        |                           |    11 |   495 |       |  5027  (27)| 00:00:01 |
|*  5 |      FILTER                              |                           |       |       |       |            |          |
|*  6 |       HASH JOIN RIGHT OUTER              |                           |   644K|    27M|       |  4558  (20)| 00:00:01 |
|   7 |        TABLE ACCESS FULL                 | MOEDA                     |   196 |  2156 |       |     3   (0)| 00:00:01 |
|*  8 |        HASH JOIN                         |                           |   644K|    20M|       |  4501  (19)| 00:00:01 |
|   9 |         TABLE ACCESS FULL                | LINGUAGEM                 |    59 |   590 |       |     3   (0)| 00:00:01 |
|* 10 |         HASH JOIN                        |                           |   644K|    14M|  3448K|  4444  (18)| 00:00:01 |
|* 11 |          TABLE ACCESS FULL               | RESPOSTA                  |   125K|  1967K|       |   717  (15)| 00:00:01 |
|  12 |          TABLE ACCESS FULL               | RESPOSTA_LINGUAGEM        |  2005K|    15M|       |  1295  (24)| 00:00:01 |
|  13 |   SORT ORDER BY                          |                           |    11 |  1177 |       |     6  (34)| 00:00:01 |
|* 14 |    HASH JOIN OUTER                       |                           |    11 |  1177 |       |     5  (20)| 00:00:01 |
|  15 |     VIEW                                 |                           |    11 |   803 |       |     2   (0)| 00:00:01 |
|  16 |      TABLE ACCESS FULL                   | SYS_TEMP_0FD9D673D_30A625 |    11 |   495 |       |     2   (0)| 00:00:01 |
|  17 |     VIEW                                 |                           |    11 |   374 |       |     2   (0)| 00:00:01 |
|  18 |      TABLE ACCESS FULL                   | SYS_TEMP_0FD9D673D_30A625 |    11 |   495 |       |     2   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter(COUNT(*)>=100)
"   5 - filter(""MAP_CURRENCY_TO_USD""(""M"".""MOEDA"",TO_NUMBER(""R"".""SALARIO_ANUAL""))>=1000 AND "
"              ""MAP_CURRENCY_TO_USD""(""M"".""MOEDA"",TO_NUMBER(""R"".""SALARIO_ANUAL""))<=1000000)"
"   6 - access(""R"".""MOEDA_ID""=""M"".""ID""(+))"
"   8 - access(""RL"".""LINGUAGEM_ID""=""L"".""ID"")"
"  10 - access(""R"".""ID""=""RL"".""RESPOSTA_ID"")"
"  11 - filter(""R"".""SALARIO_ANUAL"" IS NOT NULL AND ""R"".""SALARIO_ANUAL""<>'NA')"
"  14 - access(""S1"".""LINGUAGEM""=""S2"".""LINGUAGEM""(+) AND ""S1"".""ANO""=""S2"".""ANO""(+)+1)"


DEPOIS:

Plan hash value: 4182036136
 
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                | Name                      | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                           |    11 |  1177 |       |  5032  (27)| 00:00:01 |
|   1 |  TEMP TABLE TRANSFORMATION               |                           |       |       |       |            |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D673E_30A625 |       |       |       |            |          |
|*  3 |    FILTER                                |                           |       |       |       |            |          |
|   4 |     HASH GROUP BY                        |                           |    11 |   495 |       |  5027  (27)| 00:00:01 |
|*  5 |      FILTER                              |                           |       |       |       |            |          |
|*  6 |       HASH JOIN RIGHT OUTER              |                           |   644K|    27M|       |  4558  (20)| 00:00:01 |
|   7 |        TABLE ACCESS FULL                 | MOEDA                     |   196 |  2156 |       |     3   (0)| 00:00:01 |
|*  8 |        HASH JOIN                         |                           |   644K|    20M|       |  4501  (19)| 00:00:01 |
|   9 |         TABLE ACCESS FULL                | LINGUAGEM                 |    59 |   590 |       |     3   (0)| 00:00:01 |
|* 10 |         HASH JOIN                        |                           |   644K|    14M|  3448K|  4444  (18)| 00:00:01 |
|* 11 |          TABLE ACCESS FULL               | RESPOSTA                  |   125K|  1967K|       |   717  (15)| 00:00:01 |
|  12 |          TABLE ACCESS FULL               | RESPOSTA_LINGUAGEM        |  2005K|    15M|       |  1295  (24)| 00:00:01 |
|  13 |   SORT ORDER BY                          |                           |    11 |  1177 |       |     6  (34)| 00:00:01 |
|* 14 |    HASH JOIN OUTER                       |                           |    11 |  1177 |       |     5  (20)| 00:00:01 |
|  15 |     VIEW                                 |                           |    11 |   803 |       |     2   (0)| 00:00:01 |
|  16 |      TABLE ACCESS FULL                   | SYS_TEMP_0FD9D673E_30A625 |    11 |   495 |       |     2   (0)| 00:00:01 |
|  17 |     VIEW                                 |                           |    11 |   374 |       |     2   (0)| 00:00:01 |
|  18 |      TABLE ACCESS FULL                   | SYS_TEMP_0FD9D673E_30A625 |    11 |   495 |       |     2   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter(COUNT(*)>=100)
"   5 - filter(""MAP_CURRENCY_TO_USD""(""M"".""MOEDA"",TO_NUMBER(""R"".""SALARIO_ANUAL""))>=1000 AND "
"              ""MAP_CURRENCY_TO_USD""(""M"".""MOEDA"",TO_NUMBER(""R"".""SALARIO_ANUAL""))<=1000000)"
"   6 - access(""R"".""MOEDA_ID""=""M"".""ID""(+))"
"   8 - access(""RL"".""LINGUAGEM_ID""=""L"".""ID"")"
"  10 - access(""R"".""ID""=""RL"".""RESPOSTA_ID"")"
"  11 - filter(""R"".""SALARIO_ANUAL"" IS NOT NULL AND ""R"".""SALARIO_ANUAL""<>'NA')"
"  14 - access(""S1"".""LINGUAGEM""=""S2"".""LINGUAGEM""(+) AND ""S1"".""ANO""=""S2"".""ANO""(+)+1)"
