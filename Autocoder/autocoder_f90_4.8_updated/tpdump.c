/* Dump tapes in the format of the simh 1401 simulator.
   See "usage" function below.
*/

#include <stdio.h>

/* From i1401_dat.h: */

char bcd_to_ascii_old[64] = {
    ' ',   '1',   '2',   '3',   '4',   '5',   '6',   '7',
    '8',   '9',   '0',   '#',   '@',   ':',   '>',   '(',
    '^',   '/',   'S',   'T',   'U',   'V',   'W',   'X',
    'Y',   'Z',   '\'',  ',',   '%',   '=',   '\\',  '+',
    '-',   'J',   'K',   'L',   'M',   'N',   'O',   'P',
    'Q',   'R',   '!',   '$',   '*',   ']',   ';',   '_',
    '&',   'A',   'B',   'C',   'D',   'E',   'F',   'G',
    'H',   'I',   '?',   '.',   ')',   '[',   '<',   '"'
    };

char bcd_to_ascii_a[64] = {
    ' ',   '1',   '2',   '3',   '4',   '5',   '6',   '7',  
    '8',   '9',   '0',   '#',   '@',   ':',   '>',   '{',  
    '^',   '/',   'S',   'T',   'U',   'V',   'W',   'X',  
    'Y',   'Z',   '|',   ',',   '%',   '~',   '\\',  '"',  
    '-',   'J',   'K',   'L',   'M',   'N',   'O',   'P',  
    'Q',   'R',   '!',   '$',   '*',   ']',   ';',   '_',  
    '&',   'A',   'B',   'C',   'D',   'E',   'F',   'G',  
    'H',   'I',   '?',   '.',   ')',   '[',   '<',   '}'
    };

char bcd_to_ascii_h[64] = {
    ' ',   '1',   '2',   '3',   '4',   '5',   '6',   '7',  
    '8',   '9',   '0',   '=',   '\'',  ':',   '>',   '{',  
    '^',   '/',   'S',   'T',   'U',   'V',   'W',   'X',  
    'Y',   'Z',   '|',   ',',   '(',   '~',   '\\',  '"',  
    '-',   'J',   'K',   'L',   'M',   'N',   'O',   'P',  
    'Q',   'R',   '!',   '$',   '*',   ']',   ';',   '_',  
    '+',   'A',   'B',   'C',   'D',   'E',   'F',   'G',  
    'H',   'I',   '?',   '.',   ')',   '[',   '<',   '}'
    };

/* Interesting BCD characters, from i1401_defs.h */

#define BCD_BLANK       000
#define BCD_WM          035

size_t read_len ( FILE* fi )
/* Read a little-endian four-byte number */
{ unsigned char c;      /* A Character from the file */
  size_t i;
  size_t lc;            /* The character, as a long int */
  size_t n;             /* the number */
  if ( fread ( &c, 1, 1, fi ) == 0 )
    return (0);
  n = c; i = 256;
  if ( fread ( &c, 1, 1, fi ) == 0 )
    return (0);
  n += i*c;
  i *= 256;
  if ( fread ( &c, 1, 1, fi ) == 0 )
    return (0);
  n += i*c;
  i *= 256;
  if ( fread ( &c, 1, 1, fi ) == 0 )
    return (0);
  n += i*c;
  i *= 256;
  return (n);
}

void usage ( char* argv[] )
{ printf ( "Usage: %s [options] <input_file>\n", argv[0] );
  printf ( " Options: -w to print word marks on a separate line\n" );
  printf ( "          -# number of 'files' to print (default 1)\n");
  printf ( "          -a print all of each record, including blank lines,\n");
  printf ( "             which are otherwise suppressed (except for the last one)\n");
  printf ( "          -A indent records after the first by 19 characters\n");
  printf ( "             for dumping Autocoder bootable tapes\n");
  printf ( "          -b use 'b' for blank, default is blank\n" );
  printf ( "          -c use '^' for blank, default is blank\n" );
  printf ( "          -e E11 format, i.e., don't require even-length records\n" );
  printf ( "          -h Use the H (Fortran) print arrangement (default A)\n");
  printf ( "          -o Use the 'old simh' print arrangement\n");
  printf ( "          -r[ ]# print # characters per line, max 100\n");
  printf ( "Copyright (c) Van Snyder 2011.  2011-03-20 version.\n");
}

