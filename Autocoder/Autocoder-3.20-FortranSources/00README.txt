Files in this archive:

00README              This file

Makefile              Duh

autocoder.f90         Autocoder assembler
bcd_to_ascii_m.f90
error_m.f90
input_m.f90
io_units.f90
lexer.f90
literals_m.f90
machine.f90
op_codes_m.f90
operand_m.f90
parser.f90
pass_1_m.f90
pass_2_m.f90
pass_3_m.f90
symtab_m.f90
traces_m.f90
zone_m.f90

tapedump.f90          A filter that dumps the "object tape" from the -t
                      option with word marks.  See the Write_Tape
                      subroutine in pass_3_m.f90.

to_simh.f90           Convert the "object tape" to run in simh; uses
                      direct-access output to fake stream output.  This
                      works on many systems.  The Makefile doesn't make
                      this one.

to_simh.c             Convert the "object tape" to run in simh; uses
                      C stream I/O; should work on essentially all systems.

to_e11.f90            Convert the "object tape" to run in simh; uses
                      unformatted Fortran output, which is coincidentally
                      exactly what simh wants on many little-endian systems.
                      This doesn't pad odd-length records, so use
                        set mt1 FORMAT=E11
                      before booting.
