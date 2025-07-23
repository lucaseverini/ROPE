#!/bin/sh
# MacOS/Unix/linux/ shell script file to build Autocoder
# By Luca Severini (lucaseverini@mac.com)
# Last change: Apr-9-2022

# pre-cleanup
rm *.o 2>/dev/null 1>&2
rm *.mod 2>/dev/null 1>&2
rm autocoder link to_simh to_simh_d to_simh_f to_e11 tpdump tapedump 2>/dev/null 1>&2

echo "Pre-cleanup executed."

# Compilation of autocoder modules
gfortran -c -static machine_non_lf95.f90
gfortran -c -static bcd_to_ascii_m.f90
gfortran -c -static input_m.f90 
gfortran -c -static io_units.f90 
gfortran -c -static flags.f90
gfortran -c -static symtab_m.f90
gfortran -c -static operand_m.f90
gfortran -c -static Bootstrap_m.f90
gfortran -c -static error_m.f90
gfortran -c -static literals_m.f90
gfortran -c -static zone_m.f90
gfortran -c -static op_codes_m.f90
gfortran -c -static lexer.f90
gfortran -c -static Object_m.f90
gfortran -c -static literals_m.f90
gfortran -c -static parser.f90
gfortran -c -static macro_pass_m.f90
gfortran -c -static pass_3_m.f90
gfortran -c -static pass_2_m.f90
gfortran -c -static pass_1_m.f90

echo "Autocoder modules compiled."

# Final compile and link of autocoder
gfortran -Xlinker -macosx_version_min -Xlinker 10.8 -o autocoder autocoder.f90 bcd_to_ascii_m.o Bootstrap_m.o error_m.o flags.o input_m.o io_units.o lexer.o literals_m.o machine_non_lf95.o macro_pass_m.o op_codes_m.o Object_m.o operand_m.o parser.o pass_1_m.o pass_2_m.o pass_3_m.o symtab_m.o zone_m.o

echo "Final compile and link of autocoder executed."

# Compile and link of link
gfortran -Xlinker -macosx_version_min -Xlinker 10.8 -o link Link.f90 bcd_to_ascii_m.o Bootstrap_m.o io_units.o machine_non_lf95.o Object_m.o symtab_m.o zone_m.o

echo "Compile and link of link executed."

# Compile and link of to_e11
gfortran -Xlinker -macosx_version_min -Xlinker 10.8 -o to_e11 to_e11.f90 bcd_to_ascii_m.o machine_non_lf95.o

echo "Compile and link of to_e11 executed."

# Compile and link of to_simh_d
gfortran -Xlinker -macosx_version_min -Xlinker 10.8 -o to_simh_d to_simh_direct.f90 bcd_to_ascii_m.o machine_non_lf95.o

echo "Compile and link of to_simh_d executed."

# Compile and link of to_simh_f
gfortran -Xlinker -macosx_version_min -Xlinker 10.8 -o to_simh_f to_simh.f90 bcd_to_ascii_m.o machine_non_lf95.o

echo "Compile and link of to_simh_f executed."

# Compile and link of tapedump
gfortran -Xlinker -macosx_version_min -Xlinker 10.8 -o tapedump tapedump.f90 bcd_to_ascii_m.o

echo "Compile and link of tapedump executed."

# Compile and link of to_simh
cc to_simh.c -o to_simh

echo "Compile and link of to_simh executed."

# Compile and link of tpdump
cc tpdump.c -o tpdump

echo "Compile and link of tpdump executed."

# post-cleanup
rm *.o 2>/dev/null 1>&2
rm *.mod 2>/dev/null 1>&2

echo "Post-cleanup executed."

echo "Build of autocoder completed."
