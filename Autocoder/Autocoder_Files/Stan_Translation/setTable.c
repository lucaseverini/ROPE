//
//  SetTable.c
//  Stan Paddock
//

#include "RmtPunch.h"
#include <stdio.h>

int setTable()
{
     int i;     // index
     extern unsigned short KeyCode[256];
     
     // Set all fields to INVALID
     for(i = 0; i < 256; KeyCode[i++] = INVALID);
     
    // define key codes
    // PDFFIL10 6-9-2016 
     
    KeyCode[10] = P14;              // LF
    KeyCode[32] = P13;              // (space)
    KeyCode[33] = P11 + P0;         // !
    KeyCode[34] = P12 + P7 + P8;    // "
    KeyCode[35] = P3 + P8;          // #
    KeyCode[36] = P11 + P3 + P8;    // $
    KeyCode[37] = P0 + P4 + P8;     // %
    KeyCode[38] = P12;              // &
    KeyCode[39] = P0 + P2 + P8;     // '
    KeyCode[40] = P7 + P8;          // (
    KeyCode[41] = P12 + P4 + P8;    // )
    KeyCode[42] = P11 + P4 + P8;    // *
    KeyCode[43] = P0 + P7 + P8;     // + 
    KeyCode[44] = P0 + P3 + P8;     // ^
    KeyCode[45] = P11;              // -
    KeyCode[46] = P12 + P3 + P8;    // .
    KeyCode[47] = P0 + P1;          // /
    KeyCode[48] = P0;               // 0
    KeyCode[49] = P1;               // 1
    KeyCode[50] = P2;               // 2
    KeyCode[51] = P3;               // 3
    KeyCode[52] = P4;               // 4
    KeyCode[53] = P5;               // 5
    KeyCode[54] = P6;               // 6
    KeyCode[55] = P7;               // 7
    KeyCode[56] = P8;               // 8
    KeyCode[57] = P9;               // 9
    KeyCode[58] = P5 + P8;          // :
    KeyCode[59] = P11 + P6 + P8;    // ;
    KeyCode[60] = P12 + P8 + P6;    // <
    KeyCode[61] = P0 + P5 + P8;     // =
    KeyCode[62] = P6 + P8;          // >
    KeyCode[63] = P12 + P0;         // ?
    KeyCode[64] = P4 + P8;          // @
    KeyCode[65] = P12 + P1;         // A
    KeyCode[66] = P12 + P2;         // B
    KeyCode[67] = P12 + P3;         // C
    KeyCode[68] = P12 + P4;         // D
    KeyCode[69] = P12 + P5;         // E
    KeyCode[70] = P12 + P6;         // F
    KeyCode[71] = P12 + P7;         // G
    KeyCode[72] = P12 + P8;         // H
    KeyCode[73] = P12 + P9;         // I
    KeyCode[74] = P11 + P1;         // J
    KeyCode[75] = P11 + P2;         // K
    KeyCode[76] = P11 + P3;         // L
    KeyCode[77] = P11 + P4;         // M
    KeyCode[78] = P11 + P5;         // N
    KeyCode[79] = P11 + P6;         // O
    KeyCode[80] = P11 + P7;         // P
    KeyCode[81] = P11 + P8;         // Q
    KeyCode[82] = P11 + P9;         // R
    KeyCode[83] = P0 + P2;          // S
    KeyCode[84] = P0 + P3;          // T
    KeyCode[85] = P0 + P4;          // U
    KeyCode[86] = P0 + P5;          // V
    KeyCode[87] = P0 + P6;          // W
    KeyCode[88] = P0 + P7;          // X
    KeyCode[89] = P0 + P8;          // Y
    KeyCode[90] = P0 + P9;          // Z
    KeyCode[91] = P12 + P5 + P8;    // [
    KeyCode[92] = P0 + P6 + P8;     // back slash
    KeyCode[93] = P11 + P5 + P8;    // ]
    KeyCode[94] = INVALID;          // ^
    KeyCode[95] = P11 + P7 + P8;    // _
    KeyCode[123] = 7 + 8;           // {

    // *************************    
    for(i = 0; i < 256; i++)
    {
        printf("table[%3.3d] = 0x%4.4x;   //%c/n", i, KeyCode[i], i);     
    }
    // **************************
     
     return 0;
 }
 
 