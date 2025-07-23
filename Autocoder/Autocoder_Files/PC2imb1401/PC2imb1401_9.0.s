               JOB  1401 SERVER PROGRAM
               HEAD                    *STANDARD HEADER FILE
     TAPBUF    EQU  1000               *START OF TAPE BUFFER
     *              
               ORG  13000              *TOP OF THE WORLD                                                              
               B    START              *A WAY TO RESTART THE PRG FROM THE CONSOLE
     *                                 *FIXED LOCATION FOR CONSOLE RESTART
               DCW  @SHAY@             *CHECK TO SEE IF LOADER IS IN PLACE
     *                                 *FIXED LOCATION FOR PROGRAMS TO TEST
               B    NEXT               *A PLACE TO RE-ENTER THIS CODE
     *                                 *A PLACE FOR pc LOADED PROGRAMS TO RETURN
     MYDATA    DCW  @IBM PC - IBM 1401 PROGRAM REV 9.0 01/21/2016@
     
     INREC     DA   81X1                *1 RECORD 80 CHARACTERS LONG LFT ADD
     CMDREC    DSA  *-4                 *RIGHT ADDRESS OF INREC
     *
     EOF       DCW  @$EOF @            *TO KEEP $EOF$ FROM OBJECT DECK
     GETBK     DSA  LOAD2              *SET THE RETURN ADDRESS
     *
     GMWM      DCW  @"@                *GROUP MARK WORD MARK
     CRDCNT    DCW  0000               *CARDCOUNT
     LINCNT    DCW  @00@               *LINE COUNT
     FORTR     DCW  @0@                *FORTRAN CC INDICATOR
     FORCC     DCW  @0@                *PLACE TO HOLD FORTRAN CHARACTER
     *
     CHRM      DCW  @000@               *CHARACTER INDEX
     TEST      DCW  @ @                 *WORKING CHAR
     D         DCW  @ @                 *D MODIFIER

     OUTBUF    DA   1X160
               DCW  @"@                 *GMWM
     ZTEST     DCW  @3@                 *TEST CASE FOR ZONE TEST
     NTEST     DCW  @ 1234567890,*@

     OCTAL     DCW  0                  *MARKER FOR TOP OF TABLE
               DC   @001020304050607101112131415161720212223@
               DC   @2425262730313233343536374041424344454647@
               DC   @5051525354555657606162636465666770717273@
               DC   @7475767700000000@         *DECIMAL TO OCTAL TABLE
     TPERR1    DCW  @0@                * TAPE ERROR 1
     TPERR2    DCW  @0@                * TAPE ERROR 2
     TREC      DCW  @000000@           * TAPE RECORD COUNT

     START     H
               MCW  @000@,X1           *CLEAR X1
               CS   333                *CLEAR PRINT BUFFER
               CS                      *CLEAR PRINT BUFFER
               CS                      *CLEAR RHT PUNCH BUFFER
               CS                      *CLEAR THE READ BUFFER
     SWLOOP    SW   OCTAL+X1           *SWM EVERY 2
               MA   @002@,X1           *KICK UP 2
               C    @128@,X1           *ARE WE DONE
               BL   SWLOOP             *NOT DONE YET
               MCW  @000@,X1           *CLEAR X1

               
               LCA  GMWM,INREC+80      *SET GROUP MARK WORD MARK INREC
               MCW  @$@,EOF            *MAKES EOF = $EOF$ 
               MZ   @ @,NTEST          *CLEAR THE ZONE FOR 84
               MZ   @ @,NTEST-1        *CLEAR THE ZONE FOR 821
               SW   201                *SET WORD MARK IN PRINT BUFFER
               SW   INREC              *SET WORD MARK IN READ  BUFFER

     ***************************************************************
          
     NEXT      MCW  %Z1,INREC,R        *READ A RECORD FROM PC INTO READ BUFFER 
               B    DB1,D              *DO WE WANT DEBUG?
               B    DB2                *NO
     DB1       MCW  CMDREC,280         *MOVE RECORD TO PRINT BUFFER
               W                       *PRINT IT
               CS   299                *CLEAR PRINT BUFFER
               W                       *PRINT A BLANK LINE
     *
     *         PROCESS THE COMMAND
     *
     
     DB2       C    @$PUNCH$@,007      *IS IT A PUNCH COMMAND?
               BE   PUNCH              *IF SO, GO TO PUNCH
     *
               C    @$PRINT$@,007      *IS IT A PRINT COMMAND? 
               BE   PRINT              *IF SO, GO TO PRINT
     *
               C    @$FORTR$@,007      *IS IT A FORTRAN FORMATTED PRINT COMMAND? 
               BE   PRINTF             *IF SO, GO TO PRINTF
     *
               C    @$WIFI $@,007      *IS IT A FORTRAN FORMATTED PRINT COMMAND? 
               BE   PRINTF             *IF SO, GO TO PRINTF
     *                                 *THIS PROGRAM TREATS WIFI AS FORMATTED FORTRAN CARRIAGE CONTROL
     *
               C    @$READ$ @,007      *IS IT A READ COMMAND? 
               BE   READ               *IF SO, GO TO READ
     *
               C    @$LOAD$ @,007      *IS IT A LOAD COMMAND? 
               BE   LOAD               *IF SO, GO TO LOAD
     *
               C    @$WTAPE$@,007       *IS IT A WTAPE COMMAND? 
               BE   WTAPE               *IF SO, GO TO WTAPE
     *
               C    @$ENDTP$@,007       *IS IT A CLOSE TAPE COMMAND? 
               BE   ENDTAP              *IF SO, GO TO EDTAP
     *
               C    @$NULL $@,007       *IS IT A MULL COMMAND? 
               BE   NEXT                *IF SO, GO TO NEXT
     *
               MCW  @ERROR, CMD NOT VALID@,230  *GIVE THE ERROR MESSAGE
               MCW  CMDREC,280         *GIVE THE DATA
               W                       *PRINT
               CS   299                *CLEAR PRINT STORAGE
               CC   1
               B    START              *NOTHING WE LIKE HAS BEEN FOUND
     *
     ******************************************************
     *
     PRINT     MCW  @00@,LINCNT        *ZERO LINE COUNT
     *
     PRINT2    CS   333                *CLEAR PRINT BUFFER
               CS                      *CLEAR PRINT BUFFER
               LCA  GMWM,333           *SET GROUP MARK WORD MARK
               MCW  %Z1,201,R          *READ A RECORD FROM PC INTO PRINT  BUFFER
     *
               SW   201                *SET WM FOR COMPARE
               C    EOF,205            *ARE WE DONE?
               BE   PRTEXT             *YES WE ARE
     *
               W                       *PRINT IT 
               A    @01@,LINCNT        *ADD 1 TO LINE COUNT
               C    @55@,LINCNT        *HAVE WE PRINTED 55 LINES?
               BL   PRINT2             *NOT YET
     *      
               CC   1                  *DO A FORM FEED
               MCW  @00@,LINCNT        *RESET LINECOUNT
               B    PRINT2             *GO READ ANOTHER ONE
     *
     PRTEXT    CC   1                  *GO TO TOP OF FORMS
               B    NEXT               *GET NEXT COMMAND
     *
     ****************************************************************
     *
     PRINTF    MCW  @1@,FORTR          *SET FLAG FOR FORTRAN FORMATTING
     *
     AGAINF    CS   333                *CLEAR PRINT BUFFER
               CS                      *CLEAR PRINT BUFFER
               LCA  GMWM,333           *SET GROUP MARK WORD MARK
               MCW  %Z1,201,R          *READ A RECORD FROM PC INTO PRINT  BUFFER
     *
               SW   201                *SET WM FOR COMPARE
               C    EOF,205            *ARE WE DONE?
               BE   PRTEXT             *YES WE ARE
     *
               MCW  201,FORCC          *PICK UP FORTRAN CARRIAGE CONTROL CHARACTER
               MCW  @ @,201            *CLEAR 201
               BCE  TOF,FORCC,1        *IS IT TOP OF FORM?
               BCE  DBLSP,FORCC,0      *IS IT DOUBLE SPACE?
               BCE  OVRPR,FORCC,S      *IS IT OVER PRINT?
     *
               W                       *PRINT IT NORMAL AND GO GET ANOTHER
               B    AGAINF             
     *
     TOF       CC   1                  *HEAD OF FORM
               MCW  @00@,LINCNT        *RESET LINE COUNT
               W    AGAINF             *PRINT IT
     *
     DBLSP     W                       *PRINT IT 
               CS   333                *CLEAR PRINT STORAGE
               CS                      *CLEAR PRINT STORAGE
               W    AGAINF             *DOUBLE SPACE
     *
     OVRPR     W                       *WRITE WITH NO SPACING
               DC   @S@                *WRITE WITHOUT SPACING
               B    AGAINF
     *
     *******************************************************************
     *
     WTAPE     B    CLEAR              *CLEAR MEMORY
               MCW  @000000@,TREC      *RESET TAPE RECORD COUNT
               MCW  @0@,TPERR1         *RESET TAPE ERROR 1
               MCW  @0@,TPERR2         *RESET TAPE ERROR 2
               CS   599                *CLEAR TAPE BUFFER
               CS   499                *CLEAR TAPE BUFFER 
               LCA  GMWM,TAPBUF+299    *SET GROUP MARK WORD MARK
               MCW  %Z1,TAPBUF,R       *READ A RECORD FROM PC INTO TAPE BUFFER
     *                    
               SW   TAPBUF             *SET A WORDMARK FOR COMPARE
               C    EOF,TAPBUF+4       *ARE WE DONE?
               BE   WTPEX              *YES WE ARE
     *
     WRITE     WT   1,TAPBUF           *WRITE TAPE FROM PRINT BUFFER
               BEF  TERROR             *DID WE HAVE A TAPE ERROR?
               A    @1@,TREC           *INCREMENT RECORD COUNTER
               B    WTAPE              *GOOD, NO ERROR
     TERROR    BSP  1                  *BACKSPACE TAPE 1
               CS   332                *CLEAR PRINT STORAGE
               CS                      *CLEAR PRINT STORAGE
               MCW  TREC,207           *MOVE RECORD COUNT
               MCW  @WR ERR 1@,221
               W                       *PRINT
               CS   299                *CLEAR PRINT STORAGE
               BCE  TERR2,TPERR1,3     *IF WE HAVE HAD THREE ERRORS
               A    @1@,TPERR1         *ADD 1 TO TAPE ERROR COUNT
               B    WRITE              *GO TRY IT AGAIN
     *TERR1     BCE  TERR2,TPERR2,3     *HAVE WE HAD THREE BIG ERRORS?
               BCE  TERR2,TPERR2,3     *HAVE WE HAD THREE BIG ERRORS?
               A    @1@,TPERR2   
               SKP  1                  *SKIP AND BLANK TAPE
               MCW  TREC,207           *MOVE RECORD COUNT
               MCW  @WR ERR 2@,221
               W                       *PRINT
               CS   299                *CLEAR PRINT STORAGE
               B    WRITE              *GO TRY AGAIN
     TERR2     MCW  @0@,TPERR1         *RESET TAPE ERROR 1
               MCW  @0@,TPERR2         *RESET TAPE ERROR 2
               H                       *LET OPERATOR KNOW YOU HAVE SERIOUS PROBLEM
               B    WRITE              *TRY AGAIN
     WTPEX     B    NEXT               *DO SOMETHING ELSE

     *
     *******************************************************************
     *
     ENDTAP    WTM  1                  *WRITE A TAPE MARK
               RWD  1                  *REWIND THE TAPE
               B    NEXT               *GET NEXT COMMAND
     *
     *******************************************************************
     *
     CLEAR     SBR  CLREX+3            *STORE OFF THE RETURN ADDRESS
               SW   001                *MY MARKER
     LOOP      CS   13700              *STARTING POINT
               SBR  LOOP&3             *PICK UP ADDRESS
               BW   LOOP,001           *IF MY MARKER IS STILL THERE
     *                                 *DO IT AGAIN
     *       DONE WITH CLEARING MEMORY
     *        
     CLREX     B    000                *RETURN FROM CALL
     *
     ****************************************************************
     *
       
     LOAD      B    CLEAR              *CALL THE CLEAR MEMORY ROUTINE
               MCW  @0000@,CRDCNT      *ZERO CARD COUNTER   
     LOAD2     LCA  GMWM,081           *SET GROUP MARK WORD MARK
               MCW  %Z1,INREC,R        *READ A RECORD FROM PC INTO CARD  BUFFER                 
               A    @1@,CRDCNT         *ADD ONE TO CARD COUNT
               SW   INREC              *SET A WORDMARK FOR COMPARE
               C    CRDCNT,@0001@      *IS THIS LINE 1?
               BE   LINE1              *IF SO, GO TO LINE 1
               C    CRDCNT,@0002@      *IS THIS LINE 2?
               BE   LINE2              *IF SO, GO TO LINE 1
               B    LOAD3              *DO THE REAL THING
     LINE1     BCE  LOAD2,INREC,,      *IF THE FIRST CHAR IS A ,
               B    LODERR             *BAD RECORD
     LINE2     BCE  LOAD2,INREC,L      *IF THE FIRST CHAR IS A L
               B    LODERR             *BAD RECORD
     LOAD3     MCW  GETBK,INREC+70     *SET THE ADDRESS
               MCW  @B@,INREC+67       *SET THE OPCODE
               C    CRDCNT,@0003@      *IS THIS LINE 3?
               BE   INREC              *JUMP OFF THE PIER IF CARD 3
               B    INREC+39           *JUMP OFF THE BIGGER PIER IF CARD 3+
     *
     LODERR    MCW  @ERROR RECORD NUMBER @,221
               MCW  CRDCNT,226
               MCW  080,310
               W
               CS   332
               CS
               B    NEXT

     *
     *******************************************************************
     *
     PUNCH     CS   181                *CLEAR PUNCH BUFFER
               LCA  GMWM,181           *SET GROUP MARK WORD MARK
               MCW  %Z1,101,R          *READ A RECORD FROM PC INTO PUNCH  BUFFER
     *                    
               SW   101                *SET A WORDMARK FOR COMPARE
               C    EOF,105            *ARE WE DONE?
               BE   PUNEXT             *YES WE ARE
     *
               P                       *PUNCH IT
               CS   180                *CLEAR PUNCH STORAGE
               B    PUNCH              *GO READ ANOTHER ONE
     *
     PUNEXT    CS   181                *CLEAR PUNCH STORAGE
               P                       *PUNCH A BLANK CARD
               P                       *PUNCH ANOTHER BLANK CARD
               B    NEXT               *DO SOMETHING ELSE
     *

     **********************************************************************
     READ      MCW  @000@,X1            *INITIALIZE ALL INDEX REGISTERS
               MCW  X1,X2
               MCW  X2,X3
               CS   081                *CLEAR READ BUFFER
               R                       *READ A CARD
               C    @(EOF)@,005
               BE   CRDEOF
               B    CRDEOF,A           *ARE WE EMPTY OF CARDS?
     *
               CS   332                *CLEAR PRINT BUFFER
               CS                      *CLEAR PRINT BUFFER
               SW   001                *SET WORD MARK AT FRONT
               MCW  080,280            *MOVE DATA TO PRINT BUFFER
               MCW  @READ DATA@,299    *MOVE ID TO PRINT BUFFER
               W                       *PRINT
               CS   332                *CLEAR PRINT STORAGE
               CS   299                *CLEAR PRINT STORAGE
     *
     
     *         NOW WE WILL WORK OUR WAY DOWN THE CARD AND 
     *         SEND ONE COLUMN AT A TIME
     *
       
               MCW  @000@,X1            *CLEAR X1
     RLOOP     MCW  @000@,CHRM          *SET CHAR TO ZERO
     *
               MN   001&X1,201          *DEBUG
               MZ   001&X1,201

               MN   @3@,TEST            *SETUP TEST
               MZ   001&X1,TEST         *SETUP TEST
               BCE  BITAON,TEST,T       *TESTING FOR A BIT   T = A21
               BCE  BITBON,TEST,L       *TESTING FOR B BIT   L = B21
               BCE  BITAB,TEST,C        *TESTING FOR A&B BIT C = BA21
               MCW  CHRM,205            TEST
     *
     *             TOOK CARE OF ZONE BITS
     *             NOW TO TAKE CARE OF 8421          
     *
              

               MCW  @ @,TEST            *CLEAR TEST
               MN   001&X1,NUMLP+7      *PUT IT IN THE BCE INSTRUCTION
               MCW  @0000@,X2           *CLEAR X2
     
     NUMLP0    MN   NTEST-12+X2,D       *CHANGING TEST
     NUMLP     BCE  HITIT,D,0           *ZERO REPLACED BY D
               MA   @001@,X2            *INCREMENT X2
               C    @013@,X2            *END OF LINE
               BU   NUMLP0              *NOT FOUND YET
               MCW  @000@,CHRM          *MAKE IT A BLANK
               B    NUMLP2              *GO AROUND HITIT
     HITIT     A    X2,CHRM             *ADD IN THE NUM INDEX
               MCW  X2,210              *TEST
               
     NUMLP2    MCW  CHRM,X3             *MOVE CRM TO X3
               A    CHRM,X3             *DOUBLE IT
               MCW  X1,X2               *REUSE X2
               A    X1,X2               *DOUBLE IT
               
               MCW  OCTAL+1+X3,OUTBUF+1+X2   *SET ONE CHAR DOUBLET
               SW   214                 *TEST
               MCW  OCTAL+1+X3,215
               W    
               CS   332
               CS
               C    @079@,X1            *ARE WE AT THE END OF THE CAARD?
               BE   WRTCRD              *WRITE THE CARD
     *
               MA   @001@,X1            *TO NEXT COLUMN
               B    RLOOP

     WRTCRD    SW   OUTBUF              *TEST
               MCW  OUTBUF+129,330      *TEST
               W
               CS   332
               CS
               MCW  %Z1,OUTBUF,W        *SEND THE DATA
               B    READ                *LETS GO DO THE NEXT CARD

     CRDEOF    MCW  @77@,OUTBUF+1       *SET OUTBUF TO 7'S
               
               MCW  %Z1,OUTBUF,W        *SEND THE DATA
               B    NEXT                *LETS GO DO SOMETHING ELSE


     *
     ***********************************************************
     *
     BITAON    SBR  RETURN&3            *STORE RETURN ADDRESS
               MCW  @39@,CHRM           *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     BITBON    SBR  RETURN&3            *STORE RETURN ADDRESS
               MCW  @26@,CHRM           *B BIT ONLY
               B    RETURN              *GET OUT OF HERE
     *
     BITAB     SBR  RETURN&3            *STORE RETURN ADDRESS
               MCW  @13@,CHRM           *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     *
     ***********************************************************
     *
     RETURN    B    000                 *GENERAL RETURN LOCATION
     *                                  *GO CHECK THE NEXT ONE
     *
               END  START
