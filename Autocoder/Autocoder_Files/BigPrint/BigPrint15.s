               JOB  BIGPRINT15.S 11/18/18 14:16:47                         -9407
     *  CTL 6611
     *  BIGPRINT
     *  PROGRAM BY ED THELEN
     *  MODIFIED BY STAN PADDOCK
     *
     CRDBUF    EQU  001
     PUNBUF    EQU  101
     PRTBUF    EQU  201
     *
               ORG  87
     X1        DSA  0                * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                * INDEX REGISTER 3
     *
     *
     * -------------------------------------------------------------
     *
               ORG  340     
     X         DCW  @X@
     XCNT      DCW  @00000@
     XCNT2     DCW  @00000@
     X4K       DSA  4000
     SPCNT     DCW  00
     REV       DCW  @BIGPRINT REV 15.0 GENERATED ON 06/01/2014@
     *
     START     CS   CRDBUF&79      * CLEAR WORD MARKS FROM CARD READ
               CS   PUNBUF&79      * CLEAR PUNCH AREA
               SW   CRDBUF         * SET WORD MARK
               ZA   NZERO,NZERO    * SET SIGN BITS
               MCW  @000@,X1       * CLEAR X1
               MCW  X1,X2          * CLEAR X2
               MCW  X1,X3          * CLEAR X3
               MCW  REV,140
     *
     * SPECIAL CODE TO SETUP THE ZONE SELECT CODES
     *
               MZ   @A@,ZONE
               MCW  ZONE,CKAB&7
               MZ   @J@,ZONE
               MCW  ZONE,CKB&7
               MZ   @Z@,ZONE
               MCW  ZONE,CKA&7
     *
     ******************************************************************
     *     READ IN AND STORE THE DATE CARD
     ******************************************************************
     *
               R                    * READ DATE CARD
               C    @(EOF)@,005     * IS THIS THE EOF CARD
               BE   NEND            * YES, STOP
               MCW  025,DATE25      * PUT IT IN A SAFE PLACE
     *
     *   SEE WHERE THE END OF THE TEXT IS AND ADD A #
     *
               MA   @000@,X1        * INITIALIZE X1
     DATECK    BCE  DATECA,DATE25-24&X1,
               B    DATECC         * NOT A SPACE
     DATECA    BCE  DATECX,DATE25-23&X1,
     DATECC    MA   @001@,X1        * GO TO TRY AGAIN
               B    DATECK
     DATECX    MCW  @#@,DATE25-24&X1
     *
     ******************************************************************
     *     READ IN AND PROCESS GUEST CARDS
     ******************************************************************
     *   PROGRAMS ARE PERFECT
     *   INPUT BY USERS CAN CONTAIN MANY ERRORS
     *   THE FOLLOWING CODE TRIES TO FIX MANY ERRORS SEEN 
     *   IN THE 1401 RESTORATION ROOM
     *   LEADING SPACES ARE ELIMINATED
     *   MULTIPLE SPACES BETWEEN THE FIRST AND LAST NAME ARE ELIMINATED
     *   IF ONLY ONE MANE IS GIVEN, THAT IS ALL THAT IS PRINTED
     *   IF THE USER GIVES A NAME LIKE EL AL JARAED
     *   IT WILL BE PRINTED WITH EL AS THE FIRST NAME AND
     *   AL JARAED AS THE SECOND NAME
     *   THE FIRST NAME WILL BE TRUNCSTED TO 11 CHARACTERS AND
     *   THE SECOND NAME TRUNCATED TO 10 CHARACTERS
     *
     READG     R                          * READ GUEST CARD
               C    @(EOF)@,005           * IS THIS THE EOF CARD
               BE   NEND                  * YES, STOP
     *         ELSE
               SS   1                     * SELECT READ STACKER 2
               MCW  @?@,075               * PUT SOMETHING IN THE CARD
               MCW  @000@,X1              * INITIALIZE X1
               MCW  @000@,X2              * INITIALIZE X2
               MCW  @01@,SPCNT            * TRICK TO SAY A SPACE 
     *                                    * HAS BEEN SEEN
     READH     BCE  FDSP,CRDBUF&X1,       * IS IT A SPACE?
               MCW  @00@,SPCNT            * THIS IS NOT A SPACE
               B    TAKIT                 * WE ARE GOING TO TAKE IT
     FDSP      A    @1@,SPCNT             * COUNT THE NUMBER OF SPACES
               C    SPCNT,@01@
               BL   NOTAKE                * IF WE ALREADY HAD A SPACE,
     *                                   * SKIP THIS ONE
     *
     TAKIT     MN   CRDBUF&X1,PUNBUF&X2   * MOVE THE NUMERIC PART
               MZ   CRDBUF&X1,PUNBUF&X2   * MOVE THE ZONE PART
               MA   @001@,X2              * INCREMENT DESTINATION
     NOTAKE    MA   @001@,X1              * INCREMENT SOURCE
               C    X1,@079@              * ARE WE AT THE END?
               BU   READH                 * GO GET SOME MORE
               MCW  PUNBUF&80,CRDBUF&80   * MOVE THE DATA BACK
               CS   PUNBUF&80             * CLEAR THE PUN BUFFER
     *
     * NOW WE ARE GOING LOOKING FOR THREE NAMES
     *
               MCW  @000@,X1              * INITIALIZE X1
               MCW  @00@,SPCNT            * INITIALIZE SPACE COUNT
     SPCK2     BCE  SP2,CRDBUF&X1,        * FIND A SPACE?
               B    SPNXT                 * GO TO THE NEXT
     SP2       BCE  SPX,CRDBUF&1&X1,      * IS THE NEXT A SPACE ALSO?
               A    @01@,SPCNT            * ADD ONE TO SPACE COUNT
               BCE  SPNXT,SPCNT,1         * IF THIS IS THE FIRST, 
     *                                    * LOOK FOR THE SECOND
               MCW  @?@,CRDBUF&X1         * PUT A NON PRINTABLE 
     *                                    * IN PLACE OF SPACE
               B    SPX                   * WE HAVE DONE OUR JOB
     *
     SPNXT     MA   @001@,X1              * INCREMENT X1
               C    @079@,X1              * ARE WE AT THE END?
               BE   SPX                   * LETS GET OUT OF HERE
               B    SPCK2                 * TRY NEXT COLUM
     SPX       NOP
     *
     SKIPPU    B    BIGPRT          * CALL SUBROUTINE TO PROCESS
     *                              * GUEST CARD
               MCW  @S@,DOUBLE      * SET FOR SINGLE SIZE BIG PRINT
               MCW  LINE3,WXX       * "VISITED THE COMPUTER#     "
               B    PRINTS          * SUBROUTINE CALL
               MCW  LINE4,WXX       * "HISTORY MUSEUM ON#        "
               B    PRINTS          * SUBROUTINE CALL
               MCW  DATE25,WXX      * PRINT DATE LINE
               B    PRINTS          * SUBROUTINE CALL
               CC   1               * TOP OF FORM
     *
     *******************************************************************
     *
     SKIPTX    B    READG           * GO AND GET THE NEXT GUEST CARD
     *
     *
     *******************************************************************
     *
     NEND      H                    * HALT OR I WILL SHOOT
               B    START,G         * IF G, GO AGAIN
               CC   1               * TOP OF FORM
               CS   332             * CLEAR PRINT STORAGE
               CS                   * CLEAR PRINT STORAGE
               CS                   * CLEAR PUNCH STORAGE
               CS                   * CLEAR READ STORAGE
     *
               C    @SHAY@,14007    * WERE WE LOADED WITH THE LOADER?
               BE   14000           * YES WE WERE. TURN CONTROL BACK 
     *                              * TO THE LOAD
     *         OTHERWISE.....
     *
     *         GET READY TO BOOT FROM THE FOLLOWING DECK
     *
               SW   001             * SET WORDMARK IN LOCATION 1
     NREAD     R                    * READ FIRST CARD OF NEXT 
     *                              * OBJECT DECK
               BCE  001,001,,       * IS IT A COMMA? BRANCH TO 
     *                              * THE FIRST INSTRUCTION
               B    NREAD           * CHECK THE NEXT ONE 
               NOP
     *
     ******************************************************************
     *     BIG PRINT SUBROUTINE
     ******************************************************************
     *
     BIGPRT    SBR  BIGPTX&3        * SET RETURN ADDRESS
               MCW  @D@,DOUBLE      * SET SIZE TO DOUBLE
               MCW  BLANKS,WXX      * BLANK WORK AREA, FOR 1ST NAME
               MCW  @000@,PICKUP    * INITIALIZE PICKUP
               MCW  PICKUP,X1       * START SCAN
               MCW  @000@,X2        * START PUTAWAY
     *
     BIGPTA    MCW  1&X1,PCHAR      * MOVE CHAR OF 1ST 
     *NAMETOPCHAR
               MA   @001@,X1         * INCREMENT X1 (GET)
               BCE  BIGPTB,PCHAR,    * IS THE CHARACTER A BLANK?
               MCW  PCHAR,WXX-24&X2  * MOVE PCHAR TO WORK SPACE
               A    @001@,X2         * INCREMENT X2 (PUT)
               C    @012@,X2         * TOO MANY?
               BE   BIGPTB           * YES, FIX IT
               B    BIGPTA           * GO GET ANOTHER
     BIGPTB    MCW  @#@,WXX-24&X2    * MOVE # TO END OF TEXT 
     *                               * IN WORK SPACE
               B    PRINTS          * SUBROUTINE CALL TO PRINT WHAT 
     *                              * IS IN WORK
     *
     *************************************************************
     * LOOKING FOR FIRST SPACE IN THE NAME CARD
     *************************************************************
     *
               MCW  @000@,X1        * INITIALIZE X1 AT START OF CARD
     FS1       BCE  FC1,1&X1,       * IT IS A SPACE
               MA   @001@,X1        * INCREMENT X1
               C    @070@,X1        * COMPARE SIZE OF X1
               BE   BIGSN           * GIVE UP
               B    FS1             * TRY NEXT
     *
     FC1       MA   @001@,X1        * INCREMENT X1
               C    @070@,X1        * COMPARE SIZE OF X1
               BE   BIGSN           * GIVE UP
               BCE  FC1,1&X1,       * IT IS A SPACE
               MCW  X1,PICKUP       * STORE X1 IN PICKUP
     *
     *
     ************ PROCESS SECOND NAME **************************
     *
     BIGSN     MCW  BLANKS,WXX      * BLANK WORK AREA, FOR 2ND NAME
               MCW  @ @,BIGLST      * SHOW NO CHARS IN LAST NAME
               MCW  PICKUP,X1       * START SCAN
               MCW  @001@,X2        * START PUTAWAY (OVER ONE COLUMN)
     BIGPTC    MCW  1&X1,PCHAR      * MOVE 1ST CHAR OF LAST NAME 
     *                              * TO PCHAR
               MA   @001@,X1        * INCREMENT X1 (GET)
               BCE  BIGPTD,PCHAR,   * IS IT A SPACE?
               MCW  PCHAR,WXX-24&X2  * MOVE PCHAR TO WORK SPACE
               A    @001@,X2        * INCREMENT X2 (PUT)
               C    @011@,X2        * TOO MANY?
               BE   BIGPTD          * YES, PRINT
               B    BIGPTC          * NO, GO GET ANOTHER
     *
     BIGPTD    MCW  @#@,WXX-24&X2   * MOVE # TO END OF TEXT IN 
     *                              * WORK SPACE
               MCW  X1,PICKUP       * STORE X1 IN PICKUP (WHY)
               B    PRINTS          * SUBROUTINE CALL TO PRINT 
     *                              * LAST NAME
     *
     BIGPTX    B    000             * SUBROUTINE RETURN
               NOP                  * BACKUP TO BRANCH INSTRUCTION
     *
     ************************************************************
     *   PRINTS SUBROUTINE
     ***********************************************************
     *
     PRINTS    SBR  PRINTX&3        * SET RETURN ADDRESS
               MCW  @000@,WROW      * INITIALIZE PRINT ROW COUNTER
     PRINT1    MCW  @000@,WCOL      * INITIALIZE WORK CHARACTER PICK UP
               MCW  @000@,PCOL      * INITIALIZE OUTPUT INDEX
               CS   332             * CLEAR PRINTER AREA
               CS
               SW   201
     *
     PRINT2    MCW  WCOL,X1             * PREPARE TO PICK UP NEXT CHAR 
     *                                  * TO PROCESS
               MCW  WXX-24&X1,PCHAR     * AND GET IT
               MCW  WXX-23&X1,PCHAR2    * STORE OFF THE NEXT CHARACTER
               A    @001@,WCOL          * INCREMENT COLUMN COUNT
               MCW  @000@,SUM           * INITIALIZE SUM
               C    @000@,WROW          * ARE WE ON THE FIRST ROW?
               BU   PC4                 * GO GET IT FROM TABLE
     *
     *****************************************************************
     * THE DATA FOR EACH CHARACTER IS STORED IN A TABLE TITLED CODEA
     * AN INDEX TO THIS TABLE IS TITLED CINDX
     * THE FOLLOWING CODE WILL FIND THE CHARCTER IN CINDX AND SET SUM
     * TO THAT POSITION
     * THE ROUTING CHECKS THE ZONE BITS FIRST AND SETS A 
     * BASE OF 0,16,32 OR 48
     * THEN IT USES THE NUMERICAL PORTION TO ADD IN TO THE INDEX
     * THIS DOES NOT WORK WITH SPECIAL CHARACTERS
     * SO THEY ALONG WITH THE ZERO HAVE TO BE PROCESSED SPECIAL
     * THIS ONLY WORKS IF THE NUMBERIAL PORTION IS 0-9
     * A TEST FOR SPECIAL CASES IS DONE ON THE NUMERICAL PORTION
     * FOR OTHER SPECIAL CHARACTERS
     ******************************************************************
     *
               MN   PCHAR,NUM       * MOVE THE NUMERIC PORTION
               MZ   PCHAR,ZONE      * MOVE THE ZONE
               C    @0@,NUM         * CHECK THE NUMERIC PORTION
               BH   CKA             * GOOD STUFF
     *
     * CHECK FOR SPECIAL CHARACTERS
     *
               BCE  AZERO,PCHAR,0   * IT IS A ZERO
               BCE  ACOLON,PCHAR,:  * IT IS A COLON
               BCE  ADASH,PCHAR,-   * IT IS A DASH
               BCE  ACOMMA,PCHAR,,  * IT IS A COMMA
               MCW  @000@,SUM       * MAKE IT A SPACE
               B    PC3
     *
     CKA       BCE  ZA,ZONE,A
     CKB       BCE  ZB,ZONE,B
     CKAB      BCE  ZAB,ZONE,C
               B    NUMA
     ZA        A    @32@,SUM
               B    NUMA
     ZB        A    @16@,SUM
               B    NUMA
     ZAB       A    @48@,SUM
     *                       ADD THE NUMERIC PORTION TO THE SUM
     NUMA      A    NUM,SUM
     *
     END       MZ   @0@,SUM
               B    PC3
     *
     ************************************************************
     AZERO     ZA   @10@,SUM
               B    PC3
     ACOLON    ZA   @13@,SUM
               B    PC3
     ADASH     ZA   @16@,SUM
               B    PC3
     ACOMMA    ZA   @43@,SUM
               B    PC3
     ************************************************************
     PC3       MCW  X1,X1HOLD       * STORE OFF THE CURRENT VALUE OF X1
               MCW  @000@,X1        * INITIALIZE X1
               MA   WCOL,X1         * PUT IN THE COLUMN INTO X1
               MA   WCOL,X1         * PUT IN THE COLUMN INTO X1
               MA   WCOL,X1         * PUT IN THE COLUMN INTO X1
               ZA   @0@,BL          * START MPY BY 14
               ZA   @14@,BH         * LOAD MULTIPLIER (14) TO HIGH B
     *          M    SUM,BL         * MULTIPLY BY SUM
               MCW  @000@,SUM2      *INITALIZE SUM2
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
               A    SUM,SUM2        *ADD IN PLACE OF MULTIPLY
     *
     *          ZA   BL,SUM         * BACK INTO POSITION
               MCW  SUM2,SUM
               MZ   @0@,SUM         * CLEAR THE ZONE BITS
               MCW  SUM,PATNUM&X1   * STORE THE NUMBER FOR THIS COLUMN
               MCW  X1HOLD,X1       * RESTORE X1
               B    PC5             * GET ON WITH IT
     ************************************************************
     PC4       MCW  X1,X1HOLD       * STORE OFF THE CURRENT VALUE OF X1
               MCW  @000@,X1        * INITIALIZE X1
               MA   WCOL,X1         * PUT IN THE COLUMN INTO X1
               MA   WCOL,X1         * PUT IN THE COLUMN INTO X1
               MA   WCOL,X1         * PUT IN THE COLUMN INTO X1
               MCW  PATNUM&X1,SUM   * RETRIVE THE NUMBER FOR 
     *                              * THIS COLUMN
               MCW  X1HOLD,X1       * RESTORE X1
               B    PC5             * GET ON WITH IT
     *
     * AT THIS POINT WE HAVE THE TABLE ENTRY FOR THE PATTERN TO PRINT
     *
     PC5       MZ   @0@,SUM         * CLEAR THE ZONE BITS
     *
               A    WROW,SUM        * MAKE INDEX+(2*WROW)
               A    WROW,SUM        * MAKE INDEX+(2*WROW)
               A    @002@,SUM       * ADD ELEMENT SIZE
     *                              * PREPARE TO OUTPUT
               MCW  PCOL,X3         * OUTPUT COLUMN
               MCW  SUM,X1          * PICKUP PROPER MASK
               MCW  CODEA&X1,MASK2  *
     *
               MCW  @000@,X2          * SET UP BIT SELECT INDEX
     LOOP1     C    BITSEL&X2,MASK2   * DO COMPARE
               BL   L2
               MCW  PCHAR,WCHAR       * YES, PRINT SPECIAL
               S    BITSEL&X2,MASK2   * FIX MASK
               MN   MASK2,NOZONE
               MCW  NOZONE,MASK2
               B    L3
     L2        MCW  @ @,WCHAR
     L3        A    @002@,X2        * GO TO NEXT BIT
               MCW  WCHAR,PRTBUF&X3  * PRINT PROPER CHARACTER
               A    @001@,X3
               BCE  L4,DOUBLE,S     * ARE WE GOING SINGLE?
               MCW  WCHAR,PRTBUF&X3  * PRINT PROPER CHARACTER
               A    @001@,X3
     L4        C    @009@,X2
               BL   LOOP1
               A    @001@,X3
               BCE  L5,DOUBLE,S     * ARE WE DOING SINGLE?
               A    @001@,X3
     L5        MCW  X3,PCOL         * SAVE COLUMN POINTER
               BCE  L55,PCHAR2,#    * IF #, LAST CHARACTER IN ROW
               C    @132@,X3        *
               BL   PRINT2
     L55       BCE  L555,DOUBLE,S   * ARE WE DOING SINGLE?
               W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER NO SPACE
               DC   @S@
     L555      W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER
               BCE  L6,DOUBLE,S     * ARE WE DOING SINGLE?
               W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER NO SPACE
               DC   @S@
               W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER
     L6        A    @001@,WROW      * INCREMENT ROW COUNTER
               C    @007@,WROW
               BL   PRINT1          * DO ANOTHER ROW
               CS   332             * CLEAR PRINTER AREA
               CS
               SW   201
               W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER -
     PRINTX    B    0               * RETURN TO CALL
               NOP                  * BACK UP BRANCH
     *
     *         THE FOLLOWING ROUTINE IS DESIGNED TO TERMINATE 
     *          THE PROCESSING
     *         OF THE PRINT LINE IF THE # WAS FOUND
     *
     PRTX      W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER -
               BCE  L7,DOUBLE,S     * ARE WE DOING SINGLE?
               W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER
     L7        CS   332             * CLEAR PRINTER AREA
               CS
               SW   201
               W                    * WRITE THE PRINT AREA TO 
     *                              * THE PRINTER -
               B    PRINTX
     *
     *******************************************************
     *
     *         LTORG
     ZONE      DCW  @1@
     NUM       DCW  0
     SUM       DCW  000
     SUM2      DCW  000              * SED TO ADD SUM INSTEAD OF
     *                               * MULTIPLYING SUM
     BITSUM    DCW  000
     CHRCNT    DCW  000             * CHARACTER COUNTER
     X1HOLD    DCW  000             * PLACE TO HOLD X1
     BIGLST    DCW  1
     LMINUS    DCW  @-   @          * END OF FILE CARD
     BH        DCW  @00@
     BL        DC   @0000@          * WHERE THE ANSWER APPEARS
     *
     NZERO     DCW  000             * A NUMERICAL ZERO
     NONE      DCW  001             * A NUMERICAL ONE
     TXLIM     DCW  000             * TEXT INDEX LIMIT
     TXLCNT    DCW  000             * TEMP LINE COUNT
     DOUBLE    DCW  @S@             * S PRINTS SINGLE SIZE
     *                              * WORK AREAS FOR PRINTS
     WCOL      DCW  000             * PICKUP INDEX FROM INPUT AREA
     WROW      DCW  000
     PCHAR     DCW  0
     PCHAR2    DCW  0
     WCHAR     DCW  0
     MASK2     DCW  @00@            * 2 CHARACTER MASK
     WORK3     DCW  000
     PCOL      DCW  000
               DCW  @@000@@
     ONE2      DCW  01
     NOZONE    DCW  0
     DOLSW     DCW  0
     BITSEL    DCW  16
               DCW  08
               DCW  04
               DCW  02
               DCW  01
               DCW  00
     *
     DATE25    DCW  @0000000000000000000000000@    * SAVE DATE  25 LONG
     *
     WXX       DCW  @0000000000000000000000000@   
     * WORK AREA FOR STRING  25 LONG
     *
     BLANKS    DCW  @                         @    * SET WORK TO BLANKS
     LINE3     DCW  @VISITED THE COMPUTER#    @
     LINE4     DCW  @HISTORY MUSEUM ON#       @
     *
     *  MASK IS 14 CHR
     *
     * THINK 5X7 MATRIX
     * FOR REFERENCE/CLARIFICATION HERE IS A "1"
     * DC @04120404040414@
     * 04 000100
     * 12 001100 (4 + 8)
     * 04 000100
     * 04 000100
     * 04 000100
     * 04 000100
     * 14 001110   (2 + 4 + 8)
     *
     * FOR REFERENCE/CLARIFICATION HERE IS A "2"
     * DC @14170102020431@
     * 14 01110
     * 17 10001
     * 01 00001
     * 02 00010
     * 02 00010
     * 04 00100
     * 31 11111
     CODEA     DS   0                                        
               DC   @00000000000000@   *  BLANK
               DC   @04120404040414@   *  1
               DC   @14170101020431@   *  2
               DC   @31020402010114@   *  3
               DC   @02061018310202@   *  4
               DC   @31163001011714@   *  5
               DC   @06081630171714@   *  6
               DC   @31010204080808@   *  7
               DC   @14171714171714@   *  8
               DC   @14171715010212@   *  9
               DC   @14171921251714@   *  0
               DC   @00000000000000@   *  #
               DC   @00000000000000@   *  (AT SIGN)
               DC   @30303000303030@   *  :
               DC   @00000000000000@   *  >
               DC   @00000000000000@   *  (TAPE MARK)
     * 0 TO 15 ABOVE
               DC   @00000031000000@   *  -
               DC   @07020202021812@   *  J
               DC   @17182224221817@   *  K
               DC   @16161616161631@   *  L
               DC   @17272121171717@   *  M
               DC   @17172521191717@   *  N
               DC   @14171717171714@   *  O
               DC   @30171730161616@   *  P
               DC   @14171717212213@   *  Q
               DC   @30171730201817@   *  R
               DC   @00000000000000@   *  !
               DC   @00000000000000@   *  $
               DC   @00000000000000@   *  *
               DC   @00000000000000@   *  )
               DC   @00000000000000@   *  ;
               DC   @00000000000000@   *  (DELTA)
     * 16 TO 31 ABOVE
               DC   @00000000000000@   *  (CENT)
               DC   @00010204081600@   *  /
               DC   @15161614010130@   *  S
               DC   @31040404040404@   *  T
               DC   @17171717171714@   *  U
               DC   @17171717171004@   *  V
               DC   @17171721212110@   *  W
               DC   @17171004101717@   *  X
               DC   @17171710040404@   *  Y
               DC   @31010204081631@   *  Z
               DC   @00000000000000@   *  (REC MRK)
               DC   @00000000120408@   *  ,
               DC   @00000000000000@   *  %
               DC   @00000000000000@   *  =
               DC   @00000000000000@   *  '
               DC   @00000000000000@   *  "
     * 32 TO 47 ABOVE
               DC   @00000000000000@   *  &
               DC   @14171717311717@   *  A
               DC   @30171730171730@   *  B
               DC   @14171616161714@   *  C
               DC   @24181717171824@   *  D
               DC   @31161630161631@   *  E
               DC   @31161630161616@   *  F
               DC   @14171623171715@   *  G
               DC   @17171731171717@   *  H
               DC   @14040404040414@   *  I
               DC   @00000000000000@   *  ?
               DC   @00000000000000@   *  .
               DC   @00000000000000@   *  (LOZGEN)
               DC   @00000000000000@   *  (
               DC   @00000000000000@   *  <
               DC   @00000000000000@   *  (GRP MARK)
     * 48 TO 63 ABOVE
               DCW  @123456789012345678901234567890@
               DCW  @123@
     PICKUP    DCW  000
               DCW  @START@
     PATERN    DA   25X3          
     * STOREAGE FOR CHARACTER INDEX NUMBERS
     PATNUM         1,3           * ELEMENT IN PATTERN ARRAY
               DCW  @END@
               END  START   * LAST CARD IN DECK, TRANSFER ADDRESS
