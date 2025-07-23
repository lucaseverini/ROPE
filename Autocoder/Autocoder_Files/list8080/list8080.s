               JOB  80/80 CARD LISTER
               CTL  6611
     *
               ORG  333
     *
     * Print the header.
     *
     START     CS   332
               CS
               SW   1,201
     *
     READ      R                       READ A CARD
               MCW  80,280             MOVE TO PRINT AREA
               W                       PRINT IT
               B    DONE,A             BRANCH IF LAST CARD READ
               B    READ               ELSE GO READ ANOTHER CARD
     *
     DONE      H    DONE
               H
               END  START
