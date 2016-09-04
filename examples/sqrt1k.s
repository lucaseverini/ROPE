               JOB  Compute the square root of 2 to 1,000 decimal places
               CTL  6611
     *
               ORG  87
     X1        DSA  0                  index register 1
               ORG  92
     X2        DSA  0                  index register 2
               ORG  97
     X3        DSA  0                  index register 3
     *
               ORG  333
     *
     * Print header.
     *
     START     CS   332
               CS
               MCW  N,319
               MCW  LABEL1
               W
     *
     * Call the square root subroutine.
     *
               ZA   LENN,SQLENN        SQLENN = LENN
               ZA   DP,SQDP            SQDP   = DP
     *
               SBR  SQADRN,N           SQADRN = @N
               SBR  SQADRX,X           SQADRX = @X
               SBR  SQADRP,XPREV       SQADRP = @XPREV
               SBR  SQADRT,TEMP        SQADRT = @TEMP
               B    SQRT
     *
     * Print the number of iterations.
     *
               CS   332
               CS
               W
               MCW  LABEL2,319
               MCW  SQITERS
               W
     *
     FINIS     H    FINIS
               H
     *
     N         DCW  02
               DC   #2000              len = 2*dp [decimal places]
     *
     X         DCW  #1002              len = len(N) + dp
               DC   #2                 remainder of /2: len = 2
     *
     XPREV     DCW  #1002              len = len(X)
     *
     TEMP      DCW  #2002              len = len(N) + 2*dp
               DC   #1003              remainder of /X: len = len(X) + 1
     *
     LENN      DCW  2                  len(N)
     DP        DCW  1000               number of decimal places (dp)
     ITERS     DCW  000                iteration counter
     *
     LABEL1    DCW  @The square root of @
     LABEL2    DCW  @ iterations@
     ***************************************************************************
     *
     *     Square root subroutine
     *
     *     This subroutine computes the square root of N to dp decimal places
     *     using Newton's algorithm:
     *
     *         x = (x + n/x)/2
     *
     *     where x is initialized to n, and the formula iterates until two
     *     successive values of x (x and xprev) are the same.  The caller
     *     must also supply a temporary work area.
     *
     *     Entry point:  SQRT
     *
     *     Before calling, the caller must set:
     *
     *         SQLENN = len(N)
     *         SQDP   = dp
     *         SQADRN = @N
     *         SQADRX = @X
     *         SQADRP = @XPREV
     *         SQADRT = @TEMP
     *
     *     Upon return:
     *
     *         X      = sqrt(N)
     *         SQITER = number of iterations
     *
     *     Notes:
     *
     *         (1) N must be followed in memory by 2*dp zeroes (or blanks)
     *         (2) len(X) must be len(N) + dp, and it must be followed in
     *             memory by 2 zeroes (or blanks)
     *         (3) len(XPREV) must be len(X)
     *         (4) len(TEMP) must be len(N) + 2*dp, and it must be followed
     *             in memory by (len(X) + 1) zeroes (or blanks)
     *
     ***************************************************************************
     SQRT      SBR  SQRTX&3
     *
     * Set @X, @XPREV, and @TEMP
     *
               MCW  SQADRX,SQZA1&6     @X
               MCW  SQADRX,SQLOOP&3    @X
               MCW  SQADRX,SQZA2&3     @X
               MCW  SQADRX,SQD1&3      @X
               MCW  SQADRX,SQA&3       @X
               MCW  SQADRP,SQLOOP&6    @XPREV
               MCW  SQADRP,SQZA2&6     @XPREV
               MCW  SQADRT,SQA&6       @TEMP
               MCW  SQADRT,SQZA4&3     @TEMP
     *
     * Compute and set @X + 2
     *
               MCW  SQADRX,SQZA4&6     @X
               MA   @002@,SQZA4&6         + 2
     *
     * Compute and set @X - dp
     *
               MCW  SQADRX,SQSBR&6     @X
               ZA   SQDP,CNVOFF           - dp
               B    CNVRTN
               MA   CNVOFF,SQSBR&6
     *
     * Compute and set @X - (len(N) + dp) + 2
     *
               MCW  SQADRX,SQD2&6      @X
               ZA   SQLENN,CNVOFF         - len(N)
               B    CNVRTN
               MA   CNVOFF,SQD2&6
               ZA   SQDP,CNVOFF                    - dp
               B    CNVRTN
               MA   CNVOFF,SQD2&6
               MA   @002@,SQD2&6                        + 2
     *
     * Compute and set @N + dp
     *
               MCW  SQADRN,SQZA1&3     @N
               ZA   SQDP,CNVOFF           + dp
               B    CNVRTP
               MA   CNVOFF,SQZA1&3
     *
     * Compute and set @N + 2*dp
     *
               MCW  SQADRN,SQZA3&3     @N
               ZA   SQDP,CNVOFF           + dp
               A    CNVOFF                     + dp
               B    CNVRTP
               MA   CNVOFF,SQZA3&3
     *
     * Compute and set @TEMP + len(N) + dp + 1
     *
               MCW  SQADRT,SQZA3&6     @TEMP
               ZA   SQLENN,CNVOFF            + len(N)
               B    CNVRTP
               MA   CNVOFF,SQZA3&6
               ZA   SQDP,CNVOFF                       + dp
               B    CNVRTP
               MA   CNVOFF,SQZA3&6
               MA   @001@,SQZA3&6                          + 1
     *
     * Compute and set @TEMP + len(N) - dp + 1
     *
               MCW  SQADRT,SQD1&6      @TEMP
               ZA   SQLENN,CNVOFF            + len(N)
               B    CNVRTP
               MA   CNVOFF,SQD1&6
               ZA   SQDP,CNVOFF                       - dp
               B    CNVRTN
               MA   CNVOFF,SQD1&6
               MA   @001@,SQD1&6                           + 1
     *
     * Compute and set @TEMP - (len(N) + dp)
     *
               MCW  SQADRT,SQSW&3      @TEMP
               ZA   SQLENN,CNVOFF            - len(N)
               B    CNVRTN
               MA   CNVOFF,SQSW&3
               ZA   SQDP,CNVOFF                       - dp
               B    CNVRTN
               MA   CNVOFF,SQSW&3
     *
               SW   SQCW&1
               MCW  SQSW&3,SQCW&3
               CW   SQCW&1
     *
     * Newton's algorithm:
     *
     *     x = xprev;
     *     while (x != xprev) {
     *         xprev = x;
     *         x = (x + n/x)/2;
     *     }
     *
               MCW  @0@,SQITER         SQITER = 0
     SQZA1     ZA   000,000            X = upper half of N
     *
     SQLOOP    C    000,000            if X = XPREV?
               B    SQRTX,S                then done
               A    @1@,SQITER             else bump SQITER by 1
     *
     SQZA2     ZA   000,000            XPREV = X
     SQZA3     ZA   000,000            TEMP = N
     SQD1      D    000,000                    /X
     SQSW      SW   000
     SQA       A    000,000                       + X
     SQZA4     ZA   000,000
     SQD2      D    @2@,000            X = TEMP/2
     SQCW      CW   000
     *
     * Print X and loop again.
     *
     SQSBR     SBR  PRADDR,000         PRADDR = @X - dp
               MCW  SQDP,PRDP          PRDP = dp
               B    PRINT
               B    SQLOOP
     *
     SQRTX     B    0000               return
     *
     SQLENN    DCW  000                len(N)
     SQDP      DCW  0000               number of decimal places (dp)
     SQITER    DCW  000                iteration counter
     *
     SQADRN    DSA  000                @N
     SQADRX    DSA  000                @X
     SQADRP    DSA  000                @XPREV
     SQADRT    DSA  000                @TEMP
     ***************************************************************************
     *
     *     Convert offset subroutine
     *
     *     This subroutine converts an offset that is a 5-digit number
     *     into its 3-character address encoding.
     *
     *     Entry points:  CNVRTP for positive offsets
     *                    CNVRTN for negative offsets
     *                               (passed in as a positive value)
     *
     *     Before calling, the caller must set:
     *
     *         CNVOFF = offset to add or subtract from an address
     *                  (5-digit number)
     *
     *     Upon return:
     *
     *         CNVOFF = offset value suitable for the MA instruction
     *                  (3-character address encoding)
     *
     ***************************************************************************
     CNVRTP    SBR  CNVRTX&3           entry point for positive offsets
               B    CNV
     *
     * Form the complement of the offset by subtracting it from 16,000
     *
     CNVRTN    SBR  CNVRTX&3           entry point for negative offsets
               A    -16000,CNVOFF      complement is -(-16000 + offset)
               ZS   CNVOFF                 or 16000 - offset
     *
     CNV       MZ   @ @,CNVOFF         clear zone over the units digit
     *
     * Successively test the thousands digits for 08, 04, 02, and 01.
     * The C (compare) instruction uses the collating sequence, not algebra;
     * hence the zone bit removals.
     *
               C    @08@,CNVOFF-3      8000
               BL   *&22
               MA   CNV8K,CNVOFF       set B bit over units digit
               S    @08@,CNVOFF-3
               MZ   @ @,CNVOFF-3       clear zone over the thousands digit
     *
               C    @04@,CNVOFF-3      4000
               BL   *&22
               MA   CNV4K,CNVOFF       set A bit over units digit
               S    @04@,CNVOFF-3
               MZ   @ @,CNVOFF-3       clear zone over the thousands digit
     *
               C    @02@,CNVOFF-3      2000
               BL   *&22
               MA   CNV2K,CNVOFF       set B bit over hundreds digit
               S    @02@,CNVOFF-3
               MZ   @ @,CNVOFF-3       clear zone over the thousands digit
     *
               C    @01@,CNVOFF-3      1000
               BL   *&22
               MA   CNV1K,CNVOFF       set A bit over hundreds digit
               S    @01@,CNVOFF-3
               MZ   @ @,CNVOFF-3       clear zone over the thousands digit
     *
     CNVRTX    B    000                return
     *
     CNVOFF    DCW  00000              offset to convert
     *
     CNV8K     DSA  8000
     CNV4K     DSA  4000
     CNV2K     DSA  2000
     CNV1K     DSA  1000
     ***************************************************************************
     *
     *     Print subroutine
     *
     *     This subroutine prints a value with a large number of decimal
     *     digits, in 10 groups of 10 digits per line.  NOTE: The number of
     *     decimal digits must be a multiple of 100.
     *
     *     Entry point:  PRINT
     *
     *     Before calling, the caller must set:
     *
     *         PRADDR = address of first decimal digit of value to print
     *         PRDP   = dp (decimal places)
     *
     *     The caller must also properly define symbols X1 and X2
     *     to represent index registers 1 and 2.
     *
     ***************************************************************************
     PRINT     SBR  PRINTX&3
     *
               MCW  X1,PRSVX1          save X1 and X2
               MCW  X2,PRSVX2
     *
               MCW  PRADDR,X1          X1 = @ first decimal digit
               MCW  @0001@,PRDGCT
               SBR  X1,10&X1           X1 = @ first group within X
               S    @100@,PRDP
     *
               CS   332                print a blank line
               CS
               W
     *
               SW   202,208            set word marks to delimit groups
               SW   222,233
               SW   244,255
               SW   266,277
               SW   288,299
               SW   310
     *
               MCW  PREDT1,220         edit mask for first group
               MCW  PRCLON
               MCW  PRDGCT
     *
     * Loop once per line.
     *
     PRLNLP    SBR  X2,220             X2 = 220
               MCE  0&X1,0&X2          edit the first group of each line
               MCW  @8@,PRGPCT         PRGPCT = 8
     *
     * Fill the rest of the line by looping once per group within the line.
     *
     PRGPLP    SBR  X1,10&X1           bump X1 by 10
               SBR  X2,11&X2           bump X2 by 11
               MCW  0&X1,0&X2          move next group of 10 to print
     *
               S    @1@,PRGPCT         reduce PRGPCT by 1
               BWZ  PRGPDN,PRGPCT,K    done with all groups of line?
               B    PRGPLP             back to move the next group
     *
     PRGPDN    MCW  @0@,0&X2
               MN   0&X1,0&X2          move numeric of last digit
               W
     *
               S    @100@,PRDP
               BWZ  PRLNDN,PRDP,K      done with all lines?
     *
               A    @100@,PRDGCT
               SBR  X1,10&X1           bump X1 by 10
               MCW  PREDT2,220         edit mask for subsequent lines
               MCW  @   @
               MCW  PRCLON
               MCW  PRDGCT
               SW   211
               B    PRLNLP             back to print the next line
     *
     PRLNDN    MCW  PRSVX1,X1          restore X1 and X2
               MCW  PRSVX2,X2
     PRINTX    B    000                return
     *
     PRADDR    DSA  000                @ of first decimal digit
     PRDP      DCW  0000               decimal places (dp)
     *
     PRDGCT    DCW  0001               group counter
     PRGPCT    DCW  8                  decimal digit counter
     PRSVX1    DCW  000                save area for X1
     PRSVX2    DCW  000                save area for X2
     *
     PRCLON    DCW  @: @
     PREDT1    DCW  @ 0.          @    edit mask for first line
     PREDT2    DCW  @0         @       edit mask for subsequent lines
     ***************************************************************************
               END  START
