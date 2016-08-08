               JOB  Lincoln's Birthday Program
               CTL  3311
     ******************************************************************
     *  Lincoln's Birthday Program
     *      by Ronald Mak
     *
     *  Original version: February 1969
     *  Resurrected:      February 2005
     ******************************************************************
               ORG  87
     X1        DSA  0                  index register 1
               ORG  92
     X2        DSA  0                  index register 2
               ORG  97
     X3        DSA  0                  index register 3
     *
               ORG  333
     *
     * Lincoln's Gettysburg Address
     *
     GETTYS    DCW  0
               DCW  @Four score and seven years ago@
               DCW  @our fathers brought forth@
               DCW  @on this continent a new nation,@
               DCW  @conceived in liberty and@
               DCW  @dedicated to the proposition@
               DCW  @that all men are created equal.@
               DCW  @Now we are engaged in a great@
               DCW  @civil war, testing whether that@
               DCW  @nation or any nation so@
               DCW  @conceived and so dedicated@
               DCW  @can long endure. We are met on@
               DCW  @a great battlefield of that war.@
               DCW  @We have come to dedicate a@
               DCW  @portion of that field as a final@
               DCW  @resting place for those who here@
               DCW  @gave their lives that that nation@
               DCW  @might live. It is altogether@
               DCW  @fitting and proper that we should@
               DCW  @do this. But in a larger sense,@
               DCW  @we cannot hallow this ground.@
               DCW  @The brave men, living and@
               DCW  @dead who struggled here have@
               DCW  @consecrated it far above our poor@
               DCW  @power to add or detract. The world@
               DCW  @will little note nor long remember@
               DCW  @what we say here, but it can never@
               DCW  @forget what they did here. It is@
               DCW  @for us the living rather to be@
               DCW  @dedicated here to the unfinished@
               DCW  @work which they who fought here@
               DCW  @have thus far so nobly advanced.@
               DCW  @It is rather for us to be here@
               DCW  @dedicated to the great task@
               DCW  @remaining before us, that from@
               DCW  @these honored dead we take@
               DCW  @increased devotion to that cause@
               DCW  @for which they gave the last full@
               DCW  @measure of devotion, that we here@
               DCW  @highly resolve that these dead@
               DCW  @shall not have died in vain,@
               DCW  @that this nation under God shall@
               DCW  @have a new birth of freedom, and@
               DCW  @that government of the people,@
               DCW  @by the people, for the people@
               DCW  @shall not perish from this earth.@
     *
     * Program start.  Set index register X1 to point to the
     * first print map value, and index register X2 to point
     * to the first character of the Gettysburg Address.
     * Index register X3 will later point into the print area.
     *
     START     SBR  X1,MAP              point X1 to print map
               SBR  X2,GETTYS&1         point X2 to Gettysburg address
     *
     * Loop once per print map value.  First check if it's the
     * end of the print map.  If the map value is negative, then
     * print out the current line and start a new one.
     *
     LOOP      MCW  0&X1,MAPVAL         MAPVAL = curent map value
               SBR  X1,2&X1             point X1 to the next value
               C    @00@,MAPVAL         if MAPVAL = 0
               BE   DONE                    then DONE
     *
               BWZ  TEST,MAPVAL,2       if MAPVAL < 0, then
               MZ   @ @,MAPVAL              MAPVAL = abs(MAPVAL)
               W                            print out current line
               CS   299                     clear the print area
               SBR  X3,200                  point X3 to print area
     *
     * Each line alternates between 'skip' and 'take'.
     *
     TEST      BCE  DOSKIP,NEXTDO,0     if 'skip' then do skip
     *
     * Do 'take': Take MAPVAL number of letters from the Gettysburg
     *            Address and append them to the current print line.
     *
     DOTAKE    BCE  NEXTCH,0&X2,        don't take any blanks
               BCE  NEXTCH,0&X2,,       nor commas
               BCE  NEXTCH,0&X2,.       nor periods
     *
               MN   0&X2,0&X3           append letter to print line
               MZ   0&X2,0&X3
               S    @1@,MAPVAL          MAPVAL = MAPVAL - 1
               SBR  X3,1&X3             point X3 to next print position
     *
     NEXTCH    SBR  X2,1&X2             point X2 to next Gettysburg char
               C    &00,MAPVAL          if MAPVAL > 0
               BH   DOTAKE                  then take some more chars
               MCW  SKIP,NEXTDO             else next do 'skip'
               B    LOOP
     *
     * Do 'skip': Skip MAPVAL number of blanks in the print line.
     *
     DOSKIP    A    MAPVAL,X3           X3 = X3 + MAPVAL
               MCW  TAKE,NEXTDO         next do 'take'
               B    LOOP
     *
     * Done with all print map values.  Print the final line and quit.
     *
     DONE      W
     FINIS     H    FINIS
               H
     *
     SKIP      DCW  0                   'skip' code
     TAKE      DCW  1                   'take' code
     NEXTDO    DCW  0                   what to do next in the line
     MAPVAL    DCW  00                  print map value
     *
     * The print map.  A negative number denotes the start of a new
     * line, and its absolute value becomes the initial 'skip' value.
     * Each line's map values alternate between 'skip' and 'take'
     * values.  The final zero denotes the end of the print map.
     * Map values must each be two digits in length.
     *
     MAP       DCW  -43
               DCW  17
               DCW  -34
               DCW  28
               DCW  -31
               DCW  33
               DCW  -29
               DCW  37
               DCW  -28
               DCW  39
               DCW  -27
               DCW  12
               DCW  06
               DCW  23
               DCW  -26
               DCW  10
               DCW  10
               DCW  23
               DCW  -26
               DCW  08
               DCW  17
               DCW  18
               DCW  -26
               DCW  07
               DCW  21
               DCW  16
               DCW  -25
               DCW  09
               DCW  20
               DCW  10
               DCW  01
               DCW  06
               DCW  -25
               DCW  09
               DCW  21
               DCW  10
               DCW  01
               DCW  05
               DCW  -24
               DCW  10
               DCW  26
               DCW  03
               DCW  04
               DCW  05
               DCW  -22
               DCW  13
               DCW  33
               DCW  04
               DCW  -21
               DCW  04
               DCW  02
               DCW  08
               DCW  08
               DCW  04
               DCW  22
               DCW  03
               DCW  -20
               DCW  03
               DCW  05
               DCW  06
               DCW  05
               DCW  10
               DCW  20
               DCW  04
               DCW  -17
               DCW  04
               DCW  08
               DCW  05
               DCW  04
               DCW  05
               DCW  06
               DCW  01
               DCW  07
               DCW  09
               DCW  03
               DCW  04
               DCW  -17
               DCW  03
               DCW  08
               DCW  05
               DCW  04
               DCW  04
               DCW  14
               DCW  05
               DCW  02
               DCW  05
               DCW  02
               DCW  05
               DCW  -18
               DCW  03
               DCW  07
               DCW  04
               DCW  09
               DCW  02
               DCW  01
               DCW  04
               DCW  01
               DCW  01
               DCW  05
               DCW  01
               DCW  05
               DCW  04
               DCW  03
               DCW  07
               DCW  -18
               DCW  03
               DCW  07
               DCW  03
               DCW  09
               DCW  01
               DCW  02
               DCW  05
               DCW  01
               DCW  01
               DCW  06
               DCW  03
               DCW  03
               DCW  03
               DCW  01
               DCW  09
               DCW  -18
               DCW  03
               DCW  07
               DCW  02
               DCW  11
               DCW  01
               DCW  02
               DCW  02
               DCW  02
               DCW  01
               DCW  08
               DCW  01
               DCW  01
               DCW  02
               DCW  02
               DCW  02
               DCW  02
               DCW  07
               DCW  -18
               DCW  03
               DCW  08
               DCW  02
               DCW  26
               DCW  01
               DCW  09
               DCW  06
               DCW  -19
               DCW  03
               DCW  07
               DCW  03
               DCW  25
               DCW  01
               DCW  10
               DCW  01
               DCW  -19
               DCW  04
               DCW  06
               DCW  03
               DCW  26
               DCW  01
               DCW  09
               DCW  01
               DCW  -20
               DCW  12
               DCW  25
               DCW  01
               DCW  10
               DCW  01
               DCW  -21
               DCW  11
               DCW  17
               DCW  03
               DCW  06
               DCW  01
               DCW  09
               DCW  01
               DCW  -22
               DCW  10
               DCW  15
               DCW  02
               DCW  08
               DCW  01
               DCW  09
               DCW  01
               DCW  -25
               DCW  07
               DCW  07
               DCW  01
               DCW  04
               DCW  02
               DCW  02
               DCW  01
               DCW  08
               DCW  02
               DCW  07
               DCW  01
               DCW  -26
               DCW  07
               DCW  06
               DCW  04
               DCW  05
               DCW  09
               DCW  02
               DCW  01
               DCW  05
               DCW  01
               DCW  -26
               DCW  08
               DCW  05
               DCW  01
               DCW  12
               DCW  01
               DCW  06
               DCW  01
               DCW  04
               DCW  01
               DCW  -26
               DCW  08
               DCW  05
               DCW  01
               DCW  06
               DCW  01
               DCW  02
               DCW  01
               DCW  02
               DCW  02
               DCW  07
               DCW  01
               DCW  01
               DCW  01
               DCW  -27
               DCW  07
               DCW  05
               DCW  01
               DCW  03
               DCW  17
               DCW  02
               DCW  01
               DCW  -27
               DCW  05
               DCW  15
               DCW  11
               DCW  04
               DCW  01
               DCW  -27
               DCW  08
               DCW  26
               DCW  02
               DCW  -28
               DCW  15
               DCW  17
               DCW  04
               DCW  -28
               DCW  37
               DCW  -28
               DCW  36
               DCW  -28
               DCW  36
               DCW  -27
               DCW  01
               DCW  01
               DCW  34
               DCW  -26
               DCW  01
               DCW  03
               DCW  33
               DCW  -25
               DCW  01
               DCW  06
               DCW  30
               DCW  -25
               DCW  01
               DCW  08
               DCW  27
               DCW  -24
               DCW  01
               DCW  11
               DCW  21
               DCW  04
               DCW  01
               DCW  -21
               DCW  04
               DCW  14
               DCW  16
               DCW  07
               DCW  01
               DCW  -12
               DCW  06
               DCW  26
               DCW  07
               DCW  12
               DCW  01
               DCW  -10
               DCW  05
               DCW  49
               DCW  01
               DCW  -06
               DCW  04
               DCW  55
               DCW  01
               DCW  -03
               DCW  03
               DCW  60
               DCW  01
               DCW  -40
               DCW  01
               DCW  14
               DCW  01
               DCW  -36
               DCW  10
               DCW  04
               DCW  10
               DCW  -34
               DCW  28
               DCW  -36
               DCW  10
               DCW  05
               DCW  09
               DCW  -40
               DCW  01
               DCW  14
               DCW  01
               DCW  00
     *
               END  START
