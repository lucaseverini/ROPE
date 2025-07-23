     * Test Program to be used with some data file attached
     * in Runtime data dialog
     * 
               JOB  FIRST PROGRAM
               CTL  6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD     
     *
               ORG  350
     *
     START     H
               sw   001
     read      r  
               mcw  080,280
               w
               b    exit,a
               b    read
     exit      h    start
               nop
               NOP
               END  START
