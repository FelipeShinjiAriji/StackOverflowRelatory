ANTES:

Plan hash value: 1442042534
 
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                | Name                      | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                           |   180 | 33660 |       |  3333  (32)| 00:00:01 |
|   1 |  TEMP TABLE TRANSFORMATION               |                           |       |       |       |            |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D673B_30A625 |       |       |       |            |          |
|   3 |    HASH GROUP BY                         |                           |   823 | 62548 |       |  3315  (32)| 00:00:01 |
|*  4 |     HASH JOIN                            |                           |   823 | 62548 |       |  3313  (32)| 00:00:01 |
|   5 |      TABLE ACCESS FULL                   | CARGO                     |    34 |   884 |       |     3   (0)| 00:00:01 |
|   6 |      MERGE JOIN                          |                           |   823 | 41150 |       |  3310  (32)| 00:00:01 |
|   7 |       TABLE ACCESS BY INDEX ROWID        | FORMACAO                  |    10 |   270 |       |     2   (0)| 00:00:01 |
|   8 |        INDEX FULL SCAN                   | SYS_C009758               |    10 |       |       |     1   (0)| 00:00:01 |
|*  9 |       SORT JOIN                          |                           |   850 | 19550 |       |  3308  (32)| 00:00:01 |
|  10 |        VIEW                              | VW_GBF_32                 |   850 | 19550 |       |  3306  (32)| 00:00:01 |
|  11 |         HASH GROUP BY                    |                           |   850 | 17000 |       |  3306  (32)| 00:00:01 |
|* 12 |          HASH JOIN                       |                           |   827K|    15M|  9360K|  2694  (17)| 00:00:01 |
|  13 |           TABLE ACCESS FULL              | RESPOSTA                  |   399K|  4678K|       |   724  (16)| 00:00:01 |
|  14 |           TABLE ACCESS FULL              | RESPOSTA_CARGO            |   827K|  6466K|       |   535  (24)| 00:00:01 |
|  15 |   SORT ORDER BY                          |                           |   180 | 33660 |       |    19  (37)| 00:00:01 |
|* 16 |    HASH JOIN                             |                           |   180 | 33660 |       |    18  (34)| 00:00:01 |
|  17 |     VIEW                                 |                           |     5 |    85 |       |     5  (20)| 00:00:01 |
|  18 |      HASH GROUP BY                       |                           |     5 |    85 |       |     5  (20)| 00:00:01 |
|  19 |       VIEW                               |                           |   823 | 13991 |       |     4   (0)| 00:00:01 |
|  20 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D673B_30A625 |   823 | 52672 |       |     4   (0)| 00:00:01 |
|* 21 |     HASH JOIN                            |                           |   180 | 30600 |       |    12  (34)| 00:00:01 |
|  22 |      VIEW                                |                           |    36 |  1800 |       |     5  (20)| 00:00:01 |
|  23 |       HASH GROUP BY                      |                           |    36 |  1476 |       |     5  (20)| 00:00:01 |
|  24 |        VIEW                              |                           |   823 | 33743 |       |     4   (0)| 00:00:01 |
|  25 |         TABLE ACCESS FULL                | SYS_TEMP_0FD9D673B_30A625 |   823 | 52672 |       |     4   (0)| 00:00:01 |
|* 26 |      VIEW                                |                           |   250 | 30000 |       |     5  (20)| 00:00:01 |
|* 27 |       WINDOW SORT PUSHED RANK            |                           |   823 | 28805 |       |     5  (20)| 00:00:01 |
|* 28 |        VIEW                              |                           |   823 | 28805 |       |     4   (0)| 00:00:01 |
|  29 |         TABLE ACCESS FULL                | SYS_TEMP_0FD9D673B_30A625 |   823 | 52672 |       |     4   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
"   4 - access(""ITEM_1""=""C"".""ID"")"
"   9 - access(""ITEM_2""=""F"".""ID"")"
"       filter(""ITEM_2""=""F"".""ID"")"
"  12 - access(""R"".""ID""=""RC"".""RESPOSTA_ID"")"
"  16 - access(""R"".""ANO""=""EA"".""ANO"")"
"  21 - access(""R"".""ANO""=""E"".""ANO"" AND ""R"".""FORMACAO""=""E"".""FORMACAO"")"
"  26 - filter(""R"".""RANKING""<=5)"
"  27 - filter(ROW_NUMBER() OVER ( PARTITION BY ""ANO"",""FORMACAO"" ORDER BY ""TOTAL_RESPONDENTES"" DESC )<=5)"
"  28 - filter(""TOTAL_RESPONDENTES"">=3)"


