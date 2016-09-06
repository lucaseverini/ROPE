ROPE
====

ROPE is an Integrated Development and Simulation Environment (IDSE) for the IBM 1401, the historical mainframe presented by IBM in 1959. (http://ibm-1401.info/index.html).<br>
ROPE is the acronym of Ron's Own Programming Environment.<br>
Ron Mak, NASA scientist, CS professor at SJSU and volunteer at the Computer History Museum (http://www.cs.sjsu.edu/~mak/), wrote the first version of ROPE in 2005.<br>
Luca Severini, Mak's student, took his place in the development and maintenance in 2013.
ROPE is made of three main parts. The front-end developed in java whose source is in this repository, the Autocoder assembler developed in Fortran by W Van Snyder (https://science.jpl.nasa.gov/people/Snyder), and the SimH simulator (http://simh.trailing-edge.com).
Every comment, bug reporting or fixing is welcome.<br>
Thank you!

Installing
-

    $ git clone http://github.com/lucaseverini/ROPE.git
	$ cd ROPE
	$ unzip dist.zip
	$ cd dist


Running
-

	$ java -jar "rope1401.jar"

ROPE should open after running the command above.

Once ROPE opens, do the following:
- In the window titled "EDIT", click the "Browse ..." button
- Browse to the "examples" folder in this repository
- Select the "lincoln.s" file
- Click the "Choose" button
- Click the "Assemble File" button

Two new windows will open inside of ROPE
- In the window titled "EXEC" click the "Start program" button
- Open the "PRINTOUT" window to see the output

Learn more
-

The manuals availble here are invaluable in programming the IBM 1401: http://ibm-1401.info/1401SoftwDevel.html#Reference


