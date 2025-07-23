     ****************************************************************
     ** PRTC - Copy a char to storage area and prints when full      
     ****************************************************************
     
     $MAIN     SBR  PRTC1+3            * Setup return address
     
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

