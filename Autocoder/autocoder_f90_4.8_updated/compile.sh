#!/bin/sh

rm /Users/Luca/Emulation/IBM1401/ROPE1401/ROPE1401v07/Autocoder_Files/lincoln.cd 2>/dev/null 1>&2
rm /Users/Luca/Emulation/IBM1401/ROPE1401/ROPE1401v07/Autocoder_Files/lincoln.lst 2>/dev/null 1>&2
rm /Users/Luca/Emulation/IBM1401/ROPE1401/ROPE1401v07/Autocoder_Files/lincoln.out 2>/dev/null 1>&2

./autocoder -b Ix -e S -l /Users/Luca/Emulation/IBM1401/ROPE1401/ROPE1401v07/Autocoder_Files/lincoln.lst -o /Users/Luca/Emulation/IBM1401/ROPE1401/ROPE1401v07/Autocoder_Files/lincoln.cd -a /Users/Luca/Emulation/IBM1401/ROPE1401/ROPE1401v07/Autocoder_Files/lincoln.s
