     ****************************************************************
     ** PRTS - Copy a string to storage area and prints when full  
     ****************************************************************
     
     $MAIN     SBR  PRTS1+3            * Setup return address
     
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
