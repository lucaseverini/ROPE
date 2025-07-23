/* 
Copyright 2005, by the California Institute of Technology. ALL
RIGHTS RESERVED. United States Government Sponsorship acknowledged. Any
commercial use must be negotiated with the Office of Technology Transfer
at the California Institute of Technology.

This software may be subject to U.S. export control laws. By accepting this
software, the user agrees to comply with all applicable U.S. export laws and
regulations. User has the responsibility to obtain export licenses, or other
export authority as may be required before exporting such information to
*/

#include <stdio.h>
#include <regex.h>

/* Highlight patterns in the input by coloring them in the output. */
/* "regex" is used to find the patterns.                           */
/* The exit status if zero if no "red" patterns are found, else 1. */

  static char Id[] = "$Id: hl.c,v 1.9 2011/02/24 01:43:34 vsnyder Exp $";

main ( int argc, char* argv[] )
{ char b[256];                      /* input buffer */
  char after[] = "\033[0;0m";       /* Normal on normal background */
  char blue[] = "\033[00;34;1m";    /* Bold blue on transparent background */
  char magenta[] = "\033[00;35;1m"; /* Bold magenta on transparent background */
  char red[] = "\033[00;31;1m";     /* Bold red on transparent background */
  int any;                          /* 1 + index of leftmost match; 0 => none */
  int i;                            /* Subscript/loop inductor */
  int left;                         /* Lefthand end of leftmost match */
  int next;                         /* Next element of b to search or print */
  int result;                       /* Zero = no red messages, else 1 */
  int right;                        /* Righthand end of leftmost match */
  _IO_FILE *where;                  /* Where to output -- stdout or stderr */

  typedef struct
  { char* find;          /* Pattern to find */
    char* color;         /* String to but before it */
    regex_t preg;        /* Compiled pattern -- from regcomp */
  } pat;

  regmatch_t match;      /* Where is the string that matches the pattern? */

  pat pats[] = { "[0-9]+-[SU]", red, {},     /* lf95 errors */
                 "[0-9]+-W", blue, {},       /* lf95 warnings */
                 "[0-9]+-I", magenta, {},    /* lf95 informative */
                 /* NAG f95 patterns: */
                 "[Dd]eleted", red, {},      "[Ee]rror", red, {},
                 "[Ff]atal", red, {},        "[Pp]anic", red, {},
                 "[Ww]arning", blue, {},     "[Ee]xtension", blue, {},
                 "[Oo]bsolescent", blue, {}, "[Ii]nfo", magenta, {},
                 "[Uu]ndefined", red, {} };     /* during linking */

#define NPAT ( sizeof pats / sizeof pats[0] )

  /* Compile the patterns */
  for ( i=0; i<NPAT ; i++ ) regcomp ( &pats[i].preg, pats[i].find, REG_EXTENDED );

  setvbuf ( stdout, (char*)NULL, _IONBF, 1 ); /* unbuffer the output */
  setvbuf ( stderr, (char*)NULL, _IONBF, 1 ); /* unbuffer the output */

  result = 0;
  while (1)
  { /* Get a line: */
    next = 0;
    if ( fgets ( b, sizeof b, stdin ) == NULL ) return(result);
    any = 1;
    where = stdout;
    while ( any ) { /* Look for pattern matches */
      left = sizeof(b) + 1;
      any = 0;
      for ( i=0; i<NPAT; i++ )
      { if ( regexec ( &pats[i].preg, &b[next], 1, &match, 0 ) == 0 )
        { /* Got a match */
          /* Is it a "red" pattern? */
          if ( pats[i].color == red )
          { where = stderr; /* output line to stderr */
            result = 1;     /* return status is 1 */
          }
          /* Is it the leftmost? */
          if ( match.rm_so < left )
          { left = match.rm_so;
            right = match.rm_eo;
            any = i + 1;
          }
        }
      }
      if ( any )
      { /* Got a match; put the desired color around it */
        fwrite ( &b[next], sizeof(char), left, where );
        fprintf ( where, "%s", pats[any-1].color );
        fwrite ( &b[next+left], sizeof(char), right - left, where );
        fprintf ( where, "%s", after);
        next = next + right;
      }
    }
    /* Echo the rest of the input (or all of it if no matches) */
    fprintf ( where, "%s", &b[next] );
  }
}

/*
$Log: hl.c,v $
Revision 1.9  2011/02/24 01:43:34  vsnyder
Allow mixed case for first letter of pattern

Revision 1.8  2005/06/04 02:51:46  vsnyder
Colorize as many patterns per line as necessary.  Send lines with "red"
patterns to stderr.  Return 1 if any red patterns, else zero.

Revision 1.7  2005/03/04 18:46:26  pwagner
Changed to compile under gcc 3.4.3

Revision 1.6  2004/10/30 00:32:46  vsnyder
Changed 'puce' to 'magenta'

Revision 1.5  2004/10/06 23:44:46  vsnyder
Add 'colors' bash script at the end as a comment

Revision 1.4  2001/03/03 02:15:48  vsnyder
Correct misunderstanding about usage of regex

Revision 1.3  2001/03/03 02:04:24  vsnyder
Committing working version

*/

/*
#!/bin/bash
# Display ANSI colours.
#
esc="\033["
echo -n "FG/ BG: _40_ _ _ 41 _ _ _42_ _ _ 43"
echo " _ _ 44 _ _ _45_ _ _ 46 _ _ _47_ _ _ 00_"
for fore in 30 31 32 33 34 35 36 37 00; do
  line1="$fore  "
  line2="    "
  for back in 40 41 42 43 44 45 46 47 00; do
    line1="${line1}${esc}${back};${fore}m Normal ${esc}0m"
    line2="${line2}${esc}${back};${fore};1m Bold   ${esc}0m"
  done
  echo -e "$line1\n$line2"
done
*/
