 101 001       job  1401 autocoder-pass 2-process iocs-main 2 -version 3   3722l
 102           ctl  630 1
 103           sfx  i
 104 other     equ  start
 105 minus2    equ  2
 106 minus3    equ  3
 107 diocsb    equ  labdio-4
 108           org  1
 109 mainx     da   1x86
 110 lmainx    equ  *
 111 *      xinit index1,index2,index3
  01 index1    equ  089
  02 089       dcw  000
  04 091       dc   00
  05 index2    equ  094
  06 094       dcw  000
  08 096       dc   00
  09 index3    equ  099
  10 099       dcw  000
  12 100       dc   0
 112 *
 113 * start of main line
 114 *
 115           org  101
 116 start     rwd  4
 117           rwd  5
 118           rwd  6
 119           bss  ovlay2,b
 120           b    redrec
 121           c    mainx&17, @job@
 122           bu   cmctl
 123           cc   1
 124           mcw  80,280
 125           w
 126              n1               cc 1 in rev 0.
 127           b    wrtrec
 128           b    redrec
 129 cmctl     c    mainx&17, @ctl@
 130           bu   find
 131           bce  robin,mainx&23,1
 132           mn   mainx&21,*&8
 133           bce  robin,@456@,
 134           chain2
 135           b    blue
 136           org  201
 137           da   1x132
 138                6,6
 139 dtftab    equ  labdtf-1
 140           org  333
 141 either    b    nexrec
 142 *
 143 *              control card information
 144 *
 145 specl     dcw  @*@
 146 symnm     dcw  #3
 147 *
 148 *              dtf  major  table
 149 *
 150           dcw  @,@
 151           dcw  @;@                cobol   yes
 152           dcw  @;@                exits   yes
 153 filenm    dcw  #6
 154 labdtf    dcw  @;@           1    input         1     filetype
 155           dcw  @;@           2    output        2
 156           dcw  @;@           3    tape          3
 157           dcw  @;@           4    reader        4
 158           dcw  @;@           5    punch         5
 159           dcw  @;@           6    printer       6
 160           dcw  @;@           7    load          7     modepar
 161           dcw  @;@           8    checkpoint     8    features
 162           dcw  @;@           9    number        9     chandrive
 163           dcw  @;@          10    number       10     cardpoc
 164           dcw  @;@          11    number       11     alttape
 165           dcw  @;@          12    blocked      12     recform
 166           dcw  @;@          13    unblocked    13
 167           dcw  @;@          14    mixed        14
 168           dcw  @;@          15    variable     15
 169           dcw  @   ;@       16-19 number       16     sizerec
 170           dcw  @;@          20    number       17     padding
 171           dcw  @   ;@       21-24 number       18     blocksize
 172           dcw  @         ;@   25-34    labels  19     ioareas
 173           dcw  @         ;@   35-44            20
 174           dcw  @         ;@  45-54             21     workarea
 175           dcw  @;@          55    number       22     indexreg
 176           dcw  @         ;@  56-65 label       23     eoraddr
 177           dcw  @         ;@   66-75 label      24     wlraddr
 178           dcw  @;@          76    record       25     totals
 179           dcw  @   ;@       77-80 hash         26
 180           dcw  @;@          81    standard     27
 181           dcw  @;@          82    nonstandard  28
 182           dcw  @;@          83    tm           29
 183           dcw  @;@          84    all          30
 184           dcw  @;@          85    ident        31
 185           dcw  @  ;@
 186           dcw  @    ;@
 187           dcw  @         ;@
 188           dcw  @    ;@      104-108 number     35     serialnum
 189           dcw  @         ;@ 109-118            39     ex1addr
 190           dcw  @         ;@ 119-128            40     ex2addr
 191           dcw  @         ;@ 129-138            41     ex3addr
 192           dcw  @         ;@ 139-148            42     ex4addr
 193           dcw  @         ;@ 149-158            43     ex5addr
 194           dcw  @         ;@ 159-168            44     ex6addr
 195           dcw  @         ;@ 169-178            45     ex7addr
 196           dcw  @         ;@ 179-188            46     ex8addr
 197           dcw  @         ;@ 189-198            47     varbuild
 198           dcw  @;@          199  unload        37
 199           dcw  @;@          100  norewd        38
 200           dcw  @;@           9      201               overflow
 201           dcw  @;@          12      202
 202           dcw  @  ;@       203-205   number           reelseqp
 203           dcw  @;@               206                  formcntl
 204           dcw  #9
 205           dcw  @;@           216     address          overflow
 206           dcw  @ @
 207 enddtf    dcw  @ @
 208 *
 209 *              diocs major table
 210 *
 211           dcw  @,@
 212 divide    equ  *
 213           dcw  @;@               40   par        out  tapeuse
 214           dcw  @;@               39   par        inp  tapeuse
 215           dcw  @;@               38   par        yes  exits
 216 labdio    dcw  #9                           diocsorg
 217           dcw  @;@                5
 218           dcw  @;@                6         overlap    features
 219           dcw  @;@                7         tape       iodevices
 220           dcw  @;@                8         reader
 221           dcw  @;@                9         punch
 222           dcw  @;@               10         printer
 223           dcw  @;@               11         standard   labeldef
 224           dcw  @;@               12         nonstandard
 225           dcw  @;@               13         mixed
 226           dcw  @;@               14         check
 227           dcw  @;@               15         ident
 228           dcw  @;@               16         tm
 229           dcw  @;@               17         yes        altdrive
 230           dcw  @;@               18         1          exits
 231           dcw  @;@               19         2
 232           dcw  @;@               20         3
 233           dcw  @;@               21         4
 234           dcw  @;@               22         5
 235           dcw  @;@               23         6
 236           dcw  @;@               24         7
 237           dcw  @;@               25         8
 238           dcw  @;@               rdlin      labeldef
 239           dcw  @;@               27         729        drivetype
 240           dcw  @;@               28         7330
 241           dcw  @;@               29         norwd      rwdoption
 242           dcw  @;@               30         unload
 243           dcw  @;@               31    tape,#          readerror
 244           dcw  @;@               32    scan
 245           dcw  @;@               33    process
 246           dcw  @;@               clean     readerror
 247           dcw  @;@               35         yes        inpvar
 248           dcw  @;@               36         yes        inpfxno
 249           dcw  @;@               37         record     counts
 250           dcw  @;@         38    hash
 251           dcw  #5
 252           dcw  @;@         39-44         checkpoint
 253           dcw  @;@          45   release              features
 254 enddio    dcw  @;@          46   storage
 255 *
 256 *
 257 robin     s    specl
 2575blue      mcw  mainx&25,nordrl#1
 258 thru      b    wrtrec
 259           b    redrec
 260 find      c    mainx&19,kdiocs
 261           be   gotit
 262 *
 263 *
 264 *                read in phase 2
 265 *
 266 *
 267           bce  thru,mainx&5,*
 268 preps2    b    savcd
 269           b    pass2
 270 gotit     mcw  @m@,length
 272 whom      b    wrtrec
 273 nexrec    b    redrec
 274 gamma     bce  whom,mainx&5,*
 275           c    mainx&17,@dtf@
 276           be   dtfnd
 277           b    wrtrec
 278           b    upper
 279 dtfnd     b    savcd
 280           b    crdout
 281 *
 282 *              write routine
 283 *
 284 wrtrec    sbr  wrtext&3
 285           mcw  lmainx,loput-1
 286           sw   loput
 287           mcw  gmwmrk,loput
 288 length    nop  @w@,outpt&74
 289 short     b    ctape
 290           nop  tdf6
 291 wrtext    b    0
 292 tdf6      dcw  000
 293           wt   6,outpt
 294 gmwmrk    dc   @}@
 295 *
 296 *              read routine
 297 *
 298 redrec    sbr  redext&3
 299           cs   lmainx
 300           bss  rtwed,c
 301           blc  dtfout
 302           r
 303           ssb  redext,1
 304 rtwed     b    ctape
 305           nop  tdf4
 306 redext    b    0
 307 tdf4      dcw  &dtfout
 308           rt   4,mainx
 309 *
 310 *              look up label
 311 *
 312 upper     cw   scnsw#1
 313           bce  nexrec,mainx&20,
 314           sbr  chair&3,lstpar
 315           s    index2&1
 316           sbr  index3,lbltbl
 317 compr     c    mainx&7,0&x3
 318           sbr  index3
 319           be   comeq
 320           bce  nexrec,0&x3,@
 321           a    @7@,index2
 322           b    compr
 323 brtbl     b    actscn
 324           dcw  &diocsb&36                   inpfxno
 325           b    reasb
 326           dcw  #3                           readerror
 327           b    opdscn
 328           dcw  &rwdtb                       rwdopt
 329           b    opdscn
 330           dcw  &dritb                       drivetype
 331           b    opdscn
 332           dcw  &coutb                       counts
 333           b    actscn
 334           dcw  &diocsb&35                   varinp
 335           b    exisb
 336           dcw  #3
 337           b    actscn
 338           dcw  &diocsb&17                   altdrive
 339           b    opdscn
 340           dcw  &labtb                       labeldef
 341           b    opdscn
 342           dcw  &iodtb                       iodevices
 343           b    opdscn
 344           dcw  &featb                       features
 345           b    diosb                        diocsorg
 346           dcw  &diocsb&5
 347           b    diosb
 348           dcw  &diocsb&44
 349           b    opdscn
 350           dcw  &taptb
 351 comeq     s    index3&1
 352           b    brtbl&x2
 353 *
 354 exisb     lca  @$@,divide&3
 355           b    opdscn
 356           dcw  &exitb                       exits
 357 *
 358 newscn    sbr  nwext&3
 359           mcw  @   @,opdar#3
 360           s    index2&1
 361 nwscnl    c    mainx&21&x3,@  @
 362           sw   mainx&20
 363           be   fdblk
 364           bce  found,mainx&20&x3,,
 365           c    index3,@52@
 366           be   blkfd
 367           mcw  mainx&20&x3,opdar-2&x2
 368           a    @1@,index2
 369           bce  found,index2,3
 370           a    @1@,index3
 371           b    nwscnl
 372 fdblk     a    @1@,index3
 373 blkfd     sw   scnsw
 374 nwext     b    0
 375 found     b    scanx
 376           b    nwext
 377 *
 378 *              actual  scan  for yes
 379 *
 380 actscn    sbr  index1
 381           mcw  2&x1,index1
 382           c    mainx&22,@yes@
 383           bu   actout
 384           lca  @$@,0&x1
 385 actout    b    either
 386 *
 387 *              diocsorg
 388 *
 389 diosb     sbr  index1
 390           mcw  2&x1,index1
 391           b    scanx
 392           lca  mainx&18&x3,0&x1
 393           b    nexrec
 394 *
 395 *              readerror
 396 *
 397 reasb     sbr  chair&3,chtap
 398           b    opdscn
 399           dcw  &reatb
 400 chtap     c    opdar,@tap@
 401           bu   lstpar
 402           b    scanx
 403           bce  lstpar,mainx&18&x3,
 404           mcw  mainx&18&x3,diocsb&31
 405           b    lstpar
 406 *
 407 *              combination read/ write routine
 408 *
 409 ctape     sbr  index2
 410           sbr  iconpr&3
 411           mcw  3&x2,index2
 412           mcw  8&x2,itapec&7
 413           mcw  0&x2,ieorc&3
 414           sw   icompr&4
 415           mcw  7&x2,icompr&6
 416           a    @12@,icompr&6
 417           cw   icompr&4
 418           mn   itapec&3,ihalt&6
 419           mn   itapec&7,ihalt&6
 420           mcw  @9@,ierrct#1
 421 itapec    rt   0,0
 422           bce  iomets,itapec&7,w
 423 ieorc     bef  0
 424 icompr    bce  itapec,0,}
 425           chain12
 426 iomets    ber  irwred
 427 iconpr    b    0
 428 irwred    s    @1@,ierrct
 429           mn   itapec&3,*&4
 430           bsp  0
 431           bce  itrow,itapec&7,w
 432           bm   ihalt,ierrct
 433           b    itapec
 434 itrow     a    @1@,ierasc#2
 435           skp  6
 436           bce  ichalt,ierasc-1,5
 437           b    itapec-7
 438 ichalt    s    ierasc
 439           h    0,202
 440           b    itapec-7
 441 ihalt     h    0,200
 442           bss  itapec-7,e
 443           mcw  itapec&7,*&8
 444           rt   0,0
 445           h    0,201
 446           b    iconpr
 447 passi     lca  enddio,enddtf
 448           lca
 449           sbr  either&3,difrec
 450           mcw  &dtftab&x1,opdfnd&6
 451           lca  186,lmainx
 452           b    wrtrec
 453           b    dtfnm
 454 altby     b    bypss
 455           bsp  4
 456 pass2     rt   1,3997
 457           rt   1,3997
 458           sbr  tdf1&7,341
 459           b    ctape
 460           nop  tdf1
 461           b    ovly3
 462 *
 463 numerc    sbr  index1
 464           mcw  2&x1,index1
 465           sw   mainx&20
 466           mcw  mainx&20,dtftab&x1
 467           b    difrec
 468 kdiocs    dcw  @diocs@
 469 blorb     b    scanx
 470           a    mainx&18&x3,blowa-1
 471           lca  blowa-1,dtftab&24
 472           s    blowa
 473           b    either
 474 blowa     dcw  &00000
 475           ltorg*
 476           org  1649
 477 over      dcw  @}@
 478           ex
 479           job  1401 autocoder-pass 2-process iocs-main 1 -version 3   3721l
 480           org  1650
 481           sfx  I
 482 *
 483 *              dtf  table  of  branches
 484 *
 485 dtfint    sbr  index3,dtflab
 486           sbr  chair&3,lstpar
 487           bce  difrec,mainx&20,
 488           cw   scnsw
 489           c    mainx&6,@ex@
 490           be   exirb
 491           s    index2&1
 492 seek      c    mainx&7,0&x3
 493           sbr  index3
 494           be   agree
 495           bce  difrec,0&x3,@
 496           a    @7@,index2
 497           b    seek
 498 dtfbr     b    opdscn
 499           dcw  rewxz                        rewind
 500           b    actual
 501           dcw  &dtftab&205                  reelseq
 502           b    actual
 503           dcw  &dtftab&108                  serialnum
 504           b    hearb
 505           dcw  &dtftab&103
 506           b    opdscn
 507           dcw  &chexz                       checklabel
 508           b    opdscn
 509           dcw  &typxz                       typelabel
 510           b    totrb
 511           dcw  #3                           totals
 512           b    actual
 513           dcw  &dtftab&75                   wlraddr
 514           b    actual
 515           dcw  &dtftab&65                   eofaddr
 516           b    indrb
 517           dcw  #3                           indexreg
 518           b    actual
 519           dcw  &dtftab&54                   workarea
 520           b    ioarb
 521           dcw  &dtftab&44                   ioareas
 522           b    blorb
 523           dcw  &dtftab&24                   blocksize
 524           b    numerc
 525           dcw  @020@                        padding
 526           b    actual
 527           dcw  &dtftab&19                   sixerec
 528           b    opdscn
 529           dcw  &recxz                       recform
 530           b    numerc
 531           dcw  @011@                        alttape
 532           b    numerc
 533           dcw  @010@                        cardproc
 534           b    opdscn
 535           dcw  &modxz                       modepar
 536           b    opdscn
 537           dcw  &filxz                       filetype
 538           b    numerc
 539           dcw  @009@                        chandrive
 540           b    actual
 541           dcw  dtftab&198                   varbuild
 542           b    actscn
 543           dcw  &dtftab-7
 544           b    numerc
 545           dcw  @206@
 546           b    overb
 547           dcw  #1
 548           org  1900
 549           rtw  1,1
 550           ber  halt
 551           cw   over
 552           b    other
 553 halt      bsp  1
 554           nop  288
 555           h
 556           b    1900
 557 *
 558 agree     s    index3&1
 559           sw   mainx&20
 560           b    dtfbr&x2
 561 *              ioareas
 562 *
 563 ioarb     b    scanx
 564           lca  mainx&18&x3,dtftab&44
 565           bw   either,scnsw
 566           b    scanx
 567           lca  mainx&18&x3,dtftab&34
 568           b    either
 569 *
 570 *              totals
 571 *
 572 totrb     sbr  chair&3,totjk
 573           b    opdscn
 574           dcw  &totxz
 575 totjk     lca  mainx&18&x3,dtftab&80
 576           b    lstpar
 577 overb     sbr  chair&3,ovejk
 578           b    opdscn
 579           dcw  &ovexz
 580 ovejk     lca  mainx&18&x3,dtftab&216
 581           b    lstpar
 582 *
 583 *                exits  routine
 584 *
 585 exirb     mcw  @1 8@,index2
 586           mn   mainx&7,index2-1
 587           s    index3&1
 588           b    scanx
 589           lca  mainx&18&x3,dtftab&x2
 590           lca  @$@,dtftab-6
 591           b    difrec
 592 *
 593 *              index  register
 594 *
 595 indrb     mn   mainx&21,dtftab&55
 596           mz   @ @,dtftab&55
 597           b    difrec
 598 *
 599 *                load parameters - actual
 600 *
 601 actual    sbr  index1
 6015          bw   either,scnsw
 602           mcw  2&x1,index1
 603 search    b    scanx
 604           lca  mainx&18&x3,0&x1
 605           sbr  index1
 606           bw   difrec,scnsw
 607           b    search
 608 newwrt    sbr  wrtext&3
 609           mcw  lmainx,loput-1
 610           sw   outpt&80
 611           mcw  gmwmrk,outpt&80
 612 long      mcw  @*@,outpt&73
 613           b    short
 614 *
 615 *                output  macro  statement  for  dioc
 616 *
 617 crdout    mn   @5@,tdf6&4
 618           cs   lmainx
 619           mcw  @55555@,mainx&19
 620           sbr  index3,enddio
 621           b    good&4
 622 good      cs   lmainx
 623           sw   1
 624           sbr  index1,mainx&20
 625           mcw  @'@,mainx&72
 626 lodpar    mcw  0&x3,wkarea-1
 627           sbr  index2
 628           mcw  index1,savxl1#3
 629           mcm  1&x2,0&x1
 630           sbr  index1
 631           mcw  @, @,0&x1
 632           bce  contin,mainx&72,'
 633           mcw  savxl1,index1
 634           sw   0&x1
 635           mcw  @  @,mainx&79
 636           mcw  mainx&78
 637           cw   0&x1
 638           b    newwrt
 639           cw   outpt&80
 640           b    good
 641 contin    mcw  0&x3,0&x3
 642           sbr  index3
 643 comblk    c    0&x3,@ @
 644           sar  index3
 645           be   comblk
 646           a    @1@,index3
 647           b    alldio,0&x3,,
 648           b    lodpar
 649 alldio    mcw  @  @,0&x1
 650           mcw  @ @,mainx&72
 651           b    newwrt
 652           cw   outpt&80
 653           mn   @6@,tdf6&4
 654 better    b    passi
 655 wkarea    dcw  @          '@
 656 dtfnm     s    index3&1
 657           b    scanx
 658           lca  mainx&18&x3,filenm
 659 difrec    b    redrec
 660 delta     bce  alpha,mainx&5,*
 661           c    mainx&19,@     @
 662           bu   dtfout
 663 alpha     b    wrtrec
 664           bce  difrec,mainx&5,*
 665           b    dtfint
 666 dtfout    mn   @5@,tdf6&4
 667           sbr  index3,enddtf
 668           b    savcd
 669           sbr  walk&3,altby
 670           c    mainx&17,@dtf@
 671           cs   lmainx
 672           mcw  @33333@,mainx&19
 673           be   setdsw
 674 river     sbr  better&3,pass2
 675           b    good&4
 676 setdsw    sbr  better&3,rndtf
 677           b    good&4
 678 rndtf     rtw  1,341
 679           bsp  1
 680           cw   dtfgm
 681           b    passi
 682 hearb     b    scanx
 683           mcw  mainx&18&x3,dtftab&103
 684           b    actual
 685           dcw  &dtftab&93
 686 *
 687 *              scan for a comma or two blanks
 688 *
 689 scanx     sbr  clubs&3
 690 scanl     sw   mainx&20
 691           c    mainx&21&x3,@  @
 692           a    @1@,index3
 693           be   setit
 694           bce  setwms,mainx&19&x3,,
 695           c    index3,@52@
 696           bu   scanl
 697 setit     sw   scnsw
 698 setwms    sw   mainx&20&x3
 699 clubs     b    0
 700 *
 701 *              scan   operand table
 702 *
 703 *
 704 opdscn    sbr  index2
 705           mcw  2&x2,savx2
 706 opdrtn    b    newscn
 707           mcw  savx2#3,index2
 708 seekop    c    opdar,0&x2
 709           sbr  index2
 710           mcw  0&x2,index1
 711           sar  index2
 712           be   opdfnd
 713 chair     bce  lstpar,0&x2,@
 714           b    seekop
 715 lstpar    bw   either,scnsw
 716           b    opdrtn
 717 opdfnd    lca  @$@,diocsb&x1
 718           b    lstpar
 719 savcd     sbr  svcdx&3
 720           cs   186
 721           sw   101
 722           mcw  lmainx,186
 723 svcdx     b    0
 724 *
 725 *              read  in  overlay  two
 726 *
 727 tdf1      dcw  #3
 728           rtw  1,101
 729 ovlay2    sw   gmovl2
 730           mcw  gmwmrk,gmovl2
 731           rt   1,101
 732           b    ctape
 733           nop  tdf1
 734           b    punch
 735 *
 736 *              alter part of iocs
 737 *
 738 alter     b    ctape
 739           nop  tdf4a
 740           mcw  outpt&7,symnm
 741           bss  outcl,c
 742           bsp  4
 743           sbr  river&6,tunel
 744           sbr  preps2&3
 745           r
 746           c    mainx&17,@alt@
 747           bu   walk
 748 homal     b    savxx
 749           b    packx
 750 noaltb    b    ctape
 751           nop  tdf4a
 752           c    outpt&83,hlda1
 753           be   check
 754 propre    c    outpt&17,@job@
 755 alts1     bu   alts2e
 756           b    nopjb
 757           b    noter
 758 alts2e    c    outpt&17,@ctl@
 759 alts2     be   outcl
 760 solved    mcw  outpt&85,lmainx
 761           sw   reads
 762 altio     bss  regen,g
 763 tunel     bw   bspt4,reads
 764 walk      b    savcd
 765           b    altby
 766 bspt4     bw   regl,xcards
 767           mn   @5@,tdf6&4
 768           b    newwrt
 769           b    regl&5
 770 regl      bsp  4
 771           lca  areasv,186
 772           b    altby
 773 packx     sbr  packs&3
 774           sw   baltr
 775           cw   scnsw
 776           s    index3&1
 777           b    scanx
 778           za   mainx&18&x3,hlda1#4
 779           bw   parks,scnsw
 780           b    scanx
 781           za   mainx&18&x3,hldb
 782           cw   baltr#1
 783 parks     cs   lmainx
 784           sw   1
 785 packs     b    0
 786 *
 787 *              alter  number  compares  equal
 788 *
 789 check     bw   wrtal,baltr
 790 dblal     c    outpt&83,hldb#4
 791           be   wrtal
 792           b    ctape
 793           nop  tdf4a
 794           b    dblal
 795 wrtal     blc  tunel
 796           r
 797           c    mainx&17,@alt@
 798           be   homal
 799           c    mainx&17,@job@
 800 alts3     bu   alts4e
 801           b    nopjb
 802           b    rsolv
 803 alts4e    c    mainx&17,@ctl@
 804 alts4     be   crdcl
 805           bw   tuff,baltr
 806           cw   reads
 807           b    altio
 808 tuff      b    savxx
 809           cw   xcards
 8101          sbr  rsolv&7,solved
 8102          sbr  chuck&3
 810           mcw  @n@,nosol
 811           b    propre
 812 *
 813 *              tdf  for  reading  86  character  records
 814 *
 815 tdf4a     dcw  tunel
 816           rt   4,outpt
 817 *
 818 *              regeneration  of  diocs  and  dtf
 819 *
 820 regen     bw   ordn,xcards
 821           sbr  nexrec&3,spcas
 822           sbr  aldio-1,soft
 823           cw   reads
 824           b    find
 825 spcas     mcw  areasv,lmainx
 826           sw   xcards#1
 827 ordn      sbr  nexrec&3,aldio
 828           sbr  difrec&3,aldtf
 829           b    find
 830 aldio     cs   lmainx
 831           bw   rdt4a,reads
 832           blc  lunet
 833           r
 834           c    mainx&17,@alt@
 835           bu   soft
 836           b    savxx
 837           b    packx
 838 rdt4a     b    bypss
 839           c    outpt&83,hlda1
 840 final     be   dblck
 841           sw   reads
 842 final2    mcw  outpt&85,lmainx
 843 soft      b    gamma
 844 dblck     cw   reads#1
 845           bw   final2,baltr
 846 trpck     c    outpt&83,hldb
 847           be   aldio
 848           b    ctape
 849           nop  tdf4a
 850           b    trpck
 851 *
 852 *              dtf  on  alter  mode
 853 *
 854 aldtf     sbr  soft&3,delta
 855           b    aldio
 856 savxx     sbr  savxt&3
 857           mcw  lmainx,areasv
 858 savxt     b    0
 859 lunet     sw   reads
 860           mcw  @n@,final
 861           b    rdt4a
 862 bypss     sbr  bypsx&3
 863           b    ctape
 864           nop  tdf4a
 865           bce  bypss&4,outpt&74,y
 866           bce  bypss&4,outpt&74,z
 867 bypsx     b    0
 868 *
 869 *              dtf  table  of  operands
 870 *
 871           dcw  @@@                   filetyp
 872           dcw  @001@
 873           dcw  @inp@                      input
 874           dcw  @002@
 875           dcw  @out@                      output
 876           dcw  @003@
 877           dcw  @tap@                      tape
 878           dcw  @004@
 879           dcw  @rea@                      reader
 880           dcw  @005@
 881           dcw  @pun@                      punch
 882           dcw  @008@
 883           dcw  @che@
 884           dcw  @006@
 885 filxz     dcw  @pri@                      printer
 886           dcw  @@@                   modepar
 887           dcw  @007@
 888 modxz     dcw  @loa@
 889           dcw  @@@                   recform
 890           dcw  @012@
 891           dcw  @blo@                      blocked
 892           dcw  @013@
 893           dcw  @unb@                      unblocked
 894           dcw  @014@
 895           dcw  @fix@                           fixed
 896           dcw  @015@
 897 recxz     dcw  @var@                      variable
 898           dcw  @@@                   typelabel
 899           dcw  @081@
 900           dcw  @sta@                      standard
 901           dcw  @082@
 902           dcw  @non@                      nonstandard
 903           dcw  @083@
 904 typxz     dcw  @tm @                      tm
 905           dcw  @@@                   checklabel
 906           dcw  @084@
 907           dcw  @all@                      all
 908           dcw  @085@
 909 chexz     dcw  @ide@                      ident
 910           dcw  @@@                   rewind
 911           dcw  @199@
 912           dcw  @unl@                      unload
 913           dcw  @200@
 914 rewxz     dcw  @nor@                      norewd
 915           dcw  @@@
 916           dcw  @201@
 917           dcw  @9  @
 918           dcw  @202@
 919 ovexz     dcw  @12 @
 920           dcw  @@@
 921           dcw  @076@
 922 totxz     dcw  @rec@
 923 *
 924 *              diocs  operand  table
 925 *
 926           dcw  @@@
 927           dcw  -minus3&4
 928           dcw  @out@
 929           dcw  -minus2&4
 930 taptb     dcw  @inp@
 931           dcw  @@@
 932           dcw  @045@
 933           dcw  @rel@
 934           dcw  @046@
 935           dcw  @sto@
 936           dcw  @006@
 937 featb     dcw  @ove@                      overlap
 938           dcw  @@@
 939           dcw  @007@
 940           dcw  @tap@                      tape
 941           dcw  @008@
 942           dcw  @rea@                      reader
 943           dcw  @009@
 944           dcw  @pun@                      punch
 945           dcw  @010@
 946 iodtb     dcw  @pri@                      printer
 947           dcw  @@@
 948           dcw  @011@
 949           dcw  @sta@                      standard
 950           dcw  @012@
 951           dcw  @non@                      nonstandard
 952           dcw  @013@
 953           dcw  @mix@                      mixed
 954           dcw  @014@
 955           dcw  @che@                      check
 956           dcw  @015@
 957           dcw  @ide@                      ident
 958           dcw  @026@
 959           dcw  @rdl@
 960           dcw  @016@
 961 labtb     dcw  @tm @                      tm
 962           dcw  @@@
 963           dcw  @018@
 964           dcw  @1  @                      exit 1
 965           dcw  @019@
 966           dcw  @2  @                      exit 2
 967           dcw  @020@
 968           dcw  @3  @                      exit 3
 969           dcw  @021@
 970           dcw  @4  @                      exit 4
 971           dcw  @022@
 972           dcw  @5  @                      exit 5
 973           dcw  @023@
 974           dcw  @6  @                      exit 6
 975           dcw  @024@
 976           dcw  @7  @                      exit 7
 977           dcw  @025@
 978 exitb     dcw  @8  @                      exit 8
 979           dcw  @@@
 980           dcw  @027@
 981           dcw  @729@                      729
 982           dcw  @028@
 983 dritb     dcw  @733@                      7330
 984           dcw  @@@
 985           dcw  @029@
 986           dcw  @nor@                      no rwed
 987           dcw  @030@
 988 rwdtb     dcw  @unl@                      unload
 989           dcw  @@@
 990           dcw  @037@
 991           dcw  @rec@                      record
 992           dcw  @038@
 993 coutb     dcw  @has@                      hash
 994           dcw  @@@
 995           dcw  @034@
 996           dcw  @cle@
 997           dcw  @033@
 998           dcw  @pro@
 999           dcw  @032@
