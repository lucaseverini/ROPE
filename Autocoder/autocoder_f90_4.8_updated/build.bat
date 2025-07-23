REM Windows batch file to build Autocoder
REM By Luca Severini (lucaseverini@mac.com)
REM Last change: Apr-17-2014

REM pre-cleanup
DEL /Q *.o 2> nul
DEL /Q *.mod 2> nul
DEL /Q *.exe 2> nul
DEL /Q *.obj 2> nul

REM Compilation of autocoderr modules
g95.exe -c -static machine_non_lf95.f90
g95.exe -c -static bcd_to_ascii_m.f90
g95.exe -c -static input_m.f90 
g95.exe -c -static io_units.f90 
g95.exe -c -static flags.f90
g95.exe -c -static symtab_m.f90
g95.exe -c -static operand_m.f90
g95.exe -c -static Bootstrap_m.f90
g95.exe -c -static error_m.f90
g95.exe -c -static literals_m.f90
g95.exe -c -static zone_m.f90 
g95.exe -c -static op_codes_m.f90
g95.exe -c -static lexer.f90
g95.exe -c -static Object_m.f90
g95.exe -c -static parser.f90
g95.exe -c -static macro_pass_m.f90
g95.exe -c -static pass_3_m.f90
g95.exe -c -static pass_2_m.f90
g95.exe -c -static pass_1_m.f90

REM Final compile and link of autocoder
g95.exe -o autocoder autocoder.f90 bcd_to_ascii_m.o Bootstrap_m.o error_m.o flags.o input_m.o io_units.o lexer.o literals_m.o machine_non_lf95.o macro_pass_m.o op_codes_m.o Object_m.o operand_m.o parser.o pass_1_m.o pass_2_m.o pass_3_m.o symtab_m.o zone_m.o

REM Compile and link of link
g95.exe -o link Link.f90 bcd_to_ascii_m.o Bootstrap_m.o io_units.o machine_non_lf95.o Object_m.o symtab_m.o zone_m.o

REM Compile and link of to_e11
g95.exe -o to_e11 to_e11.f90 bcd_to_ascii_m.o machine_non_lf95.o

REM Compile and link of to_simh_d
g95.exe -o to_simh_d to_simh_direct.f90 bcd_to_ascii_m.o machine_non_lf95.o

REM Compile and link of to_simh_f
g95.exe -o to_simh_f to_simh.f90 bcd_to_ascii_m.o machine_non_lf95.o

REM Compile and link of tapedump
g95.exe -o tapedump tapedump.f90 bcd_to_ascii_m.o

REM Set VS10 C compiler variables
call "%VS100COMNTOOLS%vsvars32.bat"

REM Compile and link of to_simh
cl to_simh.c -Foto_simh

REM Compile and link of tpdump
cl tpdump.c -fotpdump

REM post-cleanup
DEL /Q *.o 2> nul
DEL /Q *.mod 2> nul
DEL /Q *.obj 2> nul

echo "Build of autocoder completed."
