#include <stdio.h>

main ( int argc, char* argv[] )
{ char c, d;    /* characters being copied */
  int first;    /* 1 = first character of a line, zero = not */

  setvbuf ( stdout, (char*)NULL, _IONBF, 1 );
  first = 1;
  while ( 1 )
  { c = getchar();
    while ( ( c == '\n' ) | ( c == '\r' ) )
    { d = getchar();
      if ( (c == '\r' & d == '\n') |
           (c == '\n' & d == '\r') ) d = getchar();
      c = d;
      first = 1;
    }
    if ( c == EOF ) break;
    if ( first )
    { if ( c == '0' ) { putchar ( '\n' ); putchar ( '\n' ); }
      else if ( c == '1' ) { putchar ( '\n' ); putchar ( '\f' ); }
      else if ( c == '+' ) putchar ( '\r' );
      else putchar ( '\n' );
      first = 0;
    }
    else putchar(c);
  }
  putchar ( '\n' );
}
