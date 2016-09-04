               JOB  Compute pi to 500 decimal places
               CTL  6611
     ***************************************************************************
     *
     *     Compute pi to 500 decimal places using the Borwein algorithm:
     *
     *     Initialization
     *
     *         y[0] = sqrt(2) - 1
     *         a[0] = 6 - 4*sqrt(2)
     *
     *     For i = 1 to 5
     *
     *         y4     = y[i-1]**4
     *         yroot4 = (1 - y4)**(1/4)
     *         y[i]   = (1 - yroot4)/(1 + yroot4)
     *         yterm4 = (1 + y[i])**4
     *         a[i]   = a[i-1]*yterm4
     *         power2 = 2**(2*i + 1)
     *         y2     = y[i]**2
     *         aterm  = power2*y[i]*(1 + y[i] + y2)
     *         a[i]   = a[i] - aterm
     *         pi[i]  = 1/a[i]
     *
           After the iterations are done, pi = pi[5].
     *
     *     To ensure accuracy of all 500 decimal places, this program
     *     calculates with 505 digits.
     *
     ***************************************************************************
               ORG  87
     X1        DSA  0                  index register 1
               ORG  92
     X2        DSA  0                  index register 2
               ORG  97
     X3        DSA  0                  index register 3
     *
               ORG  333
     *
     * Print the header.
     *
     START     CS   332
               CS
               MCW  @***** Pi to 500 Decimal Places *****@,319
               W
     *
     * Compute sqrt(2).
     *
               ZA   LENN,SQLENN        SQLENN = LENN
               ZA   DP,SQDP            SQDP   = DP
     *
               SBR  SQADRN,TWO         SQADRN = @TWO
               SBR  SQADRX,SQRT2       SQADRX = @SQRT2
               SBR  SQADRP,TEMP1       SQADRP = @TEMP1
               SBR  SQADRT,TEMP2       SQADRT = @TEMP2
               B    SQRT
     *
     * Compute y[0] = sqrt(2) - 1
     *
               MCW  SQRT2,YI           sqrt(2)
               S    @1@,YI-505                 - 1
               MZ   @ @,YI-505
               SW   YI-504
     *
     * Compute a[0] = 6 - 4*sqrt(2)
     *
               S    AI
               MCW  @6@,AI-505        6
               S    SQRT2,AI            - sqrt(2)
               S    SQRT2,AI            - sqrt(2)
               S    SQRT2,AI            - sqrt(2)
               S    SQRT2,AI            - sqrt(2)
     *
     * Start of loop.  Increment the iteration counter.
     *
     LOOP      A    @1@,ITERS
     *
     * Compute y4 = y[i-1]**4
     *
               SW   Y2-505,Y4-506
               ZA   DP,P2LENF
               SBR  P2AFCT,YI
               SBR  P2APRD,Y2&505
               B    POWR2              y[i-1]**2
               SBR  P2AFCT,Y2
               SBR  P2APRD,Y4&504
               B    POWR2              (y[i-1]**2)**2
     *
     * Compute yrt4 = (1 - y4)**(1/4)
     *
               S    TEMP3+505
               MCW  @1@,TEMP3          1
               S    Y4,TEMP3&505         - y4
     *
               ZA   LENN,SQLENN        SQLENN = LENN
               ZA   DP,SQDP            SQDP   = DP
     *
               SBR  SQADRN,TEMP3       SQADRN = @TEMP3
               SBR  SQADRX,YRT4        SQADRX = @YRT4
               SBR  SQADRP,TEMP1       SQADRP = @TEMP1
               SBR  SQADRT,TEMP2       SQADRT = @TEMP2
               B    SQRT               sqrt(1 - y4)
     *
               MCW  YRT4,TEMP3&505
               SBR  SQADRN,TEMP3       SQADRN = @TEMP3
               SBR  SQADRX,YRT4        SQADRX = @YRT4
               SBR  SQADRP,TEMP1       SQADRP = @TEMP1
               SBR  SQADRT,TEMP2       SQADRT = @TEMP2
               B    SQRT               sqrt(sqrt(1 - y4))
     *
     * Compute y[i] = (1 - yrt4)/(1 + yrt4)
     *
               S    YI&507
               MCW  @1@,YI-503         1
               S    YRT4,YI&2            - yrt4 (dividend)
               MZ   @ @,YI&2
     *
               ZA   YRT4,Y2            yrt4
               A    @1@,Y2-505              + 1 (divisor)
               MZ   @ @,Y2-505
     *
               D    Y2,YI-503          (1 - yrt4)/(1 + yrt4)
     *
     * Compute yterm4 = (1 + y[i])**4
     *
               CW   Y2-505,Y2-506
               CW   Y4-506
               ZA   YI,TEMP1           y[i]
               A    @1@,TEMP1-505           + 1
               MZ   @ @,TEMP1-505
     *
               ZA   @506@,P2LENF
               SBR  P2AFCT,TEMP1
               SBR  P2APRD,Y2&505
               B    POWR2              (1 + y[i])**2
               SW   Y2-506
     *
               SBR  P2AFCT,Y2
               SBR  P2APRD,Y4&504
               B    POWR2              ((1 + y[i])**2)**2
               SW   Y4-506
     *
     * Compute a[i] = a[i-1]*yterm4
     *
               SW   TEMP2-506
               ZA   Y4,TEMP2           yterm4
               M    AI,TEMP2&507             *a[i-1]
               ZA   TEMP2&2,AI
               CW   TEMP2-506
     *
     * Compute power2 = 2**(2*i + 1)
     *
               A    POW2
               A    POW2               power2 = 2*power2
     *
     * Compute y2 = y[i]**2
     *
               SW   Y2-505
               ZA   DP,P2LENF
               SBR  P2AFCT,YI
               SBR  P2APRD,Y2&505
               B    POWR2              y[i]**2
     *
     * Compute aterm = pow2*y[i]*(1 + y[i] + y2)
     *
               SW   TEMP2-506
               S    TEMP2-1
               MCW  @1@,TEMP2-506      (1
               A    YI,TEMP2-1            + y[i]
               A    Y2,TEMP2-1                   + y2)
               M    YI,TEMP2&506                      *y[i])
               M    POW2,TEMP2&5                            *power2
               SW   TEMP2-500
     *
     * Compute a[i] = a[i] - aterm
     *
               S    TEMP2&5,AI         a[i] - aterm
               CW   TEMP2-500,TEMP2-506
     *
     * Compute pi[i] = 1/a[i]
     *
               S    PI&507
               MCW  @1@,PI-503         1
               D    AI,PI-503           /pi[i]
     *
     *
     * All done?
     *
               C    ITERS,ITRMAX
               BE   DONE               done if ITERS = ITRMAX
               B    LOOP               else loop again
     *
     * Print final pi
     *
     DONE      SBR  PRADDR,PI          PRADDR = @PI - dp
               ZA   DP,CNVOFF
               B    CNVRTN
               MA   CNVOFF,PRADDR
               ZA   DPPRT,PRDP         PRDP = dp to print
               B    PRINT
     *
     FINIS     H    FINIS
               H
     *
     LENN      DCW  1                  len(TWO)
     DP        DCW  505                actual number of decimal places (dp)
     DPPRT     DCW  500                number of decimal places to print
     ITERS     DCW  0                  iteration counter
     ITRMAX    DCW  5                  max iterations
     *
     TWO       DCW  2
               DC   #1010              len = 2*dp
     SQRT2     DCW  #506               len = len(TWO) + dp
               DC   #2                 remainder of /2: len = 2
     *
     AI        DCW  #506               len = dp + 1
               DC   #508               len = dp + 3
     YI        DCW  #506               len = dp + 1
               DC   #507               len = dp + 2
     Y2        DCW  #508               len = dp + 3
               DC   #505               len = dp
     Y4        DCW  #509               len = dp + 4
               DC   #504               len = dp - 1
     PI        DCW  #506               len = dp + 1
               DC   #507               len = dp + 2
     YRT4      DCW  #506               len = dp + 1
               DC   #2                 remainder of /2: len = 2
     POW2      DCW  0002
     *
     TEMP1     DCW  #506               len = dp + 1
     TEMP2     DCW  #1011              len = len(TWO) + 2*dp
               DC   #507               remainder of /TEMP1: len = len(TEMP1) + 1
     TEMP3     DCW  0
               DC   #1010              len = 2*dp
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
     *         (1) N must be followed in memory by 2*dp digits
     *             (could be zeros or blanks)
     *         (2) len(X) must be len(N) + dp, and it must be followed in
     *             memory by 2 zeroes or blanks
     *         (3) len(XPREV) must be len(X)
     *         (4) len(TEMP) must be len(N) + 2*dp, and it must be followed
     *             in memory by (len(X) + 1) digits (could be zeroes or blanks)
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
               MWC  SQADRX,SQA&3       @X
               MCW  SQADRP,SQMCW&6     @XPREV
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
     *     xprev = 0;
     *     x = n;
     *     while (x != xprev) {
     *         xprev = x;
     *         x = (x + n/x)/2;
     *     }
     *
               MCW  @0@,SQITER         SQITER = 0
     SQMCW     MCW  @0@,000            XPREV  = 0
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
     * Loop again.
     *
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
     *     Square subroutine
     *
     *     This subroutine the square of a factor (factor**2).
     *
     *     Entry point:  POWR2
     *
     *     Before calling, the caller must set:
     *
     *         P2AFCT = @factor
     *         P2APRD = @product
     *         P2LENF = length of factor
     *
     *     Upon return:
     *
     *         product = factor**2
     *
     ***************************************************************************
     POWR2     SBR  POWR2X&3
     *
               MCW  P2AFCT,P2MCW&3
               MCW  P2APRD,P2MCW&6
               ZA   P2LENF,CNVOFF
               A    @1@,CNVOFF
               B    CNVRTN
               MA   CNVOFF,P2MCW&6
     *
               MCW  P2AFCT,P2M&3
               MCW  P2APRD,P2M&6
     *
     P2MCW     MCW  000,000            set factor as multiplier
     P2M       M    000,000            product = factor X factor
     POWR2X    B    000                return
     *
     P2AFCT    DSA  000                @factor
     P2APRD    DAS  000                @product (factor X factor)
     P2LENF    DCW  0000               len(factor)
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
     *     decimal digits must be a multiple of 500.
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
               SBR  X1,10+X1           X1 = @ first group within X
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
