//
//  SetASCIITo1401Table.c
//  Stan Paddock
//

#include "SetTable.h"

int AsciiTo1401[127];

int setTable(void)
{
    int i;     // index
    
     // Set all fields to space
     for(i = 0; i < sizeof(AsciiTo1401); AsciiTo1401[i++] = 64);  // space
 
    // define key codes
    // PDFFile10 6/9/2016

    AsciiTo1401[32] = 64;       // (space)
    AsciiTo1401[33] = 42;       // !
    AsciiTo1401[34] = 127;      // "
    AsciiTo1401[35] = 11;       // #
    AsciiTo1401[36] = 107;      // $
    AsciiTo1401[37] = 28;       // %
    AsciiTo1401[38] = 112;      // &
    AsciiTo1401[39] = 26;       // '
    AsciiTo1401[40] = 79;       // (
    AsciiTo1401[41] = 124;      // )
    AsciiTo1401[42] = 44;       // *
    AsciiTo1401[43] = 31;       // +
    AsciiTo1401[44] = 91;       // ^
    AsciiTo1401[45] = 32;       // -
    AsciiTo1401[46] = 59;       // .
    AsciiTo1401[47] = 81;       // /
    AsciiTo1401[48] = 74;       // 0
    AsciiTo1401[49] = 1;        // 1
    AsciiTo1401[50] = 2;        // 2
    AsciiTo1401[51] = 67;       // 3
    AsciiTo1401[52] = 4;        // 4
    AsciiTo1401[53] = 69;       // 5
    AsciiTo1401[54] = 70;       // 6
    AsciiTo1401[55] = 7;        // 7
    AsciiTo1401[56] = 8;        // 8
    AsciiTo1401[57] = 73;       // 9
    AsciiTo1401[58] = 13;       // :
    AsciiTo1401[59] = 110;      // ;
    AsciiTo1401[60] = 62;       // <
    AsciiTo1401[61] = 93;       // = 
    AsciiTo1401[62] = 14;       // >
    AsciiTo1401[63] = 122;      // ?
    AsciiTo1401[64] = 76;       // @
    AsciiTo1401[65] = 49;       // A
    AsciiTo1401[66] = 50;       // B
    AsciiTo1401[67] = 115;      // C
    AsciiTo1401[68] = 52;       // D
    AsciiTo1401[69] = 117;      // E
    AsciiTo1401[70] = 118;      // F
    AsciiTo1401[71] = 55;       // G
    AsciiTo1401[72] = 56;       // H
    AsciiTo1401[73] = 121;      // I
    AsciiTo1401[74] = 97;       // J
    AsciiTo1401[75] = 98;       // K
    AsciiTo1401[76] = 35;       // L
    AsciiTo1401[77] = 100;      // M
    AsciiTo1401[78] = 37;       // N
    AsciiTo1401[79] = 38;       // O
    AsciiTo1401[80] = 103;      // P
    AsciiTo1401[81] = 104;      // Q
    AsciiTo1401[82] = 41;       // R
    AsciiTo1401[83] = 82;       // S
    AsciiTo1401[84] = 19;       // T
    AsciiTo1401[85] = 84;       // U
    AsciiTo1401[86] = 21;       // V
    AsciiTo1401[87] = 22;       // W
    AsciiTo1401[88] = 87;       // X
    AsciiTo1401[89] = 88;       // Y
    AsciiTo1401[90] = 25;       // Z
    AsciiTo1401[91] = 61;       // [
    AsciiTo1401[92] = 94;       // (back slash)
    AsciiTo1401[93] = 109;      // ]
    AsciiTo1401[94] = 16;       // ^
    AsciiTo1401[95] = 47;       // _
    AsciiTo1401[123] = 79;      // {

    /*************************
    for(i = 0; i < sizeof(AsciiTo1401); i++)
    {
        printf("AsciiTo1401[%3.3d] = 0x%4.4d\n", i, AsciiTo1401[i]);
    }
    **************************/
    
    return 0;
}

