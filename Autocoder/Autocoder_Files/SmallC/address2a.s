               JOB  1401 CONVERSION
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD     
               ORG  87
     X1        DCW  000               *INDEX REGISTER 1
               DC   00
     X2        DCW  000               *INDEX REGISTER 2
               DC   00
     X3        DCW  000               *INDEX REGISTER 3
     *                
     *              
               ORG  100
     CADD5     DCW  @ABCDE@   *WORKSPACE FOR FIVE DIGITS
               DCW  @-@
     CADD3     DCW  @FGH@     *WORKSPACE FOR THREE DIGITS
               DCW  @-@
     CATBL     DCW  @00S0K0B00SSSKSBS0KSKKKBK0BSBKBBB@

               DCW  @-@
     *
               ORG  400
     *
     CAZONE    DCW  @2@        *WORKSPACE FOR ZONE
     CAINDX    DCW  @00@       *INDEX TABLE
     CAX3      DCW  @000@      *HOLD FOR X3
               b    1202
               b    2202
               b    3202
               b    4202
               b    8202
               b    12202
               nop
     START     MCW  @00202@,CADD5
               B    CA5TO3
               B    CA3TO5
               MCW  @01202@,CADD5
               B    CA5TO3
               B    CA3TO5
               MCW  @02202@,CADD5
               B    CA5TO3
               B    CA3TO5
               MCW  @03202@,CADD5
               B    CA5TO3
               B    CA3TO5
               MCW  @04202@,CADD5
               B    CA5TO3
               B    CA3TO5
               MCW  @08202@,CADD5
               B    CA5TO3
               B    CA3TO5
               MCW  @12202@,CADD5
               B    CA5TO3
               B    CA3TO5
               H    *-3
     *   
     CA5TO3    SBR  CAEXIT+3
               MCW  CADD5,210
     *
               MCW  @000@,CADD3       *CLEAR
               MN   CADD5,CADD3      *MOVE NUMERIC
               MN   CADD5-1,CADD3-1  *MOVE NUMERIC
               MN   CADD5-2,CADD3-2  *MOVE NUMERIC
     *
               MCW  X3,CAX3          *SAVE OFF X3
               MCW  @000@,X3
               MCW  CADD5-3,X3
               MA   X3,X3        *DOUBLE IT
     
               MZ   CATBL-31+X3,CADD3-2
               MZ   CATBL-30+X3,CADD3
     *
               MZ   CATBL-31+X3,260
               MN   CATBL-31+X3,260
     *
               MZ   CATBL-30+X3,270
               MN   CATBL-30+X3,270
     *         
               MCW  @1@,261
               MCW  @2@,271
               MCW  CADD3,220
               MCW  CAX3,X3      *RESTORE X3
     CAEXIT    B    000
     *****************************************************
     *          
     *
     *
     *****************************************************
     CA3TO5    SBR  CAEXI2+3          *SET RETURN
               MCW  @00000@,CADD5     *CLEAR OUTPUT
               MZ   CADD3-2,CAZONE    *PICK UP HND ZONE
               BCE  CA1K,CAZONE,S     *1 TO 2 K
               BCE  CA2K,CAZONE,K     *2 TO 3 K
               BCE  CA3K,CAZONE,B     *3 TO 4 k
               B    CANTX
     CA1K      A    @01000@,CADD5     *ADD 1K
               B    CANTX
     CA2K      A    @02000@,CADD5     *ADD 2K
               B    CANTX
     CA3K      A    @03000@,CADD5     *ADD 3K
     *
     CANTX     MZ   CADD3,CAZONE      *PICK UP UNIT ZONE
               BCE  CA4K,CAZONE,S     *5 TO 8 K
               BCE  CA8K,CAZONE,K     *9 TO 12 K
               BCE  CA12K,CAZONE,B     *12 TO 16 k
               B    CANTX2
     CA4K      A    @04000@,CADD5   *ADD 4K
               B    CANTX2
     CA8K      A    @08000@,CADD5  *ADD 8K
               B    CANTX2
     CA12K     A    @12000@,CADD5  *ADD 16K
     CANTX2    MN   CADD3,CADD5
               MN   CADD3-1,CADD5-1
               MN   CADD3-2,CADD5-2
               MCW  CADD5,252      *PRINT ANSWER
               MCW  CADD3,242
               W
               CS   299
     CAEXI2    B    000
               NOP
     *                                                               
               END  START
