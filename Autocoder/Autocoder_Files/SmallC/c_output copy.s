               JOB  AUTOCODER PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD
     
               DCW  @C-OUTPUT@		* 12-2-2014
               
     ****************************************************************

     READ      EQU  001
     PUNCH     EQU  101
     PRINT     EQU  201

               ORG  87
     X1        DSA  0                  * INDEX REGISTER 1
               ORG  92
     X2        DSA  0                  * INDEX REGISTER 2
               ORG  97
     X3        DSA  0                  * INDEX REGISTER 3
     
               ORG  400
     
     SPBASE    EQU  400                * STACK BASE LOCATION
     KSPBAS    DCW  @400@              * STACK BASE CONSTANT
     SPTOP     EQU  600                * STACK TOP LOCATION
     KSPTOP    DCW  @600@              * STACK TOP CONSTANT
               DCW  @:@
     SP        DCW  0000               * STACK POINTER
               DCW  @:@
     SFP       DCW  0000               * STACK FRAME POINTER
               DCW  @:@
 
               ORG  500

     stack     DA   10x15              * 10 activation records of 15 chars
     retn           1,3                * See pages 16-19 of C24-3319
     arg1           4,6
     arg2           7,9
     sx2            10,12
     sx3            13,15
     stkptr    DSA  0
     rsize     EQU  15
     rsizec    EQU  15985
  
     ****************************************************************
     
     COUNT     DCW  6
     
     TEST      DCw  000
     TMP       DCW  000
     TMPADR    DCW  000
     STRING    DCW  @ABCDEFGH@
    
               ORG  700
     
     START     NOP
     
     ****************************************************************
     
               MCW  @3@, X3
           
               MCW  @BEFORE SUB1@,PRINT+10
               W  
               CS   299
     
               mcw  @Z@, STRING-6
     
               sbr  X1, TEST           * X1 POINTS TO TEST
               mcw  0+X1, TMP          * CONTENT OF LOCATION POINTED BY X1 COPIED INTO TMP
               mcw  @123@, TEST        * CHANGE CONTENT OF TEST
               mcw  X1, TMPADR         * ADDRESS OF LOCATION POINTED BY X1 COPIED INTO TMP
               mcw  0+X1, TMP          * CONTENT OF LOCATION POINTED BY X1 COPIED INTO TMP   
               mcw  @456@, 0+X1        * CHANGE CONTENT OF LOCATION POINTED BY X1
                         
               SBR  X1, COUNT          * X1 POINTS TO TEST
               MCW  X1, arg1+X2        * Copy X1 into stack arg1
               MCW  TEST, arg2+X2      * Copy TEST into stack arg2
               B    RECURS             * Jump to subroutine
     
     *         B    SUB1               * BRANCH TO SUBROUTINE

               MCW  @AFTER SUB1@,PRINT+9
               W  
               CS   299
     
               H
               B    *-3
     
     ****************************************************************
     ** SUBROUTINE WITH RECURSION (WORKS)
     ****************************************************************

     RECURS    SBR  *+7                * Copy return address from B-Address to next below
               SBR  X3, 000            * Return address to X3
               SBR  retn+X2, 0+X3      * Save return address to stack
               MCW  arg1+X2, LARG1
               MCW  arg2+X2, LARG2 
               B    STRT
     LARG1     DCW  000
     LARG2     DCW  000
              
     STRT      MCW  LARG1, PRINT+2     * Print the arguments...
               W  
               CS   299
               MCW  LARG2, PRINT+2
               W  
               CS   299

               C    @?@, COUNT         * Compare to signed zero
               BE   *+54               * If equal to signed zero jump to NOP below
               S    @1@, COUNT         * COUNT--
     
               A    @1@, LARG1
               A    @100@, LARG2
     
               SBR  stkptr, rsize+X2   * Push the next record to stack 
               MCW  stkptr, X2         * X2 points to stack
               MCW  LARG1, arg1+X2     * Copy LARG1 into stack arg1
               MCW  LARG2, arg2+X2     * Copy LARG2 into stack arg2
               B    RECURS             * Jump same subroutine (recursion)
     
               NOP                     * Just a placeholder
     
               SBR  X2, rsizec+X2      * Adiust X2 to point to previous record
               SBR  stkptr, 0+X2       * Pop the stack
               MCW  retn+X2, *+4       * Set return address in branch instruction   
               B    000                * Return back to caller

     ****************************************************************
     ** SUBROUTINE WITHOUT RECURSION
     ****************************************************************
     
     SUB2      SBR  RTN2+3             * SAVE RETURN ADDRESS
                      
               MCW  @SUB2@,PRINT+3
               W  
               CS   299
     
               B    RTN2
               NOP
     
     RTN2      B    000                * BRANCH BACK
    
     ****************************************************************

               MCW  @DONE@,PRINT+3
               W    

               H
               B    *-3
     
               END  START
