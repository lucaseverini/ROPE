               HEAD
     *
     TSIZE     EQU  004       *SIZE OF TAPE RECORD TO WRITE
     TBUFF     EQU  4000      * PUT THE TAPE BUFFER UP IN HIGH MEMORY
     *
     *
     IDENT     DCW  @TAPE DEMO PROGRAM VERSION 7.0 06/3/2014@ 
     GRPMRK    DCW  @"@       *DEFINE GROUP MARK
     *
     RECSIZ    DCW  800
     TNUMB     DCW  0000
     SSCNT     DCW  0
     DUMDRV    DCW  0
     LOOP      DCW  0000
     D1        DCW  0         *DID WE USE DRIVE ONE?
     D2        DCW  0         *DID WE USE DRIVE TWO?
     D3        DCW  0         *DID WE USE DRIVE THREE?
     DNOW      DCW  0         *WHICH DRIVE ARE WE USING NOW?
     TBLKN     DSA  800       *800  CHARACTER RECORDS FOR BLANKS
     TRECS     DCW  @06000@   *6000 8000 CHAR RECS SB 50% OF REEL
     MAXREC    DCW  @00000@   *HOW NMANY TO WRITE
     RECWR     DCW  @00000@   *NUMBER OF RECORDS WRITTEN
               DCW  @ TAPE DRIVE 1 @
     ERR1      DCW  @00000@   *NUMBER OF ERRORS ON DRIVE 1
               DCW  @ TAPE DRIVE 2 @
     ERR2      DCW  @00000@   *NUMBER OF ERRORS ON DRIVE 2
               DCW  @ TAPE DRIVE 3 @
     ERR3      DCW  @00000@   *NUMBER OF ERRORS ON DRIVE 3
     RNDTBL    EQU  *
               DC   @243134383215212616243126211428241812183411112832@
               DC   @323418281238261437151834152524371723222937261712@
               DC   @273428133118381727283229173323351318393617283312@
               DC   @332811252235372426131113113237323729183724182226@
               DC   @371334342338192238183827243728261938262727262931@
               DC   @272827312323182231332128141411311626343524222213@
               DC   @182736282833261629133134123815213213122614282614@
               DC   @151611221511383115361413333126271131292337161326@
               DC   @193733343126381239181712193116113129361617383421@
               DC   @183123253927113718362418141827221215193627371634@
               DC   @333119211526213736343228312225282833353138182615@
               DC   @261427283434153735391116233312131422162718213699@
     *
     **********************************************************************
     *
     START     NOP  111,111          *PUT A VALUE IN A AND B
               H                     *HALT AND WAIT FOR THE OPERATOR
     START2    NOP
               CS   332              *CLEAR 332 TO 300
               CS                    *CLEAR 299 TO 200
               CS                    *CLEAR 199 TO 100
               CS   080              *CLEAR 080 TO 000
               SW   201              *SET WORD MARK FOR PRINTING
     *
     *PRINT HEADING
     *         
               B    SKPRT,E          *SKIP IF LOOPING
               MCW  IDENT,247
               W
               CS   299
               MCW  @SENSE SWITCH B = TAPE DRIVE  1 ONLY      @,250
               W
               CS   299      
               MCW  @SENSE SWITCH C = TAPE DRIVES 1 & 2       @,250 
               W      
               CS   299           
               MCW  @SENSE SWITCH D = TAPE DRIVES 1 & 2 & 3   @,250 
               W  
               CS   299           
               MCW  @SENSE SWITCH E = LOOP TEST PROGRAM       @,250 
               W  
               CS   299
               MCW  @SENSE SWITCH F = TERMINATE PROGRAM       @,250 
               W  
               CS   299
               MCW  @SENSE SWITCH G = RERUN THE PROGRAM AFTER @,250
               MCW  @PROGRAM HALT    @,266
               W 
               CS   299 
               W
     SKPRT     MCW  @0@,SSCNT        *RESET SENSE SWITCH COUNT
               MCW  @N@,D1           *RESET THE DRIVE FLAGS
               MCW  @N@,D2           *RESET THE DRIVE FLAGS
               MCW  @N@,D3           *RESET THE DRIVE FLAGS
     *
               B    SWB,B            *BRANCE IF SS B IS ON
               B    TSSC             *BRANCH TO TEST SS C
     SWB       A    @1@,SSCNT        *ADD 1 TO SS COUNT
               MCW  @Y@,D1           *WE USED DRIVE 1
               MCW  @06000@,MAXREC   *WRITE 6000 RECORDS
     TSSC      B    SWC,C            *BRANCE IF SS C IS ON
               B    TSSD             *BRANCH TO TEST SS D
     SWC       A    @1@,SSCNT        *ADD 1 TO SS COUNT
               MCW  @Y@,D1           *WE USED DRIVE 1
               MCW  @Y@,D2           *WE USED DRIVE 2
               MCW  @12000@,MAXREC   *WRITE 12000 RECORDS
     TSSD      B    SWD,D            *BRANCE IF SS D IS ON
               B    TSSE             *BRANCH TO TEST SS E
     SWD       A    @1@,SSCNT        *ADD 1 TO SS COUNT
               MCW  @Y@,D1           *WE USED DRIVE 1
               MCW  @Y@,D2           *WE USED DRIVE 2
               MCW  @Y@,D3           *WE USED DRIVE 3
               MCW  @18000@,MAXREC   *WRITE 18000 RECORDS
     TSSE      NOP                   *WE DON'T TEST BEYONE HERE
               BCE  RUN,SSCNT,1      *IF WE HAVE NO DRIVES OR TOO MANY
     *****************************************************************
     *         HAD A PROBLEM SO PRINT INSTRUCTIONS
     *****************************************************************
     OOPS      MCW  @SENSE SWITCH ERROR. RESET AND TRY AGAIN@,250
               W
               CS   299                  *CLEAR PRINT STORAGE
               W                         *SPACE PAPER
               W                         *SPACE PAPER
               W                         *SPACE PAPER
               W                         *SPACE PAPER
               B    START                *HALT AND THEN START OVER
     *********************************************************
     *     USE UP 1/2 OF TAPE REEL SO THE USERS CAN SEE 
     *     A FAST REWIND FIRST
     *********************************************************
     RUN       NOP    B    PREL,G *GO TO PRE LOAD IF G
               B    DOTAP                *SKIP THE PRE LOAD
     PREL      MCW  @000@,X1             *CLEAR X1
               MA   TBLKN,X1             *PUT TAPE SIZE IN X1
               LCA  GRPMRK,TBUFF&X1      *PUT THE GROUP MARK 
     *                                   *AND WORD MARK OUT THERE
               MCW  @000@,X1             *RESET X1
     ******************************************************
               MCW  @0000@,LOOP         *RESET THE LOOP COUNTER
     ST1       BCE  WT3,D3,Y            *THREE TAPES
               BCE  WT2,D2,Y            *TWO TAPES? 
               BCE  WT1,D1,Y            *ONLY ONE TAPE?
               H    *-3
               NOP                      *SPACER
     WT3       WT   3,TBUFF             *WRITE A RECORD
     WT2       WT   2,TBUFF             *WRITE A RECORD 
     WT1       WT   1,TBUFF             *WRITE A RECORD
     * 
     STADD     B    DONE,F              *DONE WHAT YOU ARE DOING IS SET
               A    @1@,LOOP            *COUNT RECORDS
               MZ   LOOP-1,LOOP         *CLEAR ZONE
               C    TRECS,LOOP          *DID WE DO ENOUGHT?
               BL   ST1                 *GO DO ANOTHER 
               B    DOTAP,E             *SKIP THE HALT OF E ON
               NOP  111,111             *LOAD A & B
               H                        *WAIT FOR THE MAIN PROGRAM
     *****************************************************************
     DOTAP     MCW  @0000@,LOOP         *RESET LOOP COUNTER
               B    REWIND              *CALL THE REWIND SUBROUTINE
               MCW  @000@,X1            *CLEAR X1
               MA   RECSIZ,X1           *PUT TAPE SIZE IN X1
               LCA  GRPMRK,TBUFF&X1     *PUT THE GROUP MARK 
     *                                  *AND WORD MARK OUT THERE
               MCW  @000@,X1            *CLEAR X1
               MCW  @000@,X2            *CLEAR X2
               MCW  @00000@,RECWR       *CLEAR RECORD COUNT
     DOTAP2    B    DONE,F              *DONE DOING WHAT YOU 
     *                                  *ARE DOING IF SS F SET
               C    RECWR,MAXREC        *SEE IF WE HAVE WRITTEN THE MAX
               BL   DONE                *YES WE HAVE
               MN   RNDTBL&1&X1,DNOW    *PICK UP THE DRIVE INDICATOR
               BCE  CK1,DNOW,1          *CHECK IF DRIVE 1
               BCE  CK2,DNOW,2          *CHECK IF DRIVE 2
               BCE  CK3,DNOW,3          *CHECK IF DRIVE 3
               H    *-3                 *JUST IN CASE
     CK1       BCE  DRVOK,D1,Y          *IT IS READY
               B    WRITE3              *BYPASS
     CK2       BCE  DRVOK,D2,Y          *IT IS READY
               B    WRITE3              *BYPASS
     CK3       BCE  DRVOK,D3,Y          *IT IS READY
               B    WRITE3              *BYPASS
     DRVOK     MCW  DNOW,WRITE&3        *MODIFY THE WRITE INSTRUCTION
               MCW  @0000@,LOOP         *RESET LOOP COUNTER
               MN   RNDTBL&2&X2,LOOP    *SET UP THE LOOP 
     *
     *
     * WRITE TAPE
     *
     WRITE     WT   1,TBUFF             *WRITE THE TAPE RECORD
     *
     *              THE ABOVE INSTRUCTION IS MODIFIED IN REAL TIME
     *
               B    DONE,K              *DONE IF END OF REEL
               B    TERR,L              *BRANCH ON TAPE ERROR
               A    @1@,RECWR           *ADD 1 TO RECORDS WRITTEN
               S    @1@,LOOP            *SUBTRACT 1 FROM NUMBER
               MZ   LOOP-1,LOOP         *CLEAR ZONE
               C    @0000@,LOOP         *HAVE WE HIT ZERO?
               BU   WRITE               *NO, WRITE ANOTHER
     WRITE3    MA   @2@,X1              *INCREMENT X1 FOR NEXT COMMAND
               BCE  RESET,RNDTBL&1&X1,9   *END OF TABLE?
               B    DOTAP2              *LETS GET THE NEXT   
     RESET     MCW  @000@,X1            *RESET X1
               B    DOTAP2              *LETS GET THE NEXT
     *******************************************************************
     REWIND    SBR  REWX&3              *SET RETURN ADDRESS
               BCE  RT3,D3,Y            *THREE TAPES?
               BCE  RT2,D2,Y            *TWO TAPES?
               BCE  RT1,D1,Y            *ONLY ONE TAPE?
               H    *-3                 *JUST IN CASE OF ERROR
     RT3       RWD  3                   *REWIND TAPE 3
     RT2       RWD  2                   *REWIND TAPE 2
     RT1       RWD  1                   *REWIND TAPE 1
     REWX      B    000                 *RETURN ADDRESS
               NOP
     TERR      SBR  TERX&3              *SET RETURN ADDRESS
               BCE  TE1,DNOW,1          *ARE WE WORKING WITH DRIVE 1?
               BCE  TE2,DNOW,2          *ARE WE WORKING WITH DRIVE 2?
               BCE  TE3,DNOW,3          *ARE WE WORKING WITH DRIVE 3?
               B    TERX                *SHOULD NOT BE HERE BUT?
     TE1       A    @1@,ERR1            *INCREMENT ERR COUNT FOR DRIVE 1
               B    TERX                *EXIT
     TE2       A    @1@,ERR2            *INCREMENT ERR COUNT FOR DRIVE 2
               B    TERX                *EXIT
     TE3       A    @1@,ERR3            *INCREMENT ERR COUNT FOR DRIVE 3
               B    TERX                *EXIT
     TERX      B    000                 *RETURN ADDRESS
     *
     *          
     *
     *  WE ARE DONE
     *
     DONE      B    REWIND             *CALL THE REWIND SUBROUTINE
               MCW  @NUMBER OF RECORDS WRITTEN @,230
               MCW  RECWR,235          *SET THE NUMBER
               W                       *PRINT
               CS   299                *CLEAR PRINT
               MCW  @TAPE DRIVE ERROR COUNTS   @,230
               W                       *PRINT
               CS   299                *CLEAR PRINT
               MCW  ERR3,260           *MOVE IN DATA FOR 3 DRIVES
               MCW                     *CHAIN
               MCW                     *CHAIN
               MCW                     *CHAIN
               MCW                     *CHAIN
               MCW                     *CHAIN
               W
               B    START2,E            *IF WE ARE LOOPING
               CS   332
               CS
               B    DONE2,G            * NO FF IF MULTIPLE RUNS
               CC   1                  *TOP OF FORMS
     DONE2     NOP  999,999
               H             *HALT BEFORE GOING TO THE NEXT PROGRAM
     *******************************************************************
     *
               EXIT
     *
     ******************************************************************
     *
     *************************************************
               END  START
