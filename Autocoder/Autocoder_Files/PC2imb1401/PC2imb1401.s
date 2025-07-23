               JOB  1401 SERVER PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD     
               ORG  87
     X1        DCW  000               *INDEX REGISTER 1
               DC   00
     X2        DCW  000               *INDEX REGISTER 2
               DC   00
     X3        DCW  000               *INDEX REGISTER 3
     *              
               ORG  14000
     *                                                               
     RESTRT    B    START              *A WAY TO RESTART THE PRG FROM THE CONSOLE
     SHAY      DCW  @SHAY@             *CHECK TO SEE IF LOADER IS IN PLACE
               DCW  #40                *CLUMSY WAY TO SAVE OFF 80 CHARACTERS
     CMDREC    DC   #40                *PLACE TO STORE THE LAST COMMAND RECORD
     GETBK     DSA  LOAD2	       *SET THE RETURN ADDRESS
     MYDATA    DCW  @IBM PC - IBM 1401 PROGRAM 08/05/2014  @
     *
     GMWM      DCW  @"@                *GROUP MARK WORD MARK
     CRDCNT    DCW  0000               *CARDCOUNT
     LINCNT    DCW  @00@               *LINE COUNT
     COLCNT    DCW  @000@              *COLUMN COUNT
     COUNT     DCW  @000@              *COUNT COLUMNS
     FORTR     DCW  @0@                *FORTRAN CC INDICATOR
     FORCC     DCW  @0@                *PLACE TO HOLD FORTRAN CHARACTER
     *
     OUTBUF    DCW  @000G@             *OUT BUFFER WITH GROUP MARK
     CHRL      DCW  @0@                *FIRST        OF OUTPUT TRIPLET
     CHRM      DCW  @0@                *MIDDLE DIGIT OF OUTPUT TRIPLET
     CHRH      DCW  @0@                *LAST         OF OUTPUT TRIPLE
     TEST      DCW  @3@                FOR ZONE TESTING
     *
     START     B    ID,D               *IF SS Debug IS ON, ID THE PROGRAM
               B    START2             *IF NOT, GO TO WORK
     ID        CS   333                *CLEAR PRINTR BUFFER
               CS                      *REST OF IT
               MCW  MYDATA,260         *IDENTIFY THE REVISION 
               W                       *PRINT
               CS   290                *CLEAR PRINT STORAGE
     START2    H
               CS   081                *CLEAR CARD BUFFER
               LCA  GMWM,081           *SET GROUP MARK WORD MARK IN READ BUFFER
     *                                 *80 CHARACTERS PLUS WMGM
               B    D001,D             *IF SS Debug IS ON, ID THE LOCATION
               B    D002               *IF NOT, GO TO WORK
     D001      MCW  @D001@,260         *IDENTIFY THE LOCATION 
               W                       *PRINT
               CS   290                *CLEAR PRINT STORAGE
     D002      MCW  %Z1,001,R          *READ A RECORD FROM PC INTO READ BUFFER
     * 
               SW   201                *SET WORD MARK IN PRINT BUFFER
               SW   001                *SET WORD MARK IN READ  BUFFER
               MCW  080,CMDREC         *STORE COMMAND
               B    START3,D           *IF SS D IS ON, PRINT INFO
               B    START4             *SKIP PRINTING OF INFO
     START3    CS   333                *CLEAR PRINTR BUFFER
               CS                      *REST OF IT
               MCW  @COMMAND FROM PC@,215  *MOVE ID TO PRINT BUFFER
               MCW  080,299            *MOVE DATA TO PRINT BUFFER
               W                       *PRINT
     START4    CS   333                *CLEAR PRINT STORAGE
               CS                      *CLEAR PRINT STORAGE
     *
     *         PROCESS THE COMMAND
     *
               C    @$PUNCH$@,007      *IS IT A PUNCH COMMAND?
               BE   PUNCH              *IF SO, GO TO PUNCH
     *
               C    @$PRINT$@,007      *IS IT A PRINT COMMAND? 
               BE   PRINT              *IF SO, GO TO PRINT
     *
               C    @$FORTR$@,007      *IS IT A FORTRAN FORMATTED PRINT COMMAND? 
               BE   PRINT0             *IF SO, GO TO PRINT0
     *
               C    @$READ$ @,007      *IS IT A READ COMMAND? 
               BE   READ               *IF SO, GO TO READ
     *
               C    @$LOAD$ @,007      *IS IT A LOAD COMMAND? 
               BE   LOAD               *IF SO, GO TO READ
     *
               MCW  @ERROR, COMMAND NOT RECONIZED@,230  *GIVE THE ERROR MESSAGE
               MCW  010,245            *GIVE THE DATA
               W                       *PRINT
               CS   332                *CLEAR PRINT STORAGE
               CS                      *CLEAR PRINT STORAGE
               CC   1
               B    START2             *NOTHING WE LIKE HAS BEEN FOUND
     *
     *******************************************************************
     *
     PUNCH     B    D003,D             *IF SS Debug IS ON, ID THE LOCATION
               B    D004               *IF NOT, GO TO WORK
     D003      MCW  @D003@,260         *IDENTIFY THE LOCATION 
               W                       *PRINT
               CS   290                *CLEAR PRINT STORAGE
     D004      CS   181                *CLEAR PUNCH BUFFER
               LCA  GMWM,181           *SET GROUP MARK WORD MARK
               MCW  %Z1,101,R          *READ A RECORD FROM PC INTO PUNCH  BUFFER
     *                    
               SW   101                *SET A WORDMARK FOR COMPARE
               C    @$EOF$@,105        *ARE WE DONE?
               BE   PUNEXT             *YES WE ARE
     *
               P                       *PUNCH IT
               CS   181                *CLEAR PUNCH STORAGE
               B    PUNCH              *GO READ ANOTHER ONE
     *
     PUNEXT    CS   181                *CLEAR PUNCH STORAGE
               P                       *PUNCH A BLANK CARD
               P                       *PUNCH ANOTHER BLANK CARD
               B    EXIT               *GET OUT OF HERE
     *
     ****************************************************************
     *
     PRINT0    B    D005,D             *IF SS Debug IS ON, ID THE LOCATION
               B    D006               *IF NOT, GO TO WORK
     D005      MCW  @D005@,260         *IDENTIFY THE LOCATION 
               W                       *PRINT
               CS   290                *CLEAR PRINT STORAGE
     D006      CS   181                *CLEAR PUNCH BUFFER
               MCW  @1@,FORTR          *SET FLAG FOR FORTRAN FORMATTING
     *
     AGAIN0    CS   333                *CLEAR PRINT BUFFER
               CS                      *CLEAR PRINT BUFFER
               LCA  GMWM,333           *SET GROUP MARK WORD MARK
               MCW  %Z1,201,R          *READ A RECORD FROM PC INTO PRINT  BUFFER
     *
               SW   201                *SET WM FOR COMPARE
               C    @$EOF$@,205        *ARE WE DONE?
               BE   PRTEXT             *YES WE ARE
     *
               MCW  201,FORCC          *PICK UP FORTRAN CARRIAGE CONTROL CHARACTER
               MCW  @ @,201            *CLEAR 201
               BCE  TOF,FORCC,1        *IS IT TOP OF FORM?
               BCE  DBLSP,FORCC,0      *IS IT DOUBLE SPACE?
               BCE  OVRPR,FORCC,S      *IS IT OVER PRINT?
     *
               W                       *PRINT IT NORMAL AND GO GET ANOTHER
               B    AGAIN0             
     *
     TOF       CC   1                  *HEAD OF FORM
               MCW  @00@,LINCNT        *RESET LINE COUNT
               W    AGAIN0             *PRINT IT
     *
     DBLSP     W                       *PRINT IT 
               CS   333                *CLEAR PRINT STORAGE
               CS                      *CLEAR PRINT STORAGE
               W    AGAIN0             *DOUBLE SPACE
     *
     OVRPR     W                       *WRITE WITH NO SPACING
               DC   @S@                *WRITE WITHOUT SPACING
               B    AGAIN0
     *
     ******************************************************
     *
     PRINT     B    D007,D             *IF SS Debug IS ON, ID THE LOCATION
               B    D008               *IF NOT, GO TO WORK
     D007      MCW  @D007@,260         *IDENTIFY THE LOCATION 
               W                       *PRINT
               CS   290                *CLEAR PRINT STORAGE
     D008      CS   181                *CLEAR PUNCH BUFFER
               MCW  @00@,LINCNT        *ZERO LINE COUNT
     *
     PRINT2    CS   333                *CLEAR PRINT BUFFER
               CS                      *CLEAR PRINT BUFFER
               LCA  GMWM,333           *SET GROUP MARK WORD MARK
               MCW  %Z1,201,R          *READ A RECORD FROM PC INTO PRINT  BUFFER
     *
               SW   201                *SET WM FOR COMPARE
               C    @$EOF$@,205        *ARE WE DONE?
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
               B    EXIT
     *
     ****************************************************************
     *
     *
     *******************************************************************
     *
     LOAD      B    D009,D             *IF SS Debug IS ON, ID THE LOCATION
               B    D010               *IF NOT, GO TO WORK
     D009      MCW  @D009@,260         *IDENTIFY THE LOCATION 
               W                       *PRINT
               CS   290                *CLEAR PRINT STORAGE
     D010      CS   081                *CLEAR 081 TO 000 WE NEED THIS
               LCA  @Z@,13950          *PUT A FLAG IN ALMOST HIGH MEMORY
               MCW  @099@,X1           *SET X1 TO START
     MEMCLR    CS   0&X1               *CLEAR MEMORY
               MA   @100@,X1           *ADD 100 TO X1
               BCE  MEMCLR,13950,Z     *IF IT HAS NOT GOTTEN HERE YET
     *
     *       DONE WITH CLEARING MEMORY
     *        
     *
               MCW  @0000@,CRDCNT      *ZERO CARD COUNTER
               CS   081                *CLEAR READ BUFFER
     LOAD2     LCA  GMWM,081           *SET GROUP MARK WORD MARK
               MCW  %Z1,001,R          *READ A RECORD FROM PC INTO CARD  BUFFER                 
               A    @1@,CRDCNT         *ADD ONE TO CARD COUNT
               SW   001                *SET A WORDMARK FOR COMPARE
               C    CRDCNT,@0001@      *IS THIS LINE 1?
               BE   LINE1              *IF SO, GO TO LINE 1
               C    CRDCNT,@0002@      *IS THIS LINE 2?
               BE   LINE2              *IF SO, GO TO LINE 1
               B    LOAD3              *DO THE REAL THING
     LINE1     BCE  LOAD2,001,,        *IF THE FIRST CHAR IS A ,
               B    LODERR             *BAD RECORD
     LINE2     BCE  LOAD2,001,L        *IF THE FIRST CHAR IS A L
               B    LODERR             *BAD RECORD
     LOAD3     MCW  GETBK,071          *SET THE ADDRESS
               MCW  @B@,068            *SET THE OPCODE
               C    CRDCNT,@0003@      *IS THIS LINE 3?
               BE   001                *JUMP OFF THE PIER IF CARD 3
               B    040                *JUMP OFF THE BIGGER PIER IF CARD 3+
     *
     LODERR    MCW  @ERROR RECORD NUMBER @,221
               MCW  CRDCNT,226
               MCW  080,310
               W
               CS   332
               CS
               B    START
     **********************************************************************
     READ      B    D011,D             *IF SS Debug IS ON, ID THE LOCATION
               B    D012               *IF NOT, GO TO WORK
     D011      MCW  @D011@,260         *IDENTIFY THE LOCATION 
               W                       *PRINT
               CS   290                *CLEAR PRINT STORAGE
     D012      CS   081                *CLEAR READ BUFFER
               R                       *READ A CARD
               B    EXIT,A             *ARE WE EMPTY OF CARDS?
     *
               CS   332                *CLEAR PRINT BUFFER
               CS                      *CLEAR PRINT BUFFER
               SW   001                *SET WORD MARK AT FRONT
               MCW  080,280            *MOVE DATA TO PRINT BUFFER
               MCW  @READ DATA@,299    *MOVE ID TO PRINT BUFFER
               W                       *PRINT
               CS   332                *CLEAR PRINT STORAGE
               CS   299                *CLEAR PRINT STORAGE
               C    004,@(EOF)@        *SEE IF WE ARE DONE
               BE   EXIT               *IF SO, GET OUT
     *
     *
     *         NOW WE WILL WORK OUR WAY DOWN THE CARD AND 
     *         SEND ONE COLUMN AT A TIME
     *
               MCW  @000@,X1            *INITIALIZE X1
               MCW  @000@,COUNT         *INITIALIZE COUNT
     *
     LOOP      MCW  @0@,CHRL            *SET CHAR TO ZERO
               MCW  @0@,CHRM            *SET CHAR TO ZERO
               MCW  @0@,CHRH            *SET CHAR TO ZERO
               MZ   001&X1,TEST         *SETUP TEST
               BCE  BITAON,TEST,T       *TESTING FOR A BIT
               BCE  BITBON,TEST,L       *TESTING FOR B BIT 
               BCE  BITAON,TEST,C       *TESTING FOR A&B BIT
               BCE  BITBON,TEST,C       *TESTING FOR A&B BIT  
     *
               BBE  BIT8ON,001&X1,8     *BRANCH IF 8 BIT ON
               BBE  BIT4ON,001&X1,4     *BRANCH IF 4 BIT ON
               BBE  BIT2ON,001&X1,2     *BRANCH IF 2 BIT ON
               BBE  BIT1ON,001&X1,1     *BRANCH IF 1 BIT ON
     *
               MCW  CHRH,OUTBUF-3       *SET THE HIGH (FIRST) CHARACTER
               MCW  CHRM,OUTBUF-2       *SET THE MIDDLE (SECOND) CHARACTER
               MCW  CHRL,OUTBUF-1       *SET THE LAST (THIRD) CHARACTER
               LCA  GMWM,OUTBUF         *SET GROUP MARK WORD MARK
               MCW  %Z1,OUTBUF-3,W         *SEND THE DATA
               CS   333                 *CLEAR PRINT BUFFER
               CS                       *CLEAR PRINT BUFFER
               SW   201
               MCW  001&X1,201
               MCW  OUTBUF-1,210
               W
     *
               MA   @001@,X1            *INCREMENT X1
               A    @001@,COUNT         *ONE MORE CHARACTER DONE
               C    @080@,COUNT         *SEE OF WE ARE DONE WITH THIS CARD
               BL   LOOP                *NOT DONE YET
     *
               B    READ                *LETS GO DO THE NEXT CARD
     *
     ***********************************************************
     *
     BITAON    SBR  RETURN&3            *STORE RETURN ADDRESS
               A    @4@,CHRM            *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     BITBON    SBR  RETURN&3            *STORE RETURN ADDRESS
               A    @2@,CHRM            *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     BIT8ON    SBR  RETURN&3            *STORE RETURN ADDRESS
               A    @1@,CHRM            *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     BIT4ON    SBR  RETURN&3            *STORE RETURN ADDRESS
               A    @4@,CHRL            *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     BIT2ON    SBR  RETURN&3            *STORE RETURN ADDRESS
               A    @2@,CHRL            *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     BIT1ON    SBR  RETURN&3            *STORE RETURN ADDRESS
               A    @1@,CHRL            *ADD IN THE BIT AMOUNT
               B    RETURN              *GO CHECK THE NEXT ONE
     *
     ***********************************************************
     EXIT      H    *-2
               NOP
     RETURN    B    000                 *GENERAL RETURN LOCATION
     *                                  *GO CHECK THE NEXT ONE
     *
               END  START
