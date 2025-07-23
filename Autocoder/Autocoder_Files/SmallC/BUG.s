     ****************************************************************

     READ      EQU  001                * Read area
     PUNCH     EQU  101                * Punch area
     PRINT     EQU  201                * Print area
     
     PRCPOS    DCW  000                * char position in print area
     PUCPOS    DCW  000                * char position in punch area
     PUNSIZ    DCW  @080@              * Size of punch area
     PRTSIZ    DCW  @132@              * Size of print area
     EOS       DCW  @'@                * End Of String char (string terminator)
     EOL       DCW  @;@                * End Of Line char

               ORG  87
     X1        DSA  0                  * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                  * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                  * INDEX REGISTER 3

               ORG  2000
  
     START     NOP
     
     ****************************************************************  
     
               SBR  X2, 400            * SET THE STACK
               MCW  X2, X3
               SW   1496
               SW   1491
               SW   1486
               SW   1481
               SW   1476
               SW   1471
               SW   1466
               SW   1461
               SW   1456
               SW   1451
               SW   1446
               SW   1441
               SW   1436
               SW   1431
               SW   1426
               SW   1421
               SW   1416
               SW   1411
               SW   1406
               SW   1401
               SW   1396
               SW   1391
               SW   1386
               SW   1381
               SW   1376
               SW   1371
               SW   1366
               SW   1361
               SW   1356
               SW   1351
               SW   1346
               SW   1341
               SW   1336
               SW   1331
               SW   1326
               SW   1321
               SW   1316
               SW   1311
               SW   1306
               SW   1301
               SW   1296
               SW   1291
               SW   1286
               SW   1281
               SW   1276
               SW   1271
               SW   1266
               SW   1261
               SW   1256
               SW   1251
               SW   1246
               SW   1241
               SW   1236
               SW   1231
               SW   1226
               SW   1221
               SW   1216
               SW   1211
               SW   1206
               SW   1201
               SW   1196
               SW   1191
               SW   1186
               SW   1181
               SW   1176
               SW   1171
               SW   1166
               SW   1161
               SW   1156
               SW   1151
               SW   1146
               SW   1141
               SW   1136
               SW   1131
               SW   1126
               SW   1121
               SW   1116
               SW   1111
               SW   1106
               SW   1101
               SW   1096
               SW   1091
               SW   1086
               SW   1081
               SW   1076
               SW   1071
               SW   1066
               SW   1061
               SW   1056
               SW   1051
               SW   1046
               SW   1041
               SW   1036
               SW   1031
               SW   1026
               SW   1021
               SW   1016
               SW   1011
               SW   1006
               SW   1001
               B    LAAAAA
               H    
     LAAAAA    SBR  3+X3
               SW   1+X3
               SW   4+X3
               MCW  @00099@,8+X3
               MA   @008@,X2
     LBAAAA    NOP  
     * Push(8+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  8+X3,0+X2
     * Push(@'05@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @'05@,0+X2
     * Push(@00099@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00099@,0+X2
     * Push(8+X3:5)
               SW   1+X2
               MA   @005@,X2
               MCW  8+X3,0+X2
               S    0+X2,15995+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * raw index on the stack
     * Push(@00005@:5)
               SW   1+X2
               MA   @005@,X2
               MCW  @00005@,0+X2
               M    15995+X2,6+X2
               SW   2+X2
               MCW  6+X2,15995+X2
               CW   2+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
     * STACK TOP IS NOW ARRAY INDEX
               B    LDAAAA
               MA   0+X2,15997+X2
     * Pop(3)
               MA   @I9G@,X2
               CW   1+X2
     * STACK top is location in array now.
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Pop(0+X1:5)
     
     
     
     
               MCW  0+X2,0+X1
               
               
               
               MA   @I9E@,X2
               CW   1+X2
     * Push(@008@:3)
               SW   1+X2
               MA   @003@,X2
               MCW  @008@,0+X2
               MA   X3,0+X2
     * Pop(X1:3)
               MCW  0+X2,X1
               MA   @I9G@,X2
               CW   1+X2
     * Push(0+X1:5)
               SW   1+X2
               MA   @005@,X2
               MCW  0+X1,0+X2
               S    @00001@,0+X1
               MCS  0+X2,0+X2
     * Pop(5)
               MA   @I9E@,X2
               CW   1+X2
               BCE  LCAAAA,5+X2, 
               B    LBAAAA
     LCAAAA    NOP  
               MA   @I9B@,X2
               CW   1+X3
               CW   4+X3
               MCW  3+X3,X1
               B    0+X1
     LDAAAA    SBR  X1
     * Casts a 5-digit number to a 3-digit address
     * make a copy of the top of the stack
               SW   1+X2
               MCW  0+X2,3+X2
     * set the low-order digit's zone bits
               C    @04000@,0+X2
               BL   LGAAAA
               C    @08000@,0+X2
               BL   LFAAAA
               C    @12000@,0+X2
               BL   LEAAAA
               S    @12000@,0+X2
               MZ   @A@,3+X2
               B    LGAAAA
     LEAAAA    S    @08000@,0+X2
               MZ   @I@,3+X2
               B    LGAAAA
     LFAAAA    S    @04000@,0+X2
               MZ   @S@,3+X2
     * For some reason the zone bits get set - it still works though.
     LGAAAA    C    @01000@,0+X2
               BL   LJAAAA
               C    @02000@,0+X2
               BL   LIAAAA
               C    @03000@,0+X2
               BL   LHAAAA
               MZ   @A@,1+X2
               B    LJAAAA
     LHAAAA    MZ   @I@,1+X2
               B    LJAAAA
     LIAAAA    MZ   @S@,1+X2
     LJAAAA    MCW  3+X2,15998+X2
               CW   1+X2
               SBR  X2,15998+X2
               B    0+X1
               END  START