main ( int argc, char* argv[] )
{ FILE* fi;
  char* ap;             /* arg pointer */
  int all;              /* "print all of a record, even blank lines" */
  char Autocoder;       /* Dump Autocoder boot tape.  set -w,
                           Indent records after tape boot by 19 characters */
  char* bcd_to_ascii;   /* Translation table, ..._a or ..._h */
  char blank;           /* character to print for blank */
  char ch1;             /* First character of record */
  int cl;               /* Command line argument index */
  int dowm;             /* "do word marks" */
  int even;             /* Require even-length records */
  int i, j;             /* Subscript, loop inductor */
  int nb;               /* Number of characters in print buffer so far */
  int nf, nft;          /* Number of "files" */
  int np;               /* Number of characters processed so far */
  int nr;               /* Number of records dumped so far */
  int past_boot;
  char pr[101];         /* Buffer to print tape contents */
  int recl;             /* Logical record size = chars per line, <= 100 */
  size_t recsiz, recsiz2;    /* Record size before, after */
  int shift;            /* zero or 20, depending on Autocoder */
  char wm[101];         /* Buffer to print word marks */

  if ( argc < 2 )
  { usage( argv );
    return(1);
  }

  all = 0;
  bcd_to_ascii = bcd_to_ascii_a;
  blank = ' ';
  dowm = 0;
  even = 1;
  nf = 1;
  past_boot = 0;
  recl = 100;  /* default 100 chars per line */
  for ( cl=1; cl<argc; cl++ )
  { if ( argv[cl][0] != '-' ) break;
    if ( argv[cl][1] == 'w' ) dowm = 1;
    else if ( argv[cl][1] == 'a' ) all = 1;
    else if ( argv[cl][1] == 'A' ) { Autocoder = 1; dowm = 1; }
    else if ( argv[cl][1] == 'b' ) blank = 'b';
    else if ( argv[cl][1] == 'c' ) blank = '^';
    else if ( argv[cl][1] == 'e' ) even = 0;
    else if ( argv[cl][1] == 'h' ) bcd_to_ascii = bcd_to_ascii_h;
    else if ( argv[cl][1] == 'o' ) bcd_to_ascii = bcd_to_ascii_old;
    else if ( argv[cl][1] == 'r' )
    { ap = argv[cl]; ap = ap + 2;      /* assume -r# */
      if ( *ap == ' ' | *ap == 0 )  /* allow -r # */
      { cl++;
        ap = argv[cl];
      }
      if ( sscanf(ap, "%d", &recl) )
      {  if ( recl > 100 ) recl = 100;
      }
      else
      { usage ( argv );
        return(1);
      }
    }
    else if ( sscanf(argv[cl], "%d", &nft ) ) nf = -nft;
    else
    { usage ( argv );
      return(1);
    }
  }

  if ( cl >= argc )
  { usage ( argv );
    return(1);
  }

  fi = fopen ( argv[cl], "r" );
  if ( fi == NULL )
  { printf ( "Unable to open %s\n", argv[cl] );
    return(2);
  }
  bcd_to_ascii[BCD_BLANK] = blank;
  nft = 1;
  if ( nf > 1 ) printf ( "File %d\n", nft );
  while ( nf > 0 )
  { nf--;
    for ( np=0; np<recl; pr[np++]='.' ); 
    pr[recl] = '\0';
    for ( np=5; np<=recl; np+=5 )    /* Print a row of dots and column numbers */
      for ( nb=1, i=np; i>0; i/=10, nb++ ) pr[np-nb] = '0' + ( i%10 );
    printf ( "       %s\n", pr );
    nr = 0;
    while ( recsiz = read_len ( fi ) )
    { nb = 1;
      nr++;
      i = recsiz;
      while ( i )
      { for ( np=0; np<=recl; pr[np]=blank,wm[np++]=' ') ; /* Clear buffers */
        for ( np=0; i>0 && np<recl; np++ )
        { if ( fread ( &pr[np], 1, 1, fi ) <= 0 )
          { printf ( "Error reading %s\n", argv[cl] );
            return(3);
          }
          i--;
          pr[np] = bcd_to_ascii[pr[np]];
          if ( nb == 1 & np == 0 ) ch1 = pr[0];
          if ( dowm )
            if ( pr[np] == bcd_to_ascii[BCD_WM] ) wm[np--] = '1';
        }
        for ( j=np--; j>=0 && pr[j] == blank && wm[j] == ' '; j-- ) ;
        if ( ( j >= 0 ) || ( nb == 1 ) || all || ( i == 0 ) )
        { printf ( "%5d: ", nb );
          shift = 0;
          if ( Autocoder & past_boot > 0 )
          { for ( j=1; j++<=19; printf ( " " ) ) ;
            shift = 19;
          }
          pr[np+1] = '\0';
          printf ( "%s", pr );
          if ( nb == 1 )
          { for ( j=np+shift ; j++<recl ; printf ( " " ) ) ;
            printf ( "  Record %d", nr );
          }
          printf ( "\n" );
          if ( dowm )
          { if ( Autocoder & past_boot > 0 ) for ( j=1; j++<=19; printf ( " " ) ) ;
            for ( ; np >= 0 && wm[np] == ' '; np-- );
            wm[++np] = '\0';
            printf ( "       %s\n", wm );
          }
        } 
        nb += recl;
      }
      if ( ch1 == 'B' || nr >= 2 ) past_boot = 1;
      if ( (recsiz & 1) && even ) fread ( pr, 1, 1, fi );
      recsiz2 = read_len ( fi );
      if ( recsiz2 != recsiz )
      { printf("Unequal starting and ending record sizes: %d != %d\n",
          recsiz, recsiz2);
        return(4);
      }
    }
    if ( nf > 0 ) { printf ( "File %d\n", ++nft ); past_boot = 0; }
  }
}

/* 2011-03-20 Add description of -r option. */
