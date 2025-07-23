               JOB       POWER2NOTEPAD
     *
               CTL       6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD
     *   1         2         3         4         5         6         7         8
     *78901234567890123456789012345678901234567890123456789012345678901234567890
     * label   | op | OPERATION                                         |xxxxxxx
               ORG  100          * START ABOVE INDEX "REGISTERS" 
     PRINTD    CS   633          * start clearing down to 200, PRINT AREA
               CS                * 500s  500 IS HIGH ORDER OF WORK AREA 1 - TO 632
               CS                * 400s
               CS                * 300s  350 IS HIGH ORDER OF WORK AREA 2 - TO 482
               CS                * 200s  201 IS HIGH ORDER OF PRINT AREA - TO 332
               SW   500,350      * SET WORD MARKS FOR WORK AREAS
               SW   200          * SET WORD MARK FOR PRINT AREA COMPARE 
               MCW  @1@,632      * SET INITIAL 2^0
               MCW  @56789@,204  * set test pattern for bug check ;-))
               W                 *write the TEST PATTERN  area to the printer
     *                       SEE IF LOCATION 202 IS KLOBBERED :-))
     PR1LOP    ZA   @1@,334      * SET ZEROS FOR EDIT COMMAND INTO PRINT FIELD
               MCE  632,332      * EDIT FROM WORK AREA 2 INTO PRINT BUFFER
               W                 *write the print area to the printer
               MCW  632,482      * COPY  WORK AREA 1 INTO WORK AREA 2
               SW   200          * RESTORE WORD MARK OBLITERATED BY MCW
               A    482,632      * ADD WORK AREA 2 TO WORK AREA 1
               C    @  @,201     * ARE WE DONE WITH RON'S PRINT VERSION
               BE   PR1LOP           *  NO, DO SOME MORE
               H    PRINTD           * HALT  - OH RATS, I FORGOT TO EJECT THE PAGE
               B    PRINTD           * AND DO IT AGAIN :-)
               END  PRINTD           * LAST CARD IN DECK, TRANSFER ADDRESS
