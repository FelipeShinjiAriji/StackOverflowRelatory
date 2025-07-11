ANTES:

Plan hash value: 3717053907
 
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                | Name                      | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                           |   450 | 61650 |       |  4030  (45)| 00:00:01 |
|   1 |  TEMP TABLE TRANSFORMATION               |                           |       |       |       |            |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D673F_30A625 |       |       |       |            |          |
|   3 |    WINDOW SORT                           |                           |  1530 |   106K|       |  4014  (45)| 00:00:01 |
|   4 |     WINDOW BUFFER                        |                           |  1530 |   106K|       |  4014  (45)| 00:00:01 |
|   5 |      SORT GROUP BY                       |                           |  1530 |   106K|       |  4014  (45)| 00:00:01 |
|*  6 |       HASH JOIN                          |                           |   827K|    56M|       |  2790  (21)| 00:00:01 |
|   7 |        TABLE ACCESS FULL                 | CARGO                     |    34 |   884 |       |     3   (0)| 00:00:01 |
|*  8 |        HASH JOIN                         |                           |   827K|    35M|       |  2718  (19)| 00:00:01 |
|   9 |         TABLE ACCESS FULL                | TRABALHOREMOTO            |    18 |   450 |       |     3   (0)| 00:00:01 |
|* 10 |         HASH JOIN                        |                           |   827K|    15M|  8208K|  2645  (17)| 00:00:01 |
|* 11 |          TABLE ACCESS FULL               | RESPOSTA                  |   350K|  4101K|       |   737  (17)| 00:00:01 |
|  12 |          TABLE ACCESS FULL               | RESPOSTA_CARGO            |   827K|  6466K|       |   535  (24)| 00:00:01 |
|  13 |   SORT ORDER BY                          |                           |   450 | 61650 |       |    16  (25)| 00:00:01 |
|* 14 |    HASH JOIN                             |                           |   450 | 61650 |       |    15  (20)| 00:00:01 |
|* 15 |     VIEW                                 |                           |   450 | 27900 |       |     8  (25)| 00:00:01 |
|* 16 |      WINDOW SORT PUSHED RANK             |                           |  1530 | 53550 |       |     8  (25)| 00:00:01 |
|  17 |       VIEW                               |                           |  1530 | 53550 |       |     6   (0)| 00:00:01 |
|  18 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D673F_30A625 |  1530 |   106K|       |     6   (0)| 00:00:01 |
|  19 |     VIEW                                 |                           |  1530 |   112K|       |     6   (0)| 00:00:01 |
|  20 |      TABLE ACCESS FULL                   | SYS_TEMP_0FD9D673F_30A625 |  1530 |   106K|       |     6   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
"   6 - access(""RC"".""CARGO_ID""=""C"".""ID"")"
"   8 - access(""R"".""TRABALHO_REMOTO_ID""=""TR"".""ID"")"
"  10 - access(""R"".""ID""=""RC"".""RESPOSTA_ID"")"
"  11 - filter(""R"".""TRABALHO_REMOTO_ID"" IS NOT NULL)"
"  14 - access(""T"".""ANO""=""R"".""ANO"" AND ""T"".""TRABALHO_REMOTO""=""R"".""TRABALHO_REMOTO"" AND ""T"".""CARGO""=""R"".""CARGO"")"
"  15 - filter(""R"".""RANKING""<=5)"
"  16 - filter(ROW_NUMBER() OVER ( PARTITION BY ""ANO"",""TRABALHO_REMOTO"" ORDER BY ""TOTAL_RESPONDENTES"" DESC )<=5)"


DEPOIS:

Plan hash value: 3717053907
 
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                | Name                      | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                           |   450 | 61650 |       |  4030  (45)| 00:00:01 |
|   1 |  TEMP TABLE TRANSFORMATION               |                           |       |       |       |            |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6740_30A625 |       |       |       |            |          |
|   3 |    WINDOW SORT                           |                           |  1530 |   106K|       |  4014  (45)| 00:00:01 |
|   4 |     WINDOW BUFFER                        |                           |  1530 |   106K|       |  4014  (45)| 00:00:01 |
|   5 |      SORT GROUP BY                       |                           |  1530 |   106K|       |  4014  (45)| 00:00:01 |
|*  6 |       HASH JOIN                          |                           |   827K|    56M|       |  2790  (21)| 00:00:01 |
|   7 |        TABLE ACCESS FULL                 | CARGO                     |    34 |   884 |       |     3   (0)| 00:00:01 |
|*  8 |        HASH JOIN                         |                           |   827K|    35M|       |  2718  (19)| 00:00:01 |
|   9 |         TABLE ACCESS FULL                | TRABALHOREMOTO            |    18 |   450 |       |     3   (0)| 00:00:01 |
|* 10 |         HASH JOIN                        |                           |   827K|    15M|  8208K|  2645  (17)| 00:00:01 |
|* 11 |          TABLE ACCESS FULL               | RESPOSTA                  |   350K|  4101K|       |   737  (17)| 00:00:01 |
|  12 |          TABLE ACCESS FULL               | RESPOSTA_CARGO            |   827K|  6466K|       |   535  (24)| 00:00:01 |
|  13 |   SORT ORDER BY                          |                           |   450 | 61650 |       |    16  (25)| 00:00:01 |
|* 14 |    HASH JOIN                             |                           |   450 | 61650 |       |    15  (20)| 00:00:01 |
|* 15 |     VIEW                                 |                           |   450 | 27900 |       |     8  (25)| 00:00:01 |
|* 16 |      WINDOW SORT PUSHED RANK             |                           |  1530 | 53550 |       |     8  (25)| 00:00:01 |
|  17 |       VIEW                               |                           |  1530 | 53550 |       |     6   (0)| 00:00:01 |
|  18 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6740_30A625 |  1530 |   106K|       |     6   (0)| 00:00:01 |
|  19 |     VIEW                                 |                           |  1530 |   112K|       |     6   (0)| 00:00:01 |
|  20 |      TABLE ACCESS FULL                   | SYS_TEMP_0FD9D6740_30A625 |  1530 |   106K|       |     6   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
"   6 - access(""RC"".""CARGO_ID""=""C"".""ID"")"
"   8 - access(""R"".""TRABALHO_REMOTO_ID""=""TR"".""ID"")"
"  10 - access(""R"".""ID""=""RC"".""RESPOSTA_ID"")"
"  11 - filter(""R"".""TRABALHO_REMOTO_ID"" IS NOT NULL)"
"  14 - access(""T"".""ANO""=""R"".""ANO"" AND ""T"".""TRABALHO_REMOTO""=""R"".""TRABALHO_REMOTO"" AND ""T"".""CARGO""=""R"".""CARGO"")"
"  15 - filter(""R"".""RANKING""<=5)"
"  16 - filter(ROW_NUMBER() OVER ( PARTITION BY ""ANO"",""TRABALHO_REMOTO"" ORDER BY ""TOTAL_RESPONDENTES"" DESC )<=5)"
