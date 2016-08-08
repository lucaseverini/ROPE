               job  compute Mersenne prime 23 = 2**11213 - 1               MERSN
               ctl  6611
     *
     * Compute the 23rd Mersenne prime = 2**11213 - 1. We start
     * with the 6 that's the low-order digit of 2**4 in the
     * number.  The OVFL loop adds a high-order 1 to make 16. 
     * Then it proceeds by doubling from then, with the overflow
     * loop moving over the high-order digit word mark, and
     * putting in a 1.  We don't need to clear the overflow zone,
     * because the next doubling will do it.
     *
               org  081
     what      dcw  @0001: @    Starting digit number print field
     *
     * X1 is used to keep track of the current high-order digit
     * (actually one character before it).  At the end, it's one
     * before the high-order digit for the whole number.  Then,
     * it's used to print the result, being incremented by 100 for
     * each line.
     *
     x1        dsa  number-1    Initial content of X1, at 87-89
     *
     * Compute the 23rd Mersenne prime.  This code runs through X2
     * and X3, and into the punch area, but we're not using X2 or
     * X3, or punching, so we might as well use it.
     *
     start     w                Print the title preloaded at 201-...
     ovfl      cw   1&x1        Clear WM to make more room
               lca  one         Do the overflow, set the WM
               sbr  x1          High-order digit index - 1
     inner     bwz  done,ndoubl,k  Done if negative
               s    one,ndoubl  
               a    number      Double it
               bav  ovfl        Overflow?
               b    inner       No
     done      s    one,number  Puts a zone on low-order digit
               mz   one,number  Clear zone on low-order digit
     *
     * Print it
     *
               sw   207
               lca  what
     ploop     sbr  x1,100&x1   Bump printing index by 100
               mcs  what-2,204  Index of first digit
               a    one,what-4  Add 100 to digit number to print
               mcw  0&x1,306    Next hundred digits
               w                Print them
               bce  finis,306,  Done if blank in print area
               b    ploop       Print 100 more digits
     finis     h    finis       Halt loop (as good here as anywhere)
     one       dcw  1
     *
               org  201         Pre-load title into print area
               dcw  @23rd mersenne prime = 2**11213 - 1@
     *
     * Here's the number
     *
               org  333
               da   1x3375
     numhi          1,1         High-order digit
     number    dcw  6           Low-order digit
               dc   #24         Blanks for printing the last line
     *
     ndoubl    dcw  11208       Exponent - 4 - 1
               end  start
