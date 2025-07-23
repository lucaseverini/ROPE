/* Read a "tape" in the format written by Van Snyder's autocoder, and
   write it in the format Supnik's simh 1401 simulator
   (simh.trailing-edge.com) expects.

   In Snyder's format, records are ASCII.  Each record begins with a
   three-digit total-record length, which includes word marks, followed
   by a three-digit data-only length, which would be the length if a
   word mark were represented by a bit in each character, followed by the
   data.  Word marks are represented by =, and apply to the next
   character, as on 1401 tapes.  The mapping from ASCII to BCD is given
   by the array ascii_to_bcd.

   simh wants records on "tapes" to be represented by a 32-bit little-
   endian count before and after the record.  The characters are
   represented in the low-order six bits of each byte, in BCD, with no
   parity.  A word mark is represented by a word mark character before
   the data character, just like on 1401 tapes.  The number of
   characters in each record has to be even, even if the count is odd. 
   simh ignores the extra character.
*/

#include <stdio.h>

main ( argc, argv )
  int argc;
  char **argv;
{ 
  char line[168];
  unsigned int i, n1, n2;
  unsigned char k;
  FILE *fi, *fo;

/* ASCII to BCD conversion -- From simh's i1401_dat.h */

const char ascii_to_bcd[128] = {
  000, 000, 000, 000, 000, 000, 000, 000,         /* 000 - 037 */
  000, 000, 000, 000, 000, 000, 000, 000,
  000, 000, 000, 000, 000, 000, 000, 000,
  000, 000, 000, 000, 000, 000, 000, 000,
  000, 052, 077, 013, 053, 034, 060, 032,         /* 040 - 077 */
  017, 074, 054, 037, 033, 040, 073, 021,
  012, 001, 002, 003, 004, 005, 006, 007,
  010, 011, 015, 056, 076, 035, 016, 072,
  014, 061, 062, 063, 064, 065, 066, 067,         /* 100 - 137 */
  070, 071, 041, 042, 043, 044, 045, 046,
  047, 050, 051, 022, 023, 024, 025, 026,
  027, 030, 031, 075, 036, 055, 020, 057,
  000, 061, 062, 063, 064, 065, 066, 067,         /* 140 - 177 */
  070, 071, 041, 042, 043, 044, 045, 046,
  047, 050, 051, 022, 023, 024, 025, 026,
  027, 030, 031, 000, 000, 000, 000, 000 };

  if ( argc != 3 ) /* arg 0 is command name */
  { printf ( "The number of command-line arguments must be exactly 2.\n" );
    printf ( "The first is the input file, the second is the output file.\n" );
    exit ( 1 );
  }

  if ( ( fi = fopen ( argv[1], "r" ) ) == NULL )
  { perror ( argv[1] );
    exit ( 2 );
  }

  if ( ( fo = fopen ( argv[2], "wb" ) ) == NULL )
  { perror ( argv[2] );
    exit ( 3 );
  }

  while ( fgets ( line, 168, fi ) != NULL )
  { sscanf ( line, "%3d%3d", &n1, &n2 );
    n2 = n1;
    for ( i=0; i<4; i++ ) /* Output the count, little-endian */
    { k = n2 % 256; n2 = n2 / 256;
      fputc ( k, fo );
    }
    for ( i=0; i<n1; i++ ) fputc ( ascii_to_bcd[line[i+6]], fo );
    if ( n1 % 2 ) fputc ( (char)0, fo ); /* simh want's even-length records */
    n2 = n1;
    for ( i=0; i<4; i++ ) /* Output the count, little-endian */
    { k = n2 % 256; n2 = n2 / 256;
      fputc ( k, fo );
    }
  }

  k = 0;
  for ( i=0; i<4; i++ ) fputc ( k, fo ); /* Output simh's EOF */

  fclose ( fi );
  fclose ( fo );
}
