               JOB  AUTOCODER PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD

     *         DCW  @C-OUTPUT@        * 12-2-2014
          
     ****************************************************************

     READ      EQU  001
     PUNCH     EQU  101
     PRINT     EQU  201
     
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
    
               MCW  CHPOS, X1          * Put char in the right place...
               MCW  PRTC2, PRINT+X1
           
               MCW  PRTC3, X1          * Restore X1
     
               A    @1@, CHPOS         * Increment position for next char
     
               C    CHPOS, @132@       * Check if print area is full
               BU   PRTC1              * If not jump over
     
               B    PFLUSH             * Prints everything
    
     PRTC1     B    000                * Jump back

     PRTC2     DCW  0 
     PRTC3     DCW  000 

     **************************************************************** 
     ** PFLUSH - Prints and resets print area and character position
     ****************************************************************
     
     PFLUSH    SBR  FLUSH9+3           * Setup return address     
     
               W                       * Prints
               CS   332
               CS   299                * Clear area
               MCW  @000@, CHPOS       * Reset position for next char
     
     FLUSH9    B    000                * Jump back

     CHPOS     DCW  000                * char position
     
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
