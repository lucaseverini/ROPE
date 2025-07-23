               JOB  PRINT_POETRY.S 11/19/18 21:06:39                       -0399
     * Program to print text placed on rows of up to 101 characters with a margin 
     * of 16 characters so to have it centered on the 132 columns of the IBM 1403 printer.
     * Other than the cards with the text divided in left cards (0 to 79) and right cards 
     * (80 to 100) there are three cards defining the header "(H)", the footer "(F)" and
     * the paragraph "(P)".
     * 
     * By Luca Severini 15-Nov-2018
     *
     CRDBFF    EQU  001                     * CARD READ AREA
     PRTBFF    EQU  201                     * PRINT AREA
     PRTBF1    EQU  217                     * LEFT-SIDE PART OF PRINT AREA + MARGIN OF 16
     PRTBF2    EQU  297                     * RIGHT-SIDE PART OF PRINT AREA

               ORG  400                     * PUT VARIABLES IN MEMORY FROM 400
               
     ROWCNT    DCW  @000@                   * COUNTER FOR HOW MANY ROW HAVE BEEN PRINTED
     CRDSEL    DCW  @0@                     * CARD SELECTOR 0 (LEFT) OR 1 (RIGHT)
     
               ORG  450                     * PUT PROGRAM CODE IN MEMORY FROM 450
    
     START     CS   CRDBFF&79               * CLEAR THE READ AREA FOR THE CARDS
               SW   CRDBFF                  * SET THE WORDMARK IN THE READ AREA
               SW   PRTBFF                  * SET THE WORDMARK IN THE PRINT AREA
 
     READ      B    EXIT, A                 * GO TO EXIT IF NO MORE CARDS TO READ
               R                            * READ NEXT CARD     
 
               C    @(H)@, 003              * IS IT THE HEADER CARD?
               BE   PRTHDR                  * IF YES PRINT THE HEADER

               C    @(F)@, 003              * IS IT THE FOOTER CARD?
               BE   PRTFTR                  * IF YES PRINT THE FOOTER

               C    @(P)@, 003              * IS IT THE PARAGRAPH CARD?
               BE   PRTPRG                  * IF YES PRINT THE HEADER

               C    @0@, CRDSEL             * DID WE READ THE LEFT CARD?
               BU   RIGHT                   * IF NOT IS THE RIGHT CARD
               MCW  CRDBFF&79, PRTBF1&79    * MOVE LEFT SIDE CHARACTERS IN PRINT AREA
               MCW  @1@, CRDSEL             * SET CARD SELECTOR TO 1 TO READ RIGHT CARD
               B    PRINT, A                * IF IS THE LAST CARD THEN PRINT IT
               B    READ                    * GO TO READ THE NEXT CARD
     RIGHT     MCW  CRDBFF&21, PRTBF2&21    * MOVE RIGHT SIDE CHARACTERS IN PRINT AREA
               MCW  @0@, CRDSEL             * SET CARD SELECTOR TO 0 TO READ LEFT CARD
 
     PRINT     W                            * PRINT THE ROW
     
               CS   PRTBFF&131              * CLEAR THE PRINT AREA
               CS
               SW   PRTBFF                  * SET THE WORDMARK IN THE PRINT AREA
               
               B    READ                    * GO TO READ THE NEXT CARD

     EXIT      H    START                   * WE HAVE DONE. HALT THE PROGRAM
               NOP                          * THE USUAL NOP AFTER THE HALT
               
     PRTHDR    CS   CRDBFF&79               * CLEAR THE READ AREA FOR THE CARDS
               SW   CRDBFF                  * SET THE WORDMARK IN THE READ AREA
               MCW  @000@, ROWCNT           * SET ROW COUNTER TO ZERO
     PRTHD2    W                            * PRINT ONE EMPTY ROW (IS THERE A CC CODE?)
               A    @001@, ROWCNT           * ADD 1 TO LINE COUNT
               C    @012@, ROWCNT           * DID WE PRINT 12 ROWS?
               BL   PRTHD2                  * PRINT ANOTHER ROW
               MCW  @0@, CRDSEL             * SET CARD SELECTOR TO 0 TO READ LEFT CARD
               B    READ                    * GO TO READ THE NEXT CARD

     PRTFTR    CS   CRDBFF&79               * CLEAR THE READ AREA FOR THE CARDS
               SW   CRDBFF                  * SET THE WORDMARK IN THE READ AREA
               C    @1@, CRDSEL             * DID WE READ THE LEFT CARD?
               BU   FRMFDD                  * IF NOT DONT PRINT
               W                            * PRINT THE ROW
     FRMFDD    CC   1                       * FORM FEED (OR SHOULD WE PRINT EMPTY ROWS?) 
               CS   PRTBFF&131              * CLEAR THE PRINT AREA
               CS                           * WHY DO WE NEED ANOTHER CS HERE??
               MCW  @0@, CRDSEL             * SET CARD SELECTOR TO 0 TO READ LEFT CARD
               B    READ                    * GO TO READ THE NEXT CARD
 
     PRTPRG    CS   CRDBFF&79               * CLEAR THE READ AREA FOR THE CARDS
               SW   CRDBFF                  * SET THE WORDMARK IN THE READ AREA
               C    @1@, CRDSEL             * DID WE READ THE LEFT CARD?
               BU   CLNPRT                  * IF NOT DONT PRINT
               W                            * PRINT THE ROW
     CLNPRT    CS   PRTBFF&131              * CLEAR THE PRINT AREA
               CS                           * WHY DO WE NEED ANOTHER CS HERE??
               SW   PRTBFF                  * SET THE WORDMARK IN THE PRINT AREA
               W                            * PRINT EMPTY ROW (IS THERE A CC CODE?)
               W                            * PRINT EMPTY ROW (IS THERE A CC CODE?)
               MCW  @0@, CRDSEL             * SET CARD SELECTOR TO 0 TO READ LEFT CARD
               B    READ                    * GO TO READ THE NEXT CARD
              
               END  START
