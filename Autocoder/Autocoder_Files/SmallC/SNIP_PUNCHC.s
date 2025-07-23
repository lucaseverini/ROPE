     ****************************************************************
     ** PUNCHC - Copy a char to storage area and punch when full      
     ****************************************************************
     
     @MAIN     SBR  PUNC1+3            * Setup return address
     
               POPB PUNC2              * Gets char from stack
     
               MCW  X1, PUNC3          * Save X1
    
               MCW  CHPOS, X1          * Put char in the right place...
               MCW  PUNC2, PUNCH+X1
           
               MCW  PUNC3, X1          * Restore X1
     
               A    @1@, CHPOS         * Increment position for next char
     
               C    CHPOS, PUNSIZ      * Check if print area is full
               BU   PUNC1              * If not jump over
     
               B    PFLUSH             * Prints everything
    
     PUNC1     B    000                * Jump back

     PUNC2     DCW  0 
     PUNC3     DCW  000 
