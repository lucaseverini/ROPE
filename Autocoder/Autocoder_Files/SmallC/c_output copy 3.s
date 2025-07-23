               JOB  AUTOCODER PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD

     *         DCW  @C-OUTPUT@        * 12-2-2014
          
     ****************************************************************

     READ      EQU  001
     PUNCH     EQU  101
     PRINT     EQU  201
     
     PRCPOS    DCW  000                * char position
     PUCPOS    DCW  000                * char position
     PUNSIZ    DCW  @080@
     PRTSIZ    DCW  @132@
     EOS       DCW  @'@
     EOL       DCW  @;@

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
     V4        DCW  0
               DCW  00000000000000000000
               DCW  00000000000000000000
               DCW  00000000000000000000
               DCW  00000000000000000000
               DCW  00000000000000000000
     V5        DCW  @LUCA;SEVERINI'@
      
     START     NOP
     
     ****************************************************************  
      
               SBR  X2, 400
     
               SBR  X1, V5-13
               PUSHA X1
               B    PRTS
               B    PFLUSH
     
               MCW  @013@, V3
               
     L1        SBR  X1, V4
               PUSHA X1
               PUSHI @080@
               B     READS
 
               SBR  X1, V4
               PUSHA X1
               B    PRTS
               B    PFLUSH
     
               S    @1@, V3
               C    @00?@, V3
               BU   L1
    
               H
               B    *-3

     ****************************************************************
     ** CMPB COMPARE for CHAR (3 DIGITS)
     ** If OP1 > OP2, RESULT = 1
     ** If OP2 < OP1, RESULT = 2
     ** if OP1 == OP2, RESULT = 3
     ****************************************************************

     CMPB      SBR  CMPB6+3            * Setup return address
     
               POPI OP2
               POPI OP1

               MCW  @3@, RESULT        * Pre-set RESULT for EQUAL
               B    CHKZI              * Check for negative zeros
               ZA   OP2, TMP           * Move OP2 to TMP
               S    OP1, TMP           * SUBTRACT OP1 FROM TMP
               MN   @1@, TMP           * SET TO 1 SO NEGATIVE IS A j
               BCE  CMPB1, TMP, J      * If LSD of TMP is a J, OP1 > OP2
               B    CMPB3              * Next check
     CMPB1     MCW  @1@, RESULT        * set RESULT to 1 if op1 > op2
     CMPB3     ZA   OP1, TMP           * Move OP2 to TMP
               S    OP2, TMP           * SUBTRACT OP2 FROM TMP
               MN   @1@, TMP           * SET TO 1 SO NEGATIVE IS A j
               BCE  CMPB4, TMP, J      * If LSD of TMP is a J, OP1 > OP2 otherwise OP1 == OP2
               B    CMPB5              * Go out
     CMPB4     MCW  @2@, RESULT        * Set RESULT to 2 if op2 > op1
     
     CMPB5     NOP
               PUSHB RESULT
     
     CMPB6     B    000                * Jump back

     OP1       DCW  00000
     OP2       DCW  00000
     TMP       DCW  00000
     RESULT    DCW  0

     ****************************************************************

     CHKZI     SBR  CHKZI4+3           * Setup return address
               C    NEGZI, OP1         * Is OP1 a Negative Zero ?
               BU   CHKZI2             * If is not go next check
               MCW  @?@, OP1           * Set OP1 to Normal Zero
     CHKZI2    C    NEGZI, OP2         * Is OP2 a Negative Zero ?
               BU   CHKZI4             * If is not jump over
               MCW  @?@, OP2           * Set OP2 to Normal Zero
     CHKZI4    B    000                * Jump back

     NEGZI     DCW  -00000             * Negative Zero

     ****************************************************************
     ** PUNCHS - Copy a string to storage area and punch when full  
     ****************************************************************
     
     PUNCHS    SBR  PUNS1+3            * Setup return address
     
               MCW  X1, PUNS6          * Save X1
         
               POPA X1                 * String address in X1
     
     PUNS2     MCW  0+X1, PUNS5        * Copy char in temp storage
               C    EOS, PUNS5         * Check if is the String Terminator
               BE   PUNS7              * If it is then jump to end          
               C    EOL, PUNS5         * Check if is the EOL
               BU   PUNS3              * If it is not then jump over   
               B    PFLUSH             * Print the print buffer
               B    PUNS4              * Jump to next char
     
     PUNS3     NOP
               PUSHB PUNS5             * Push the char onto stack
               B    PUNCHC             * Put char in print area
               
     PUNS4     SBR  X1, 1+X1           * Point to next char
               B    PUNS2              * Do it again...
     
     PUNS7     MCW  PUNS6, X1          * Restore X1
                                       
     PUNS1     B    000                * Jump back
     
     PUNS5     DCW  0 
     PUNS6     DCW  000 

     ****************************************************************
     ** PUNCHC - Copy a char to storage area and punch when full      
     ****************************************************************
     
     PUNCHC    SBR  PUNC1+3            * Setup return address
     
               POPB PUNC2              * Gets char from stack
     
               MCW  X1, PUNC3          * Save X1
    
               MCW  PUCPOS, X1         * Put char in the right place...
               MCW  PUNC2, PUNCH+X1
           
               MCW  PUNC3, X1          * Restore X1
     
               A    @1@, PUCPOS        * Increment position for next char
     
               C    PUCPOS, PUNSIZ     * Check if print area is full
               BU   PUNC1              * If not jump over
     
               B    PUNCH              * Punch the row
    
     PUNC1     B    000                * Jump back

     PUNC2     DCW  0 
     PUNC3     DCW  000 

     **************************************************************** 
     ** PUNCH - Punch and resets punch area and character position
     ****************************************************************
     
     PUNCH    SBR  PUNCH9+3            * Setup return address     
     
               P                       * Punch card
               MCW  @000@, PRCPOS      * Reset position for next char
     
     PUNCH9    B    000                * Jump back
     
     ****************************************************************
     ** PRTS - Copy a string to storage area and prints when full  
     ****************************************************************
     
     PRTS      SBR  PRTS1+3            * Setup return address
     
               MCW  X1, PRTS6          * Save X1
         
               POPA X1                 * String address in X1
     
     PRTS2     MCW  0+X1, PRTS5        * Copy char in temp storage
               C    EOS, PRTS5         * Check if is the String Terminator
               BE   PRTS7              * If it is then jump to end          
               C    EOL, PRTS5         * Check if is the EOL
               BU   PRTS3              * If it is not then jump over   
               B    PFLUSH             * Print the print buffer
               B    PRTS4              * Jump to next char
     
     PRTS3     NOP
               PUSHB PRTS5             * Push the char onto stack
               B    PRTC               * Put char in print area
               
     PRTS4     SBR  X1, 1+X1           * Point to next char
               B    PRTS2              * Do it again...
     
     PRTS7     MCW  PRTS6, X1          * Restore X1
                                       
     PRTS1     B    000                * Jump back
     
     PRTS5     DCW  0 
     PRTS6     DCW  000 

     ****************************************************************
     ** PRTC - Copy a char to storage area and prints when full      
     ****************************************************************
     
     PRTC      SBR  PRTC1+3            * Setup return address
     
               POPB PRTC2              * Gets char from stack
     
               MCW  X1, PRTC3          * Save X1
    
               MCW  PRCPOS, X1         * Put char in the right place...
               MCW  PRTC2, PRINT+X1
           
               MCW  PRTC3, X1          * Restore X1
     
               A    @1@, PRCPOS        * Increment position for next char
     
               C    PRCPOS, PRTSIZ     * Check if print area is full
               BU   PRTC1              * If not jump over
     
               B    PFLUSH             * Prints everything
    
     PRTC1     B    000                * Jump back

     PRTC2     DCW  0 
     PRTC3     DCW  000 

     **************************************************************** 
     ** PFLUSH - Prints and resets print area and character position
     ****************************************************************
     
     PFLUSH    SBR  FLUSH9+3           * Setup return address     
     
               W                       * Print the row
               CS   332
               CS   299                * Clear area
               MCW  @000@, PRCPOS      * Reset position for next char
     
     FLUSH9    B    000                * Jump back

     PRCPOS     DCW  000               * char position
     
     ****************************************************************
     ** READS - Read then copy the data in read area to string whose pointer 
     **        is on stack until the end of the string or the read area
     **        Argument passed on stack: String pointer and String Max Length        
     ****************************************************************
     
     READS     SBR  READS3+3           * Setup return address
 
               R                       * Read a card
     
               MCW  X1, READS4         * Save index registers...
               MCW  X3, READS5
 
               POPI READS8             * Max length in LEN
               POPA READS7             * String address in X1
     
               C    @000@, READS7      * Check for null pointer
               BE   READS9             * If null, bail out
               
               MZ   READS8-1, READS8   * Remove bit-zone to get a real decimal number
               C    @000@, READS8      * Check string max length
               BE   READS9             * If LEN == 0 then bail out
     
               MCW  @000@, READS6
     
               SBR  X3, READ
               MCW  X1, READS7

     READS1    C    READS6, READS8     * Check if max num of chars has been read
               BE   READS2             * If it is then jump over
     
               MCW  0+X3, 0+X1
     
               SBR  X3, 1+X3
               SBR  X1, 1+X1
               
               A    @1@, READS6        * Increment TOTRD
               B    READS1             * Do it again...
     
     READS2    MCW  EOS, 0+X1
    
     READS9    MCW  READS4, X1         * Restore index registers...
               MCW  READS5, X3

     READS3    B    000                * Jump back
 
     READS4    DCW  000
     READS5    DCW  000
     READS6    DCW  000
     READS8    DCW  000
     READS7    DCW  000
    
     ****************************************************************  

     *         CLIB
     
               END  START