DEPOIS:

Plan hash value: 1442042534
 
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                | Name                      | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                           |   180 | 33660 |       |  3333  (32)| 00:00:01 |
|   1 |  TEMP TABLE TRANSFORMATION               |                           |       |       |       |            |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D673C_30A625 |       |       |       |            |          |
|   3 |    HASH GROUP BY                         |                           |   823 | 62548 |       |  3315  (32)| 00:00:01 |
|*  4 |     HASH JOIN                            |                           |   823 | 62548 |       |  3313  (32)| 00:00:01 |
|   5 |      TABLE ACCESS FULL                   | CARGO                     |    34 |   884 |       |     3   (0)| 00:00:01 |
|   6 |      MERGE JOIN                          |                           |   823 | 41150 |       |  3310  (32)| 00:00:01 |
|   7 |       TABLE ACCESS BY INDEX ROWID        | FORMACAO                  |    10 |   270 |       |     2   (0)| 00:00:01 |
|   8 |        INDEX FULL SCAN                   | SYS_C009758               |    10 |       |       |     1   (0)| 00:00:01 |
|*  9 |       SORT JOIN                          |                           |   850 | 19550 |       |  3308  (32)| 00:00:01 |
|  10 |        VIEW                              | VW_GBF_32                 |   850 | 19550 |       |  3306  (32)| 00:00:01 |
|  11 |         HASH GROUP BY                    |                           |   850 | 17000 |       |  3306  (32)| 00:00:01 |
|* 12 |          HASH JOIN                       |                           |   827K|    15M|  9360K|  2694  (17)| 00:00:01 |
|  13 |           TABLE ACCESS FULL              | RESPOSTA                  |   399K|  4678K|       |   724  (16)| 00:00:01 |
|  14 |           TABLE ACCESS FULL              | RESPOSTA_CARGO            |   827K|  6466K|       |   535  (24)| 00:00:01 |
|  15 |   SORT ORDER BY                          |                           |   180 | 33660 |       |    19  (37)| 00:00:01 |
|* 16 |    HASH JOIN                             |                           |   180 | 33660 |       |    18  (34)| 00:00:01 |
|  17 |     VIEW                                 |                           |     5 |    85 |       |     5  (20)| 00:00:01 |
|  18 |      HASH GROUP BY                       |                           |     5 |    85 |       |     5  (20)| 00:00:01 |
|  19 |       VIEW                               |                           |   823 | 13991 |       |     4   (0)| 00:00:01 |
|  20 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D673C_30A625 |   823 | 52672 |       |     4   (0)| 00:00:01 |
|* 21 |     HASH JOIN                            |                           |   180 | 30600 |       |    12  (34)| 00:00:01 |
|  22 |      VIEW                                |                           |    36 |  1800 |       |     5  (20)| 00:00:01 |
|  23 |       HASH GROUP BY                      |                           |    36 |  1476 |       |     5  (20)| 00:00:01 |
|  24 |        VIEW                              |                           |   823 | 33743 |       |     4   (0)| 00:00:01 |
|  25 |         TABLE ACCESS FULL                | SYS_TEMP_0FD9D673C_30A625 |   823 | 52672 |       |     4   (0)| 00:00:01 |
|* 26 |      VIEW                                |                           |   250 | 30000 |       |     5  (20)| 00:00:01 |
|* 27 |       WINDOW SORT PUSHED RANK            |                           |   823 | 28805 |       |     5  (20)| 00:00:01 |
|* 28 |        VIEW                              |                           |   823 | 28805 |       |     4   (0)| 00:00:01 |
|  29 |         TABLE ACCESS FULL                | SYS_TEMP_0FD9D673C_30A625 |   823 | 52672 |       |     4   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
"   4 - access(""ITEM_1""=""C"".""ID"")"
"   9 - access(""ITEM_2""=""F"".""ID"")"
"       filter(""ITEM_2""=""F"".""ID"")"
"  12 - access(""R"".""ID""=""RC"".""RESPOSTA_ID"")"
"  16 - access(""R"".""ANO""=""EA"".""ANO"")"
"  21 - access(""R"".""ANO""=""E"".""ANO"" AND ""R"".""FORMACAO""=""E"".""FORMACAO"")"
"  26 - filter(""R"".""RANKING""<=5)"
"  27 - filter(ROW_NUMBER() OVER ( PARTITION BY ""ANO"",""FORMACAO"" ORDER BY ""TOTAL_RESPONDENTES"" DESC )<=5)"
"  28 - filter(""TOTAL_RESPONDENTES"">=3)"
