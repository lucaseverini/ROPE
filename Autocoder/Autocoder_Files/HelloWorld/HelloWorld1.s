               JOB  HELLOWORLD1.S 05/20/17 22:31:31                        -4691
     ***************************************************************************
     *     SSSSS = CARD SEQUENCE NUMBER          ********** = LABEL
     *     OPER- = OPERATION                     OPERATION--- = OPERATION
SSSSS**********OPER-OPERANDS----------------------------------------------------     
     **********|****|***********************************************************
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD     
     *
     READ      EQU  001
     PUNCH     EQU  101
     PRINT     EQU  201 
     * 
               ORG  85
               DCW  @X1@      *IDENTIFING FILLER
     X1        DCW  000       *INDEX REGISTER 1
               DCW  @X2@      *IDENTIFING FILLER
     X2        DCW  000       *INDEX REGISTER 2
               DCW  @X3@      *IDENTIFING FILLER
     X3        DCW  000       *INDEX REGISTER 3
     *
               ORG  340       *ORG JUST AFTER PRINT BUFFER
     *
     TEXT      DCW  @HELLO WORLD@
     START     MCW  TEXT,PRINT+10   *MOVE TEXT TO PRINT BUFFER
               W                    *PRINT A LINE
     EXIT      CS   332             *CLEAR PRINT STORAGE
               CS                   *CLEAR PRINT STORAGE
               CS                   *CLEAR PUNCH STORAGE
               CS                   *CLEAR READ STORAGE
     *         
               C    @SHAY@,14007    *WERE WE LOADED WITH THE LOADER?
               BE   14000           *YES WE WERE. TURN CONTROL BACK
     *         OTHERWISE.....       *TO THE LOADER
               NOP  999,999         *LOAD THE A AND B REGISTERS
               H                    *HALT OR I WILL SHOOT
     *
     *         GET READY TO BOOT FROM THE FOLLOWING DECK
     * 
                
               SW   001             *SET WORDMARK IN LOCATION 1
     EXRED     R                    *READ FIRST CARD OF NEXT DECK
               BCE  001,001,,       *IS IT A COMMA? 
     *                              *BRANCH TO THE FIRST INSTRUCTION
               B    EXRED           *CHECK THE NEXT ONE
               NOP
               END  START
