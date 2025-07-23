HelloWorld1.s 1 is a simple Autocoder program bounded by generic
support code.

HelloWorld2.s is the most simple code to code this program.

HelloWorld3.s is the program using two macros;
       HEAD.mac for the beginning of the program. 
	 It defines the terms READ, PUNCH and PRINT for the buffers for each.
       It also defines the three index registers X1, X2, X3.
       
       EXIT.mac for the end of the program.
       It clears all of the I/O buffers.
       Halts with 999 in both the A and B registers.
       Check to see if the program was loaded from a PC by a loader in high memory.
       If so, returns to that loader.
       If not, it reads cards from the card reader until it finds a , in column 1.
       It assumes that is a new program and branches to 001.


To do your own thing, copy the HelloWorld director to the directory for your code.
Rename the directory to the name of your new program FooBar.
Within that directory, rename HelloWorld3.s to FooBar.s
Modify FooBar.s as required to do your work.

====================================================================================