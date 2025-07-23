               ORG  87
     X1        DCW  000                 
     *
               ORG  333
     *
     START     NOP
               C    FOUR,EIGHT
     *         BL   END2
               BH   END2
     
     STOP      H    STOP
     
               DCW  @:@
     FOUR      DCW  @&@
               DCW  @0D   @
               DCW  @:@
     EIGHT     DCW  @A@
               DCW  @AHI  @
               DCW  @:@
     ONE       DCW  1
     ZERO      DCW  @000@
     
     END2      H
     
               END  START