1000 reatb     dcw  @sca@
1001 *
1002 *              dtf  table  of  labels
1003 *
1004           dcw  @@@
1005           dcw  @ove@               overflow
1006           dcw  @for@               formsctl
1007           dcw  @cob@               cobol
1008           dcw  @var@               varbuild
1009           dcw  @cha@               chandrive
1010           dcw  @fil@               filetype
1011           dcw  @mod@               modepar
1012           dcw  @car@               cardproc
1013           dcw  @alt@               alttape
1014           dcw  @rec@               recform
1015           dcw  @siz@               sizerec
1016           dcw  @pad@               padding
1017           dcw  @blo@               blocksize
1018           dcw  @ioa@               ioareas
1019           dcw  @wor@               workarea
1020           dcw  @ind@               indexrec
1021           dcw  @eof@               eofaddr
1022           dcw  @wlr@               wlraddr
1023           dcw  @tot@               totals
1024           dcw  @typ@               typelabel
1025           dcw  @che@               checklabel
1026           dcw  @hea@               header
1027           dcw  @ser@               serialnum
1028           dcw  @ree@               reelser
1029 dtflab    dcw  @rew@               rewind
1030 *
1031 *
1032 *              label table
1033 *
1034           dcw  @@@
1035           dcw  @tap@               tapeuse
1036           dcw  @che@               checkpoint
1037           dcw  @dio@               diocsorg
1038           dcw  @fea@               features
1039           dcw  @iod@               iodevices
1040           dcw  @lab@               labeldef
1041           dcw  @alt@               alttape
1042           dcw  @exi@               exits
1043           dcw  @var@               varbuild
1044           dcw  @cou@               counts
1045           dcw  @dri@               drivetype
1046           dcw  @rwd@               rwdoption
1047           dcw  @rea@               readerror
1048 lbltbl    dcw  @inp@               inpfxno
1049           ltorg*
1050 *
1051 *                output  area
1052 *
1053           org  3912
1054 outpt     da   1x86,g
1055 loput     equ  *
1056           ex
1057           job  1401 autocoder-pass 2-copy dtf table      -version 3   3723l
1058           sfx  i
1059           org  341
1060           dcw  @,@
1061           dcw  @;@                exits   yes
1062           dcw  @;@                cobol   yes
1063           dcw  #6
1064           dcw  @;@           1    input         1    filetype
1065           dcw  @;@           2    output        2
1066           dcw  @;@           3    tape          3
1067           dcw  @;@           4    reader        4
1068           dcw  @;@           5    punch         5
1069           dcw  @;@           6    printer       6
1070           dcw  @;@           7    load          7    modepar
1071           dcw  @;@           8    checkpoint     8   features
1072           dcw  @;@           9    number        9    chandrive
1073           dcw  @;@          10    number       10    cardproc
1074           dcw  @;@          11    number       11    alttape
1075           dcw  @;@          12    blocked      12    recform
1076           dcw  @;@          13    unblocked    13
1077           dcw  @;@          14    mixed        14
1078           dcw  @;@          15    variable     15
1079           dcw  @   ;@       16-19 number       16    sizerec
1080           dcw  @;@          29    number       17    padding
1081           dcw  @   ;@       21-24 number       18    blocksize
1082           dcw  @         ;@   25-34    labels  19    ioareas
1083           dcw  @         ;@   35-44            20
1084           dcw  @         ;@  45-54  label      21    workarea
1085           dcw  @;@          55    number       22    indexreg
1086           dcw  @         ;@  56-65  label      23    eoraddr
1087           dcw  @         ;@   66-75  label     24    wlraddr
1088           dcw  @;@          76    record       25    totals
1089           dcw  @   ;@       77-80 hash         26
1090           dcw  @;@          81    standard     27    typelabel
1091           dcw  @;@          82    nonstandard  28
1092           dcw  @;@          83    tm           29
1093           dcw  @;@          84    all          30    checklabel
1094           dcw  @;@          85    ident        31
1095           dcw  @  ;@
1096           dcw  @    ;@
1097           dcw  @         ;@
1098           dcw  @    ;@      104-108 number     35    serialnum
1099           dcw  @         ;@ 109-118            39    ex1addr
1100           dcw  @         ;@ 119-128            40    ex2addr
1101           dcw  @         ;@ 129-138            41    ex3addr
1102           dcw  @         ;@ 139-148            42    ex4addr
1103           dcw  @         ;@ 149-158            43    ex5addr
1104           dcw  @         ;@ 159-168            44    ex6addr
1105           dcw  @         ;@ 169-178            45    ex7addr
1106           dcw  @         ;@ 179-188            46    ex8addr
1107           dcw  @         ;@ 189-198            47    varbuild
1108           dcw  @;@          199  unload        37    rewind
1109           dcw  @;@          200  norewd        38
1110           dcw  @;@           9      201              overflow
1111           dcw  @;@          12      202
1112           dcw  @  ;@        203-205  number          reelseq
1113           dcw  @;@               206                 formctl
1114           dcw  #9
1115           dcw  @;@           216     address         overflow
1116           dcw  @ @
1117           dcw  @ @
1118 dtfgm     dcw  @}@
1119           ex
1120           job  1401 autocoder-pass 2-alter overlay       -version 3   3724l
1121           sfx  i
1122           org  101
1123 *
1124 *
1125 *              ctl  card  on  tape  4
1126 *
1127 punch     cw   gmovl2
1128           bsp  1
1129           bsp  1
1130           b    alter
1131 outcl     mcw  outpt&85,lmainx
1132           bss  preps2,c
1133 nosol     sbr  rsolv&7,noaltb
1134 *
1135 *              ctl  card  from  cards
1136 *
1137 crdcl     bce  leave,mainx&23,1
1138           mn   mainx&21,*&8
1139           bce  leave,@456@,
1140           chain2
1141           b    letbe
1142 leave     s    specl
1143 letbe     b    nopcl
1144 rsolv     b    wrtrec
1145           b    wrtal
1146 *
1147 nopcl     sbr  npclx&3
1148           mcw  @n@,alts2
1149           mcw  @n@,alts4
1150 npclx     b    0
1151 nopjb     sbr  npjbx&3
1152           sw   alts1&4,alts3&4
1153 npjbx     b    0
1154 noter     mcw  outpt&85,lmainx
1155           b    wrtrec
1156 chuck     b    noaltb
1157           ltorg*
1158           org  246
1159           da   1x86
1160 areasv    equ  *
1161 gmovl2    dcw  @}@
1162           ex
1163           job  1401 autocoder - pass 2 - end overlay     -version 3   3725l
1164           sfx  i
1165           org  341
1166 ovly3     mn   @5@,tdf6&4
1173           sbr  long&3,@n@
1174           lca  186,lmainx
1175           b    newwrt
1176           cw   outpt&80
1177           sw   gmovl4
1178           mcw  gmwmrk,gmovl4
1179           b    ctape
1180           nop  tdf9
1181           cw   gmovl4
1182           rwd  5
1183           b    ctape
1184           nop  tdfsys
1185           b    1900
1186 tdf9      dcw  #3
1187           wtw  5,ovly4
1188 tdfsys    dcw  #3
1189           rtw  1,1650
1192 *
1193           ltorg*
1194 ovly4     equ  *&1
1195           sfx  x
1196 *    end of job
1197 *
1198           c    calltx,blanks-2
1199           be   stendx
1200           b    surexx
1201 stendx    b    sbrotx
1202           rwd  5
1203           bsp  1
1204           bsp  1
1205           wtm  6
1206           rwd  6
1207           mcw  symnmx,mainx&2
1208           lca  loput&1,mainx&35
1209           wt   5,mainx
1210           wtm  5
1211           rwd  4
1212           cw   liput&1,mainx&35
1213           cw   100
1214 bypasx    rt   1,3997
1215           sw   loput&1
1216           bef  cbsp2x
1217           b    bypasx
1218 cbsp2x    rt   1,3997
1219           sw   loput&1
1220           s    &1,cbsp1x
1221           bm   cbsp3x,cbsp1x
1222           b    cbsp2x
1223 *
1224 *  load pass 3
1225 *
1226 cbsp3x    cs   partb
1227           cs
1228           cs
1229           b    ctape
1230           nop  tdfeoj
1231           b    2465
1232 tdfeoj    dcw  cchalt
1233           rtw  1,2210
1234 cbsp1x    dcw  @11@
1235 *
1236           ltorg*
1237 gmovl4    dcw  @}@
1238           ex
1239           job  1401 autocoder - pass 2 - alter assembly - version 3   3728l
1240 *
1241 *   area definitions
1242 *
1243           sfx  b
1244           org  1
1245           da   1x86     main
1246           equ  *        lmain
1247           org  87
1248           dcw  000      index1
1249           dc   00
1250           dcw  000      index2
1251           dc   00
1252           dcw  000      index3
1253           dc   00
1254           org  100
1255           dc   @}@
1256           da   1x86     input
1257           dc   @}@       liput&1
1258           dc   0        zerox
1259           dc   0        cardsx
1260           dcw  @***@    hldsbx
1261 *
1262 *         initialization
1263 *
1264           org  101
1265 voice     cs   calltx
1266           cs
1267 iocalt    cs   lmainx
1268           b    ctapex
1269           nop  tdfio5
1270           bce  ioceof,mainxx&73,n
1271           b    yours
1272 tdfio5    dcw  &ioceof
1273           rt   5,mainxx
1274 ioceof    mcw  @1@,happyx&4
1275           mcw  @/086@
1276           b    okay
1277 string    cs   lmainx
1278           b    ctapex
1279           nop  tdfio5
1280           b    happyx&5
1281           ltorg*
1282 *
1283 *   parameter table
1284 *
1285           org  201
1286           da   1x266
1287                261,266  partbb
1288 *
1289 *    process ex
1290 *
1291 okay      sbr  switch&3,cmaltb
1292 exset     c    calltx,blanks-2    Q. any calls
1293           be   preem
1294 altsa     b    surexx
1295           b    preem
1296 lorgs     c    calltx,blanks-2    q. any calls
1297           bu   haulit
1298 preem     b    cards
1299 *
1300 *     input routine
1301 *
1302 cmalt     bss  lstcd,c            q.  no alters
1303           bss  lstcd,a            q. no more alters
1304           cs   lmainx
1305           r
1306 cards     sbr  preem&3,sbrotx
1307           mcw  @scr@,charcr
1308           mcw
1309           mcw
1310 yours     c    mainxx&17,@alt@
1311           bce  tread,mainxx&5,*
1312           bu   tread
1313           s    index1&1
1314           b    scanxx
1315           za   mainxx&18&x1,hlda1#4
1316 altr4     b    ctapex             get next record
1317           nop  tdfral
1318           mcw  @r@,outptx&84
1319           sw   loputx&1
1320           c    outptx&83,hlda1
1321 caltr     be   altr3              q. alter number equal to
1322           c    outptx&17,@end@    number on alter card
1323           be   endst              no. write tape
1324           b    ctapex
13245          sfx  x
1325           nop  tdf6
13255          sfx  b
1326           b    altr4
1327 altr3     bce  altr5,mainxx&19&x1,,
1328           b    ctapex            q. deletion
13285          sfx  x
1329           nop  tdf6
13295          sfx  b
1330           b    switch
1331 altr5     b    scanxx
1332           za   mainxx&18&x1,hlda1
1333 altr6     c    outptx&83,hlda1
1334           be   macro             delete until second alter
1335           b    ctapex            number is reached
1336           nop  tdfral
1337           b    altr6
1338 lstcd     mcw  @n@,caltr
1339           b    altr4
1340 *
1341 *              major processing
1342 *
1343 tread     sw   1
1344           sbr  brnchx&3,switch
1345           bce  homexx,mainxx&5,*
1346           c    mainxx&17,@mlc@
1347           be   homexx
1348           c    mainxx&17,@cha@
1349           be   chainx
1350           c    mainxx&17,@ent@   q. enter card
1351           be   entst
1352 swma1     c    mainxx&17,@ma @   q. modify address macro
1353 swma2     be   masetx
1354           c    mainxx&17,@ex @   q. ex card
1355           be   exset
1356           c    mainxx&17,@end@   q. end card
1357           be   endstx
1358           c    mainxx&18,whoops  q. call statement
1359           be   callnx
1360           c    mainxx&19,incldx
1361           be   callnx
1362           c    mainxx&19,litorg-1
1363           be   lorgs
1364           sbr  index3,tablei     q. get, put, open or close
1365 comioc    c    mainxx&17,0&x3
1366           sbr  index3
1367           be   msubtx
1368           bce  outioc,0&x3,#
1369           b    comioc
1370 outioc    bce  homexx,mainxx&19,
1371           bce  homexx,mainxx&15,
1372           b    msubtx            no, macro
1373 *
1374 *     process fixed form record
1375 *
1376 entst     b    sbrotx
1377           r
1378           bce  entst,mainxx&7,*
1379           c    mainxx&15,@end@   q. end card
1380           be   endstx
1381           c    mainxx&15,@ent@   q. new mode
1382           bu   entst
1383           b    preem
1384 tdfral    dcw  000
1385           dcw  @m%u4i12r@
1386 *
1387 *    delete entire macro
1388 *
1389 macro     bce  outmc,outptx&74,r
1390           b    switch
1391 outmc     b    ctapex
1392           nop  tdfral
1393           c    outptx&19,blanks
1394 mcout     be   outmc
1395           mcw  @n@,mcout
1396           bce  outmc,outptx&74,s
1397           bce  outmc,outptx&74,c
1398           bsp  4
1399           mcw  outmc,mcout
1400           b    cmalt
1401 *
1402 *   process end card
1403 *
1404 endst     mcw  loputx,lmainx
1405           b    endstx
1406           ltorg*
1407 gm2xxx    dcw  @}@
1408 nuorig    equ  *&1
1409           ex
1410           job  1401 autocoder - pass 2 - initial assembly version 3   3727l
1411 *
1412 *        area definition
1413 *
1414           sfx  a
1415           org  1
1416 mainxx    da   1x86
1417           org  87
1418           dcw  @000@
1419           dc   00
1420           dcw  @000@
1421           dc   00
1422           dcw  @000@
1423           dc   00
1424           org  101
1425           da   1x86           inputx
1426 liputx    equ  *
1427           dc   @}@
1428 zeroxx    dc   0
1429 cardsx    dc   0
1430 hldsbx    dcw  @***@
1431 *
1432 *    initialization
1433 *
1434           org  100
1435           dc   @}@
1436 start     cs   calltx
1437           cs
14371          bce  *&5,cardsx,1
14372          b    red
14373          mcw  @n@,rho&1
14374          mcw  @n@,tsten&5
1438 red       sw   ntper&4
1439           sw   tsten&4
1440           sw   outs2&4
1441           bce  readt,iocsav-3,*
1442           mcw  @n@,swma1
1443           mcw  @n@,swma2
1444           b    readt
1445           org  201
1446           da   1x266
1447 partbx         261,266
1448 *
1449 *   major processing
1450 *
1451 readt     b    twedb              get next record
1452 tread     sw   1
1453           sbr  brnchx&3,readt
1454           bce  outs2,mainxx&5,*   q, comments card
1455           c    mainxx&19,@chain@
1456           be   chainx
1457           c    mainxx&19,@mlcwa@
1458           be   outs2
1459           c    mainxx&17,@ent@    q. enter card
1460           be   entst
1461 swma1     c    mainxx&19,@ma   @  q. modify address macro
1462 swma2     be   masetx
1463           c    mainxx&19,@ex   @  q. ex card
1464           be   exset
1465           c    mainxx&17,@end@    q. end card
1466           be   endstx
1467           c    mainxx&18,whoops
1468           be   callnx             q. call statement
1469           c    mainxx&19,incldx
1470           be   callnx
1471           c    mainxx&19,@ltorg@
1472           be   lorgs              q. ltorg card
1473           sbr  index3,tablei
1474 few       c    mainxx&17,0&x3
1475           sbr  index3
1476           be   msubtx
1477           bce  many,0&x3,#
1478           b    few
1479 many      bce  outs2,mainxx&19,
1480           bce  outs2,mainxx&15,
1481           b    msubtx             no. macro
1482 *
1483 *     input routine
1484 *
1485 twedb     sbr  twdb1&3
1486           cs   lmainx
1487           b    rtwed
1488 chart     c
1489           bss  eof4,a             q. last card
1490           r
1491           ssb  twdb1,1
1492 rtwed     b    ctapex
1493           nop  tdf4
1494           bce  change,mainxx&73,n
1495 twdb1     b    tread
1496 tdf4      dcw  &eof4
1497           dcw  @m%u5001r@
1498 change    cw   chart,tsten&4
1499           mn   @4@,tdf4&4
1500           cw   outs2&4,ntper&4
1501           c    calltx,blank
1502           be   hooha
1503           b    surexx
1504 hooha     mcw  @scr@,charcr
1505           mcw
1506           mcw
1507           b    twdb1
1508 *
1509 *     read release
1510 *
1511 outs2     bss  outsbx,c
1512 rho       nop
1513           mcw  @8@,rho
1514           b    outsbx
1515 *
1516 *    fixed form records
1517 *
1518 tsten     bss  entst,c            q. tape input
1519           srf                     no. start rad feed
1520           sbr  nosir&3,antst
1521           mcw  @n@,but1xx
1522 entst     b    sbrotx
1523           b    twedb
1524 antst     mcw  @b@,but1xx
1525           sbr  nosir&3,tread
1526           bce  tsten,mainxx&7,*
1527           c    mainxx&15,@end@    q. end card
1528           be   endstx
1529           c    mainxx&15,@ent@    q. new mode
1530           bu   tsten
1531           b    sbrotx
1532           b    readt
1533 *
1534 *    process ex
1535 *
1536 exset     c    calltx,blank#3     q. any calls
1537           be   outs2
1538           b    surexx
1539           b    sbrotx
1540           b    readt
1541 *
1542 *    read release redundancy routine
1543 *
1544 ntper     bss  yesir,c            q. tape input
1545           r
1546           ss   1
1547           mcw  @n@,rho
1548 yesir     sbr  comets&3,crwred
1549           sbr  cconpr&3,nosir
1550           b    crwred
1551 nosir     b    tread
1552 *
1553 *     process ltorg
1554 *
1555 lorgs     c    calltx,blank       q. any callls
1556           bu   haulit
1557           b    outs2
1558 eof4      cs   lmainx
1559           sw   1
1560           mcw  @end$$$@,mainxx&18
1561           b    endstx
1562 antper    dcw  &ntpera
1563 acrwed    dcw  &crwred
1564           ltorg*
1565 *
1566 *   main line processing annex
1567 *
1568           sfx  x
1569           org  nuorig
1570 eof1b     rwd  1
1571           s    prevs
1572           b    switch
1573 *
1574 *   process lozenged field  6 - 20
1575 *
1576 lozeng    bm   mlblz,mainx&2&x1   q. internal level
1577           b    label
1578           mcw  blanks,mainx&4&x1
1579           mcw  index1,savx1#3
1580           mcw  index3,index2
1581           b    sbgrd
1582           a    savx1,index1
1583           mcw  0&x3,mainx&x1
1584           mcw  savx1,index1
1585           b    upengl
1586 *
1587 *   locate parameters
1588 *
1589 label     sbr  lexit&3
1590           mcw  blanks#5,index3
1591           mcw  blanks,cntp
1592           mn   mainx&1&x1,cntp
1593 circl     s    &1,cntp
1594           bm   tensr,cntp
1595           a    @3@,index3
1596           b    circl
1597 tensr     bce  chzon,dectb-2&x3,0
1598           mcw  blanks,cntp#1
1599           mcw  dectb&x3,index3
1600           mn   mainx&2&x1,cntp
1601 movinp    s    &1,cntp
1602           mcw  0&x3,0&x3
1603           sar  warea#3
1604           bce  chzon,0&x3,,       q. missing parameter
1605           bm   putin,cntp         q. parameter located
1606           mcw  warea,index3
1607           b    movinp
1608 putin     bce  chzon,0&x3,;
1609           bwz  delet,mainx&2&x1,s
1610 lexit     b    0
1611 *
1612 *    process ltorg
1613 *
1614 haulit    mcw  @org  @,mainx&19   replace ltorg with org
1615           mcw  @l@,mainx&74
1616           b    sbrot
1617           b    exitc
1618           cs   lmain
1619           mcw  litorg,mainx&20    generate ltorg*
1620           mcw  charcc,mainx&74
1621           b    whyyy
1622 *
1623 *              preparation for ltorg,ex,ex or iocs
1624 *
1625 surex     sbr  simple&3
1626           sw   1
1627           cs   liputx
1628           lca  lmainx,liputx
1629           b    exitcx
1630           lca  liputx,lmainx
1631 simple    b    0
1632 tdfext    dcw  &rwdext
1633           dcw  @m%u1001r@
1634 litorg    dcw  @ltorg*@
1635 *
1636 *   iocs table
1637 *
1638           dcw  @#@
1639           dcw  @rls@
1640           dcw  @get@
1641           dcw  @put@
1642           dcw  @dtf@
1643 tablei    dcw  @ope@
1644 *
1645 *  generate unknown macro card
1646 *
1647 norot     sbr  nrotc&3
1648           cs   lmainx
1649           mcw  @b@,mainx&85
1650           mcw  @unknown@,mainx&19
1651           mcw  charcc,mainx&74
1652           mcw  @*@,mainx&5
1653 nrotc     b    0
1654 pots      mcw  @b@,switch
1655           mcw  @n@,nextcd
1656           b    cooker
1657 *
1658 *   modify address macro
1659 *
1660 maset     mcw  charcr,mainx&74
1661           b    sbrotx
1662           mcw  @d@,mainx&17
1663           b    sgc
1664 incldx    dcw  @incld@
1665 charcs    dcw  @z@
1666 charcc    dcw  @y@
1667 charcr    dcw  @w@
1668 kings     b    norot
1669           mcw  hldsb,mainx&10
1670           b    whyyy
1671 endstx    b    ctape
1672           nop  tdf5
1673           b    ovly4i
1674 dectb     dcw  &partb
1675           da   9x3
1676 enddc     equ  *
1677 movec     lca  @;@,0&x3
1678           sbr  index3
1679           a    @3@,index2&1
1680           bce  midle,index2&1,3
1681 lower     a    @1@,index1
1682           sw   mainx&20&X1
1683           bce  movec,mainx&20&x1,,
1684 weedd     mcw  index2&1,iocsav
1685           b    weedbx
1686           mcw  iocsav,index2&1
1687           b    comsn
1688 tdf5      dcw  #3
1689           rtw  5,ovly4i
1690 newest    dc   0
1691 symnm     dcw  @000@
1692 whoops    dcw  @call@
1693 addcal    dcw  &calltx
1694           ltorg*
1695           org  1649
1696 gm1       dcw  @}@
1697           ex
1698           job  1401 autocoder - pass 2 - macro-generator- version 3   3726l
1699           sfx  x
1700 *
1701 *   generalized tape input/output routine
1702 *
1703           org  1650
1704 ctapex    sbr  index2
1705           sbr  cconpr&3
1706           mcw  3&x2,index2
1707           mcw  8&x2,ctapec&7
1708           mcw  0&x2,ceorc&3
1709           sw   ccompr&4
1710           mcw  7&x2,ccompr&6
1711           a    @12@,ccompr&6
1712           cw   ccompr&4
1713           mn   ctapec&3,chalt&6
1714           mn   ctapec&7,chalt&6
1715           mcw  @9@,cerrct#1
1716 ctapec    rt   0,0
1717           bce  comets,ctapec&7,w
1718 ceorc     bef  0
1719 ccompr    bce  ctapec,0,}
1720           b
1721           b
1722           b
1723           b
1724           b
1725           b
1726           b
1727           b
1728           b
1729           b
1730           b
1731 comets    ber  crwred
1732 cconpr    b    0
1733 crwred    s    @1@,cerrct
1734           mn   ctapec&3,*&4
1735           bsp  0
1736           bce  ctrow,ctapec&7,w
1737           bm   chalt,cerrct
1738           b    ctapec
1739 ctrow     a    @1@,cerasc#2
1740           skp  6
1741           bce  cchalt,cerasc-1,5
1742           b    ctapec-7
1743 cchalt    s    cerasc
1744           h    0,202
1745           b    ctapec-7
1746 chalt     h    0,200
1747           bss  ctapec-7,e
1748           mcw  ctapec&7,*&8
1749           rt   0,0
1750           h    0,201
1751           b    cconpr
1752 headr     dcw  @headr@
1753           ltorg*
1754 *
1755 *   initialization
1756 *
1757           org  1900
1758 startx    mcw  340,iocsav
1759           mcw
17595          mcw  nordrl,hole#1
1760           b    ctape
1761           nop  tdfss
1762           cw   gm1
1763           sw   3998
1764           mcw  liput&1,3998
1765           cw   3995,3997
1766           bss  alterx,b
1767           rwd  1
17675          mcw  hole,cardsx
1768           b    starta
1769 tdfss     dcw  &cchalt
1770           dcw  @l%u1001r@
1771 alterx    b    ctapex
1772           nop  tdfss
1773           cw   gm2xxx
1774           rwd  1
1775           mcw  iocsav,symnm
1776           mcw  &iocalt,switch&3
1777           sbr  happy&3,string
1778           mcw  @n@,outsb
1779           mcw  @n@,but1x
1780           mcw  @n@,but2x
1781           bce  voiceb,iocsav-3,*
1782           mcw  @n@,swma2b
1783           b    voiceb
1784           ltorg*
1785           org  1900
1786           da   1x174
1787 callt     equ  *
1788 *
1789 *  process missing parameters with regard to zone
1790 *
1791 chzon     bwz  slash,mainx&2&x1,s
1792           bwz  delet,mainx&2&x1,b
1793           mcw  @b@,mainx&85
1794 zonbr     cw   mainx&x1,mainx&3&x1
1795 zonch     b    defnd
1796 slash     mcw  blanks-2,mainx&2&x1
1797           b    zonbr
1798 subset    mcw  @n@,switch
1799           mcw  @b@,nextcd
1800           mcw  charcs,mainx&74
1801           b    calit
1802 masks     mcw  @b@,nocal
1803 *
1804 *  processing call statement
1805 *
1806 calln     mcw  charcr,mainx&74
1807 calit     mcw  addcal,index2      begin scan of call table
1808           sw   mainxx&20
1809 yscalx    bce  xxxx,index2-2,y    q. call table exceeded
1810           c    0&x2,@   @
1811           be   spadex
1812           c    0&x2,mainx&22
1813           sar  index2
1814           be   queen
1815           b    yscalx
1816 spadex    mcw  mainx&22,0&x2
1817 queen     cw   mainxx&20
1818 nocalx    nop  skelcx
1819           b    sbrot
1820           bce  switch,mainx&19,d  q. incld statement
1821 *
1822 *   load parametes into table
1823 *
1824           mcw  mainx&10,partb
1825           sbr  index3
1826           s    index1&1
1827 dimndx    b    scanxx
1828           sw   1
1829           lca  mainx&18&x1,0&x3
1830           sbr  index3
1831           bce  heartx,mainx&19&x1,
1832           bce  weedbx,mainx&19&x1,,
1833           b    dimndx
1834 xxxx      mcw  @7@,mainx&85
1835 whyyy     b    sbrot
1836 switch    b    readta
1837           b    pots
1838 *
1839 *   generate branch and dcw,s
1840 *
1841 heartx    lca  @ @,0&x3
1842           cs   lmainx
1843           mcw  partb,mainx&10
1844           mcw  partb-6,mainx&24
1845           sar  index3
1846           mcw  @b@,mainx&15
1847 slam      mcw  charcc,mainx&74
1848           mcw  index3,savxl2#3
1849           mcw  savxl2,index3
1850           cw   mainx&23
1851           b    sbrot
1852           cs   lmainx
1853           bce  switch,0&x3,
1854           mcw  @dcw@,mainx&17
1855           mcw  index3,index2
1856           b    sbgrdx
1857           mcw  0&x3,mainx&20&x1
1858           sar  index3
1859           b    slam
1860 *
1861 *     scan for comma, two blanks, or an @
1862 *
1863 scanxx    sbr  clubs&3
1864 scanl     sw   mainx&20
1865           bce  scnat,mainx&20&x1,@
1866           bce  cetwms,mainx&20&x1,,
1867           c    mainx&20&x1,@  @
1868           be   clubs
1869 cxit1     a    @1@,index1
1870           c    index1,@52@
1871           bu   scanl
1872           c    mainx&71,@  @
1873           be   clubs
1874           bce  clubs,mainx&71,
1875           b    cxit
1876 cetwms    sw   mainx&21&x1
1877 cxit      a    @1@,index1
1878 clubs     b    0
1879 scnat     za   @510@,index1&1
1880 atlok     bce  cxit1,mainx&20&x1,@
1881           s    &10,index1&1
1882           b    atlok
1883 *
1884 *  obtain more parameters from additional records
1885 *
1886 weedbx    sbr  wedxt&3
1887           b    neweed
1888 weddbx    a    @1@,index1
1889 neweed    c    index1,@52@
1890           bu   loopw
1891 nextcd    nop  callcd
1892 happy     b    twedba             read next record
1893           nop
1894           mcw  charcr,mainx&74
1895 thru      b    sbrotx
1896           bce  happy,mainx&5,*
1897           s    index1&1
1898           bce  movec,mainx&20,,   q. first parameter missing
1899 loopw     bce  weddbx,mainx&20&x1,
1900           sw   mainx&20&x1
1901 wedxt     b    0
1902 tdf6      dcw  &cchalt
1903           dcw  @m%u6I12w@
1904 *
1905 *   output routine
1906 *
1907 sbrotx    sbr  brnch&3
1908 but1x     b    homex
1909 outsb     mcw  antper,comets&3
1910 homex     mcw  lmain,loput
1911           bce  but2x,outpt&73,*
1912           mcw  blanks-3,outpt&73
1913           sw   loput&1
1914           mcw  liput&1,loput&1
1915           b    ctapex
1916           nop  tdf6
1917 but2x     mcw  acrwed,comets&3
1918 brnch     b    0
1919 *
1920 *  process parameters for substitution
1921 *
1922 msubtx    mcw  @r@,mainx&74
1923           b    sbrotx
1924           a    @1@,symnm
1925 sgc       mcw  mainx&17,hldsb
1926           s    enddc
1927           chain8
1928           s    index2&2
1929           a    @3@,index2&1
1930           mcw  mainx&10,partb
1931           sbr  index3
1932           s    index1&1
1933           bce  btrend,mainx&20,
1934           bce  movec,mainx&20,,
1935 comsn     a    @3@,index2&1
1936           bce  above,index2&1,3
1937 below     b    scanxx
1938           lca  mainx&18&x1,0&x3
1939           sbr  index3
1940           bce  movec,mainx&20&x1,,
1941           bce  weedd,mainx&19&x1,,
1942 btrend    lca  @,@,0&x3
1943           cs   lmainx
1944           c    prevs#3,hldsb
1945           mcw  @999@,prevs
1946           be   harmn
1947           bh   rdtp1
1948 eof1      rwd  1
1949 *
1950 *              substitutions
1951 *
1952 rdtp1     sw   100
1953           b    ctape
1954           nop  tdflib
1955           c    mainx&19,headr
1956           bu   rdtp1
1957           c    mainx&7,@999@
1958           be   kings
1959           c    mainx&7,hldsb
1960           bu   rdtp1
1961           b    harmn
1962 skelc     mcw  @n@,nocal
1963           mcw  charcs,mainx&74
1964           b    sbrot
1965           bce  harmn,mainx&19,d
1966           mcw  @b    @,mainx&19
1967 bouts     cw   zerox
1968           mcw  charcc,mainx&74
1969           b    sbrotx
1970 harmn     cs   lmainx
1971           sw   1,100
1972           mcw  liput&1,100
1973           b    ctapex
1974           nop  tdflb2
1975           c    mainx&19,headr
1976           mcw  mainx&7,prevs
1977           be   switch
1978           c    mainx&7,@)00@
1979           bu   lzfnd
1980           sw   zerox
1981 *
1982 *  right to left scan for lozenges
1983 *
1984 lzfnd     za   @690@,index1&1
1985 lozsc     bce  lzcnt,mainx&x1,)
1986 defnd     s    &10,index1&1
1987           c    index1,@15@
1988           bu   lozsc
1989           s    index1&1
1990 cleanc    b    scanxx
1991           cw   mainx&20,mainx&20&x1
1992           c    index1,@51@
1993           bl   endcln
1994           c    mainx&20&x1,@  @
1995           bu   cleanc
1996           bce  endcln,mainx&5,*
1997           sw   mainx&20&x1
1998           mcw  blanks-4,mainxx&71
1999           mcw  mainxx&71
2000           cw   mainxx&20&x1
2001 *
2002 *   right to left scan for lozenges  6 - 20
2003 *
2004 endcln    mcw  @015@,index1
2005           sbr  zonch&3,upengl
2006 engloz    bce  lozeng,mainx&x1,)
2007 upengl    s    &10,index1&1
2008           c    index1,@04@
2009           bu   engloz
2010 outsd     sbr  zonch&3,defnd
2011 shiftl    nop  partb,mainx&10
2012           mcw  @n@,shiftl
2013           c    mainx&18,whoops
2014           be   masks
2015           c    mainx&19,incld
2016           be   masks
2017           b    bouts
2018 tdflib    dcw  &kings
2019           dcw  @m%u1001r@
2020 tdflb2    dcw  &eof1b
2021           dcw  @m%u1001r@
2022 *
2023 *   process lozenged fields  21  -  72
2024 *
2025 lzcnt     bce  defnd,mainx&1&x1,
2026           sw   mainx&x1,mainx&3&x1
2027           bm   systm,mainx&2&x1
2028           b    label
2029           mcw  index3,savx3#3
2030           s    index3,warea
2031           mz   blanks,warea
2032           mcw  @i99@,index3
2033           s    warea,index3
2034           mcw  @i@,index3-2
2035           c    index3,@i9f@
2036           bl   sptyp
2037           mcw  mainx&76&x3,mainx&72
2038           sbr  move3&6
2039 lmn       cw   mainx&3&x1
2040           mcw  savx3,index3
2041 move3     mcw  0&x3,0
2042           cw   mainx&x1
2043           b    defnd
2044 systm     mcw  mainx&68,mainx&71
2045           mcw  symnm
2046           cw   mainx&x1,mainx&3&x1
2047           b    defnd
2048 *
2049 *  specialized processing of one and two character operands
2050 *
2051 sptyp     lca  mainx&72,outpt&72
2052           cw   mainx&x1,mainx&3&x1
2053           mcw  blanks-2,mainx&71
2054           bce  house,index3,h
2055           mcw  outpt&72,mainx&71
2056           sbr  move3&6
2057           b    spout
2058 house     mcw  outpt&72,mainx&70
2059           sbr  move3&6
2060 spout     cw   outpt&3&x1
2061           b    lmn
2062 delet     bw   lblmv,zerox
2063           b    harmn
2064 lblmv     mcw  @m@,shiftl
2065           cw   zerox
2066           b    harmn
2067 mlblz     mcw  symnm,mainx&10
2068           b    outsd
2069 *
2070 *  pull in called routines at ltorg, end or execute cards
2071 *
2072 exitc     sbr  cexit1&3
2073 rwdext    rwd  1
2074 cwprc     cw   newest
2075 tprd1     sw   100
2076           mcw  liput&1,100
2077           b    ctapex
2078           nop  tdfext
2079           c    mainx&19,headr
2080           bu   tprd1
2081 solut     c    mainx&7,@999@
2082           be   eof1a
2083 oppent    mcw  addcal,index1
2084 prtner    bce  tprd1,index1-2,y
2085           sw   mainx&5
2086           c    0&x1,mainx&7
2087           sar  index1
2088           bu   prtner
2089           bw   tprd1,1&x1
2090           cw   mainx&5
2091           sw   1&x1
2092           sw   newest
2093 cooker    b    ctapex
2094           nop  tdfext
2095           c    mainx&18,whoops
2096           be   subset
2097           c    mainx&19,incld
2098           be   subset
2099           c    mainx&19,headr
2100           be   solut
2101           mcw  charcc,mainx&74
2102           lca  loput&1,100
2103           b    sbrot
2104           b    cooker
2105 eof1a     mcw  addcal,index1
2106 combl     bce  cexit,index1-2,y
2107           c    0&x1,@   @
2108           sar  index1
2109           be   cexit
2110           bw   combl,1&x1
2111           bw   rwdext,newest
2112 *
2113 *  create comments card for unknown  subroutines
2114 *
2115 unknwn    b    norot
2116           sw   1&x1
2117           mcw  3&x1,mainx&10
2118           b    sbrot
2119           b    combl
2120 cexit     cs   callt
2121           cs
2122           cw   100
2123           mcw  @999@,prevs
2124 cexit1    b    0
2125 sbgrd     sbr  grand&3
2126           s    index1&1
2127 grand     bw   0,0&x2
2128           s    @10@,index2&1
2129           a    @1@,index1
2130           b    grand
2131 callcd    cs   lmainx
2132           b    ctape
2133           nop  tdfext
2134           mcw  charcs,mainx&74
2135           sw   1
2136           b    thru
2137 iocsav    dcw  #4
2138 chainx    mcw  @r@,mainx&74
2139           b    whyyy
2140 midle     mcw  index3,dectb&x2
2141           b    lower
2142 above     mcw  index3,dectb&x2
2143           b    below
2144           ltorg*
2145 *
2146 *  output area
2147 *
2148           org  3912
2149 outpt     da   1x86,g
2150 loput     equ  *-1
2151           ex
2152           end  start
