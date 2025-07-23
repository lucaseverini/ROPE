     ****************************************************************
     ** PUNCHS - Copy a string to storage area and punch when full  
     ****************************************************************
     
     $MAIN    SBR  PUNS1+3            * Setup return address
     
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

