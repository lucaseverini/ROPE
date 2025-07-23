  ***************************************************************************
     *     SSSSS = CARD SEQUENCE NUMBER          ********** = LABEL
     *     OPER- = OPERATION                     OPERATION--- = OPERATION
SSSSS**********OPER-OPERANDS----------------------------------------------------     
**********|****|***********************************************************
               JOB  FIRST PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD     
     *  
               ORG  400
               DCW  @IBM 1401 CARD LIST PROGRAM 12-11-2008@
               DCW  @                               @
               DC   @IBM 1401 CARD LIST PROGRAM@
     LINE1     DC   @                              @
               DCW  @               1         2         3@
               DC   @         4         5         6@
     LINE2     DC   @         7         8 @ 
               DCW  @ CARD 123456789012345678901234567890@
               DC   @123456789012345678901234567890@
     LINE3     DC   @12345678901234567890 @
     CRDCNT    DCW  00000        *COUNT THE CARDS
     LNECNT    DCW  @55@         *COUNT THE LINES
     BEGIN     H
               SW   001          *saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa      
     TOPPAG    C    LNECNT,@55@  *SEE IF WE HAVE PRINTED 55 DATA LINES
               BU   DOCARD       *GUESS NOT
               CC   1            *SKIP TO TOP OF PAGE
               CS   232          *CLEAR THE PRINT LINE
               CS
               MCW  LINE1,287    *PUT UP THE TOP LINE
               W                 *PRINT
               MCW  LINE2,287    *PUT UP THE TOP LINE
               W                 *PRINT
               MCW  LINE3,287    *PUT UP THE TOP LINE
               W                 *PRINT
               MCW  @00@,LNECNT  *RESET LINE COUNT
               CS   299          *JUST IN CASE
               MCW  @>@,206      *MARK THE LEFT OF THE CARD
               MCW  @<@,287      *MARK THE RIGHT OF THE CARD
     DOCARD    R                 *READ A CARD
               B    LSTCRD,A     *LAST CARD?
               C    @LASTCARD@,108  *LAST CARD?
               BE   LSTCRD       *MUST BE
               A    @1@,CRDCNT   *ADD TO THE CARD COUNT
               MZ   CRDCNT-1,CRDCNT  *CLEAR ZONE
               MCW  CRDCNT,205   *PUT IN THE CARD COUNT
               MCW  080,286      *PUT IN THE CARD
               W                 *PRINT IT
               A    @1@,LNECNT   *ADD 1 TO LINE COUNT
               MZ   LNECNT-1,LNECNT  *CLEAR ZONE
               B    TOPPAG       *GO TO THE TOP OF PAGE ROUTINE
     LSTCRD    CS   299          *CLEAR STORAGE
               MCW  @*************** END OF FILE*************@,245  *SPECIFY END OF LINE
               W                 *PRINT IT
               CC   1            *TOP OF FORM
               H    *-3          *STOP AND BRANCH BACK IF START IS PRESSED
               NOP
               END  BEGIN
