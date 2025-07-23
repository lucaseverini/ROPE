    ****************************************************************

     READ      EQU  001
     PUNCH     EQU  101
     PRINT     EQU  201
     
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

               ORG  500
 
     ****************************************************************
       
     V1        DCW  00000
     V2        DCW  00000
     V3        DCW  000
     V4        DCW  00000
     V5        DCW  00000
     RESULT    DCW  0
       
     START     NOP
     
     ****************************************************************  
     
               SBR  X2, 400
     
               MCW  -00011, V1
               MCW  -00011, V2
               
               PUSH V1
               PUSH V2
     
               B    MAIN
     
               POP  RESULT
     
               MCW  V1,210
               MCW  V2,220
               MCW  RESULT,230
               W
               CS   299
     
               H
     
     ****************************************************************
     ** CMP COMPARE FOR INTEGERS (5-digit), CHAR (1-digit) AND ADDRESS (3-digit) 
     ** If OP1 > OP2, RESULT = 1 (1-digit)
     ** If OP2 < OP1, RESULT = 2 (1-digit)
     ** if OP1 == OP2, RESULT = 3 (1-digit)
     ****************************************************************

     MAIN      SBR  CMP6+3             * Setup return address
     
               POP  OP2
               POP  OP1

               MCW  @3@, RES           * Preset RESULT for EQUAL
               C    OP1, OP2
               BE   CMP5
               B    CHKZI              * Check for negative zeros
               ZA   OP2, TMP           * Move OP2 to TMP
               S    OP1, TMP           * SUBTRACT OP1 FROM TMP
               MN   @1@, TMP           * SET TO 1 SO NEGATIVE IS A j
               BCE  CMP1, TMP, J       * If LSD of TMP is a J, OP1 > OP2
               B    CMP3               * Next check
     CMP1      MCW  @1@, RES           * set RESULT to 1 if op1 > op2
     CMP3      ZA   OP1, TMP           * Move OP2 to TMP
               S    OP2, TMP           * SUBTRACT OP2 FROM TMP
               MN   @1@, TMP           * SET TO 1 SO NEGATIVE IS A j
               BCE  CMP4, TMP, J       * If LSD of TMP is a J, OP1 > OP2 otherwise OP1 == OP2
               B    CMP5               * Go out
     CMP4      MCW  @2@, RES           * Set RESULT to 2 if op2 > op1
     
     CMP5      NOP
               PUSH RES
     
     CMP6      B    000                * Jump back

     CHKZI     SBR  CHKZI4+3           * Setup return address
               C    NEGZI, OP1         * Is OP1 a Negative Zero ?
               BU   CHKZI2             * If is not go next check
               MCW  @?@, OP1           * Set OP1 to Normal Zero
     CHKZI2    C    NEGZI, OP2         * Is OP2 a Negative Zero ?
               BU   CHKZI4             * If is not jump over
               MCW  @?@, OP2           * Set OP2 to Normal Zero
     CHKZI4    B    000                * Jump back

     NEGZI     DCW  -00000             * Negative Zero
     OP1       DCW  00000
     OP2       DCW  00000
     TMP       DCW  00000
     RES       DCW  0

               END  START
