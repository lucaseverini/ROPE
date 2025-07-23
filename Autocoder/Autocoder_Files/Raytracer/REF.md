
IBM 1401 Reference Sheet
========================

This is a quick-reference sheet for the IBM 1401.

Instructions
============

     Op   SPS  Aut  Function
     @    M    M    Multiply A into B. B's length is sum of operand lengths plus one.
                    B's operand is left-justified.
     0+   ZA   ZA   Moves A to B. A can be shorter. Sets sign bits on B.
     0-   ZS   ZS   Moves A to B and negates. A can be shorter. Sets sign bits on B.
     A    A    A    Adds A to B. A can be shorter. Sets sign bits on B.
     S    S    S    Substracts A from B. A can be shorter. Sets sign bits on B.
     B    B    BCE  Jump to A if character pointed to by B equals d.
     Z    MCS  MCS  Move numbers, suppress leading zeros, remove sign bits.
                    Even strips the last 0 if the entire field is zero.
     H    SBR  SBR  Stores B (explicitly or from previous op) to A. WM not affected.
     L    LCA  LCA  Copy A to B until word mark at A, copying word marks.

