     **************************************************************** 
     ** PFLUSH - Prints and resets print area and character position
     ****************************************************************
     
     $MAIN     SBR  FLUSH9+3           * Setup return address     
     
               W                       * Prints
               CS   332
               CS   299                * Clear area
               MCW  @000@, CHPOS       * Reset position for next char
     
     FLUSH9    B    000                * Jump back

     CHPOS     DCW  000                * char position
     
