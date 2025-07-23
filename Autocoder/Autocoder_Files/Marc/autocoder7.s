 101 000       job  1401 autocoder-pass 7-list,condns-initl 1 -version 3   3771l
 102           ctl  630 1
 103 *
 104 * equaters used by the program
 105 *
 106 initap    equ  %u0
 107 systap    equ  %u1
 108 origtp    equ  %u4
 109 worktp    equ  %u5
 110 xtratp    equ  %u6
 111 fixfrm    equ  0
 112 stlabl    equ  fixfrm&2
 113 ststmt    equ  fixfrm&5
 114 count     equ  fixfrm&7
 115 orgadd    equ  fixfrm&32
 116 labadd    equ  fixfrm&61
 117 supadd    equ  fixfrm&66
 118 op        equ  fixfrm&67
 119 aop       equ  fixfrm&70
 120 bop       equ  fixfrm&73
 121 dmod      equ  fixfrm&74
 122 type      equ  fixfrm&75
 123 alter     equ  fixfrm&80
 124 xxxx      equ  0
 125 print     equ  200
 126 alt       equ  print&4
 127 pg        equ  print&7
 128 lin       equ  print&11
 129 lab       equ  print&19
 130 opcode    equ  print&25
 131 oprand    equ  print&78
 132 suffix    equ  print&80
 133 ct        equ  print&84
 134 locn      equ  print&90
 135 inop      equ  print&93
 136 inaop     equ  print&97
 137 inbop     equ  print&101
 138 indmod    equ  print&103
 139 kind      equ  print&109
 140 cardno    equ  print&114
 141 punch     equ  100
 142 librn     equ  0
 143 zone      equ  189
 144 xr1       equ  89
 145 xr2       equ  94
 146 xr3       equ  99
 147 *
 148 * initialization routine
 149 *
 150           org  1900
 151 ssop      dcw  @b@
 152           cs   332
 153           cs
 154           cs
 155           cs
 156           rtw  systap,400
 157           nop  xxxx
 158           ber  tperri
 159           cw   endin2,lstop1
 160           sw   endin
 161           lca  endin,333
 162           lca  endin,181
 163           mcw  ssop,tstsiz
 164           mcw  ssop,ssave1
 165           cw   endin
 166           rwd  origtp
 167           rwd  worktp
 168           rwd  xtratp
 169           sw   punch&72,punch&76
 170           a    &1,punch&75
 171           b    read4
 172 *
 173 * check for job card
 174 *
 175           c    mnemon-2,@job@
 176           bu   ckctl
 177           cw   jobsw#1
 178           rt   worktp,180
 179           lca  333,181
 180           mcw  opernd,jobsav
 181           mcw  image&80,punch&80
 182           mcw  altno,jobalt#4
 183           mcw  pageno,jobpag#2
 184           mcw  lineno,joblin#3
 185           mcw  label,joblab#6
 186           b    read4
 187 *
 188 * check for control card
 189 *
 190 ckctl     c    mnemon-2,@ctl@
 191           bu   tstsiz
 192           cw   ctlsw#1
 193           mcw  image&30,ctlsav#10
 194           mcw  altno,ctlalt#4
 195           mcw  pageno,ctlpag#2
 196           mcw  lineno,ctllin#3
 197           b    read4
 198 *
 199 * test output options desired
 200 *
 201 chkop     bce  opntap,lstape,1
 202 tstop     bce  tstsiz,outopn,0
 203           bce  condop,outopn,1
 204           bce  tstsiz,outopn,2
 205           bce  condop,outopn,3
 206           bce  tstsiz,outopn,4
 207           bce  condop,outopn,5
 208           bce  tstsiz,outopn,6
 209           bce  condop,outopn,7
 210           bce  tstsiz,outopn,
 211           cw   ctlsw1#1
 212           b    tstsiz
 213 opntap    cw   tapop1
 214           b    tstop
 215 *
 216 * setup & get main program
 217 *
 218 getman    bsp  origtp
 219           sw   fixfrm&1,fixfrm&6
 220           sw   fixfrm&8,fixfrm&14
 221           sw   fixfrm&23,fixfrm&57
 222           sw   fixfrm&62,fixfrm&67
 223           sw   fixfrm&68,fixfrm&71
 224           sw   fixfrm&74
 225           cw   181,333
 226           mcw  kblk1,holda1-1
 227           lca  @l0     ,      ,      ,      1   @,punch&71
 228           lca  @2skb@,zone
 229           lca  @00000@,xr3&2
 230           lca  xr3&2
 231           lca
 232           sw   grpmk3
 233           bce  setout,cndsw1,1
 234           bw   *&5,lstop1
 235           b    setout
 236           bw   *&5,tapop1
 237           b    setout
 238           mcw  @1@,noout1
 239 setout    mcw  outopn,opnsv1
 240           wtw  xtratp,savcn1
 241           nop  xxxx
 242           ber  tperri
 243           rwd  xtratp
 244           cw   grpmk3
 245           rtw  systap,201
 246           nop  xxxx
 247           ber  tperri
 248           b    init2
 249 *
 250 * tape redundancy routine
 251 *
 252 tperri    sbr  xr2
 253           sbr  redxi&3
 254           mz   &9,xr2
 255           mcw  4000-10&x2,tpinsi&7
 256           mn   tpinsi&3,bspi&3
 257           mcw  tpinsi&7,inst2i&7
 258 bspi      bsp  initap
 259           bce  wrtrdi,tpinsi&7,w
 260           mcw  &9,readci#1
 261 tpinsi    rt   initap,xxxx
 262           ber  rdreri
 263 redxi     b    xxxx
 264 rdreri    mn   tpinsi&3,bsp2i&3
 265 bsp2i     bsp  initap
 266           s    &1,readci
 267           bwz  tpinsi,readci,b
 268           mn   tpinsi&3,tphali&6
 269 tphali    h    xxxx,790
 270           mcw  tpinsi&7,*&8
 271           rt   initap,xxxx
 272           bss  bspi,e
 273           h    xxxx,711
 274           b    redxi
 275 wrtrdi    skp  systap
 276           bce  subcti,wrtcti-1,5
 277           a    &1,wrtcti#2
 278 inst2i    wt   initap,xxxx
 279           ber  bspi
 280           b    redxi
 281 subcti    s    wrtcti
 282           mn   tpinsi&3,*&7
 283           h    xxxx,760
 284           b    inst2i
 285 clrleg    dcw  @clear storage @
 286 holda1    dcw  &0000
 287 kblk1     dcw  @080@
 288 corsiz    dcw  @ 3999@
 289 cndsw1    dcw  @0@
 290 jobsav    dcw  #52
 291 errct1    dcw  @0000@
 292 opnsv1    dcw  @ @
 293 ssave1    dcw  @ @
 294 tapop1    dcw  @ @
 295 lstop1    dcw  @ @
 296 noout1    dcw  @ @
 297 grpmk3    dc   @}@
 298 savcn1    equ  holda1-3
 299           ltorg*
 300           org  3831
 301 input4    da   1x86
 302 pageno         1,2
 303 lineno         3,5
 304 label          6,11
 305 mnemon         16,20
 306 opernd         21,72
 307 altno          81,84
 308 image     equ  input4-1
 309 fixinp    equ  image&87&x3
 310 input5    equ  fixinp&1&x0
 311 prosiz    equ  ctlsav-9
 312 objsiz    equ  ctlsav-8
 313 outopn    equ  ctlsav-7
 314 lstape    equ  ctlsav-5
 315 endin     equ  3998
 316 3998      dcw  @}@
 317           xfr  librn
 318           job  1401 autocoder-pass 7-list,condns-initl 2 -version 3   3772l
 319           org  400
 320 *
 321 * condense option
 322 *
 323 condop    mcw  @1@,cndsw1
 324 *
 325 * test object machine size
 326 *
 327 tstsiz    bss  sensw,f
 328           bw   *&3,lstop1
 329           cc   1
 330           mcw  @1@,print&15
 331           mcw  clrleg
 332           mcw  @1@,200
 333           bw   is4k,ctlsw
 334           c    objsiz,@3@
 335           bl   over4k
 336           b    is4k
 337 over4k    c    objsiz,@6@
 338           bl   badctl
 339           mcw  @,053053n000000n00001026@,punch&52
 340           lca  @,008015,022026,030037,044,049@
 341           mcw  punch&52,print&72
 342           b    prtpnh
 343           mcw  @1,001/001117I0?@,punch&71
 344           mcw  @#071029c029056b026/b001/099@
 345           lca  @l068116,105106,110117b101/i9i@
 346           bce  is8k,objsiz,4
 347           bce  is12k,objsiz,5
 348           mcw  @15@,corsiz-3
 349           b    clrst2
 350 badctl    cw   ctlsw1
 351 is4k      mcw  @,0570571026@,punch&44
 352           lca  @,008015,019026,030,034041,045,053@
 353           mcw  punch&44,print&64
 354           b    prtpnh
 355           mcw  @b0010270b0261,001/001113I0@,punch&70
 356           lca  @l068112,102106,113/101099/I99,027a070028)027@
 357           bce  clrst2,objsiz,3
 358           mz   @s@,punch&27
 359           mcw  @1@,corsiz-3
 360           bce  clrst2,objsiz,2
 361           mcw  @t@,punch&27
 362           mcw  @3@,corsiz-2
 363           bce  clrst2,objsiz,1
 364           cw   ctlsw1
 365           mcw  @I@,punch&27
 366           mcw  @39@,corsiz-2
 367           b    clrst2
 368 is8k      mz   @s@,punch&29
 369           mcw  @7@,corsiz-3
 370           b    clrst2
 371 is12k     mz   @k@,punch&29
 372           mcw  @11@,corsiz-3
 373 clrst2    mcw  punch&71,print&91
 374           mcw  @2@,print&15
 375           mcw  clrleg
 376           b    prtpnh
 377           mcw  @,0010011040@,punch&71
 378           mcw  @,061068,072/061039@,punch&46
 379           lca  @,008015,022029,036040,047054@
 380           mcw  punch&71,print&91
 381           mcw  @bootstrap@,print&9
 382           b    prtpnh
 383           bw   *&3,lstop1
 384           cc   k
 385           bw   dohead,ctlsw
 386 *
 387 * test processor machine size
 388 *
 389           c    prosiz,@3@
 390           be   dohead
 391           bh   badpro
 392           c    prosiz,@6@
 393           bl   badpro
 394           mcw  @400@,kblk1
 395           bce  dohead,prosiz,4
 396           a    @400@,kblk1
 397           b    dohead
 398 badpro    cw   ctlsw1
 399 *
 400 * print heading, job & control cards
 401 *
 402 dohead    mcw  @1@,print&114
 403           mcw  @page@,print&109
 404           mcw  jobsav,oprand
 405           mcw  punch&80,locn
 406           mcw  @0@,200
 407           b    print2
 408           bw   *&3,lstop1
 409           cc   k
 410           cs   print&78
 411           mcw  @sfx ct  locn  instruction type  card@,print&114
 412           mcw  @seq pg lin  label  op    operands@,print&34
 413           mcw  @0@,200
 414           b    print2
 415           cs   print&132
 416           cs
 417           b    print2
 418           bw   tstctl,jobsw
 419           mcs  jobalt,alt
 420           mcs  jobpag,pg
 421           mz   jobpag,pg
 422           mcw  joblin,lin
 423           mcw  joblab,lab
 424           mcw  @job@,opcode-2
 425           mcw  jobsav,oprand
 426           b    print2
 427           cs   oprand
 428 tstctl    bw   nocntl,ctlsw
 429           mcs  ctlalt,alt
 430           mcs  ctlpag,pg
 431           mz   ctlpag,pg
 432           mcw  ctllin,lin
 433           mcw  ctlsav,print&36
 434           mcw  @ctl@,opcode-2
 435           bw   ctlpnt,ctlsw1
 436           mcw  @bad statement@,print&128
 437 errctl    a    &1,errct1
 438 ctlpnt    b    print2
 439           b    getman
 440 nocntl    mcw  @no control card@,print&130
 441           b    errctl
 442 print2    sbr  pnt2xt&3
 443           bw   *&2,lstop1
 444           w
 445           bw   pnt2xt,tapop1
 446           wt   3,200
 447           nop  xxxx
 448           ber  tperri
 449 pnt2xt    b    xxxx
 450 *
 451 * test sense switches for output options
 452 *
 453 sensw     lca  @0@,outopn
 454           lca  @0@,cndsw1
 455           mcw  @ @,lstape
 456           sw   tapop1
 457           bss  add1,b
 458 tstssc    bss  add2,c
 459 tstssg    bss  add4,g
 460 tstssd    bss  lstap,d
 461 tstsse    bss  suplst,e
 462 ssxt      cw   outopn
 463           mcw  @n@,tstsiz
 464           b    chkop
 465 add1      a    &1,outopn
 466           b    tstssc
 467 add2      a    &2,outopn
 468           b    tstssg
 469 add4      a    &4,outopn
 470           b    tstssd
 471 lstap     cw   tapop1
 472           b    tstsse
 473 suplst    sw   lstop1
 474           b    ssxt
 475 *
 476 * print and/or punch
 477 *
 478 prtpnh    sbr  exit&3
 479           mcs  punch&75,cardno
 480           bw   *&2,lstop1
 481           w
 482           bw   punch1,tapop1
 483           wt   3,200
 484           nop  xxxx
 485           ber  tperri
 486           mcw  @&@,100
 487           wt   3,100
 488           nop  xxxx
 489           ber  tperri
 490 punch1    bce  *&2,cndsw1,0
 491           p
 492           a    &1,punch&75
 493           cs   print&132
 494           cs
 495           cs   punch&71
 496 exit      b    xxxx
 497 *
 498 * read original tape
 499 *
 500 read4     sbr  read4x&3
 501           rt   origtp,input4
 502           b    chklg
 503           ber  tperri
 504 read4x    b    xxxx
 505 chklg     bce  read4&4,input4&12,}
 506           chain12
 507           b    read4x-5
 508           ltorg*
 509 endin2    dcw  @}@
 510           xfr  librn
 511           job  1401 autocoder-pass 7 process ex/end      -version 3   3775l
 512           org  isiocs
 513 *
 514 * ex, end cards
 515 *
 516 exend     mcw  @b@,inop
 517           mcw  @b@,holdh&1
 518           bce  setaop,type,c
 519           mcw  @/     080@,inbop
 520           mcw  @/   080@,holdh&7
 521 setaop    mcw  aop,inaop
 522           mcw  aop,holdh&4
 523           bce  symund,aop,#
 524           b    setloc
 525           b    condns
 526           b    prntln
 527           bce  getov1,type,c
 528           cc   1
 529           mcw  @1@,200
 530           mcs  errcnt,print&4
 531           c    print&4,blank4#4
 532           bu   seterh
 533 tstcor    bw   eojob,addrsw#1
 534           mcw  word1,print&20
 535           b    wtape
 536           bw   *&2,lstop
 537           w
 538 eojob     bw   reset,tapop
 539           wtm  3
 540           b    reset
 541 seterh    mcw  @errors@,print&11
 542           c    print&4,@   1@
 543           bu   *&8
 544           mcw  blank1,print&11
 545           b    wtape
 546           bw   *&2,lstop
 547           w
 548           cs   print&11
 549           b    tstcor
 550 *
 551 * condense ex, end cards
 552 *
 553 nocard    c    wmloc,awmstr
 554           be   tstend
 555           cw   newsw
 556 endrtn    bw   nocard,newsw
 557           b    pnchcd
 558 tstend    bce  excute,type,c
 559           cs   punch&71
 560           mcw  holdh&7,punch&46
 561           mcs  punch&75,cardno
 562           sbr  pnhxt&3,lstcd
 563           b    tstpch
 564 excute    mce  wmstr,punch&71
 565           mcw  @n000000@,punch&46
 566           mcw  holdh&4,punch&71
 567           mcs  punch&75,cardno
 568           sbr  pnhxt&3,exout
 569           b    tstpch
 570 *
 571 * punch compatibility cards
 572 *
 573 exout     cs   punch&71
 574           b    readog
 575           bsp  origtp
 576           c    mnemon-2,@job@
 577           bu   *&8
 578           mcw  image&80,punch&80
 579           mcw  word2,punch&39
 580           lca  word3,punch&66
 581           mcw  punch&66,punch&50
 582           bce  *&2,condsw,0
 583           p
 584           b    wtap2
 585           cs   punch&66
 586           a    &1,punch&75
 587           mcw  word4,punch&21
 588           mcw  word5,punch&71
 589           sbr  pnhxt&3,outex
 590           bce  *&2,condsw,0
 591           p
 592           b    wtap2
 593           b    newcrd
 594 lstcd     cs   punch&80
 595           bce  *&4,condsw,0
 596           p
 597           ss   8
 598 outex     b    cndout&7
 599 word1     dcw  @object core exceeded@
 600 word2     dcw  @,015022)024056,029036,040047,0540611001@
 601 word3     dcw  @,001008b001@
 602 word4     dcw  @,068072)063067/061039@
 603 word5     dcw  @,0010011040@
 604 ov2gm     dcw  @}@
 605           xfr  librn
 606           job  1401 autocoder-pass 7 left main line      -version 3   3773l
 607 *
 608 * read second half of main program
 609 *
 610           org  201
 611 init2     rtw  systap,2000
 612           nop  xxxx
 613           ber  tperr
 614           rtw  xtratp,savcon
 615           nop  xxxx
 616           ber  tperr
 617           rwd  xtratp
 618           cw   gmsave,wmsw#1
 619           cw   ende1,ende2
 620           sw   gm,181
 621           sw   ov1gm
 622           wtw  xtratp,isiocs
 623           nop  xxxx
 624           ber  tperr
 625           rwd  xtratp
 626           cw   ov1gm
 627           za   &5,linct
 628           bce  reset,noout,1
 629           b    get
 630           b    setup
 631           dcw  @ @
 632 *
 633 * main line program
 634 *
 635           org  333
 636 gm        dc   @}@
 637 *
 638 * tape redundancy routine
 639 *
 640 tperr     sbr  xr2
 641           sbr  redxt&3
 642           mz   plus9,xr2
 643           mcw  4000-10&x2,tpinst&7
 644           mn   tpinst&3,bsp1&3
 645           mcw  tpinst&7,inst2&7
 646 bsp1      bsp  initap
 647           bce  wrtred,tpinst&7,w
 648           mcw  plus9,readct
 649 tpinst    rt   initap,xxxx
 650           ber  rdrerr
 651 redxt     b    xxxx
 652 rdrerr    mn   tpinst&3,bsp2&3
 653 bsp2      bsp  initap
 654           s    plus1,readct
 655           bwz  tpinstm,readct,b
 656           mn   tpinst&3,tphalt&6
 657 tphalt    h    xxxx,790
 658           mcw  tpinst&7,*&8
 659           rt   initap,xxxx
 660           bss  bsp1,e
 661           h    xxxx,712
 662           b    redxt
 663 wrtred    skp  systap
 664           bce  subctr,wrtctr-1,5
 665           a    plus1,wrtctr
 666 inst2     wt   initap,xxxx
 667           ber  bsp1
 668           b    redxt
 669 subctr    s    wrtctr
 670           mn   tpinst&3,*&7
 671           h    xxxx,760
 672           b    inst2
 673 plus9     dcw  &9
 674 plus1     dcw  &1
 675 readct    dcw  #1
 676 wrtctr    dcw  #2
 677 *
 678 * get pass f
 679 *
 680 reset     lca  ssave,201
 681           lca
 682           rt   systap,332
 683           cw   181,333
 684           rtw  systap,2000
 685           nop  xxxx
 686           ber  tperr
 687           mcw  201,2001
 688           mcw
 689           b    2002
 690 *
 691 * begin main line program
 692 *
 693 setup     cs   print&132
 694           cs
 695 getorg    b    readog
 696 *
 697 * determine type
 698 *
 699 analwk    sw   typesw#1
 700           mn   type,typea#1
 701           bce  bypass,type,%
 702           bce  bypass,type,8
 703           bce  bypass,type,i
 704           bce  bypass,type,h
 705           bce  prowrk,alter,
 706 analog    bce  setcom,label-5,*
 707           bce  mapcnt,image&75,r
 708           bce  isiocs,image&75,w
 709           bce  mapcnt&7,image&75,s
 710           bce  mapcnt&7,image&75,z
 711           c    mnemon-2,@job@
 7115          be   dojob
 712           c    alter,altno
 713           bu   seqerr
 714           b    setfre
 715           cw   typesw
 716           bce  instr,type,
 717           mn   type,xr2
 718           a    xr2
 719           a    xr2
 720           b    *&1&x2
 721           b    da
 722           b    const
 723           b    dsa
 724           b    getov2
 725           b    sfx
 726           b    typerr
 727           b    org
 728           b    ds
 729           b    typerr
 730           b    typerr
 731 *
 732 * macro card
 733 *
 734 isiocs    mcw  @iocs@,kind-1
 735           b    mapcnt&7
 736 mapcnt    mcw  @macro@,kind
 737           b    setfre
 738           bce  calerr,image&86,7
 739           b    comxt
 740 calerr    mcw  @overcall@,print&123
 741           b    bmperr
 742           b    comxt
 743 *
 744 * new job card
 745 *
 746 dojob     mcw  opernd,job
 747           bw   doidt,newsw
 748           b    pnchcd
 749 doidt     mcw  image&80,punch&80
 750           s    linct
 751           b    prthdg
 752           b    mapcnt&7
 753 *
 754 * program generaged record
 755 *
 756 prowrk    bce  xtra,type,y
 757           cw   op&1
 758           mcs  aop,print&11
 759           sw   op&1
 760           bce  adcon,type,s
 761           bce  litral,typea,1
 762           b    typerr
 763 *
 764 * literal greater than 30 characters
 765 *
 766 xtra      sw   print&27
 767           mcw  fixfrm&72,oprand
 768           chain5
 769           b    bypass
 770 *
 771 * adcon card
 772 *
 773 adcon     mcw  @adcon@,kind
 774           sw   print&27
 775           mcw  fixfrm&53,print&40
 776           mcw  fixfrm&16,opcode-2
 777 dsa       mcw  bop,print&95
 778           mcw  bop,holdh&3
 779           b    setadd
 780           bce  symund,bop,#
 781           b    setlit
 782 *
 783 * literal and area definition cards
 784 *
 785 litral    bwz  prolit,type,s
 786           bwz  dadc,fixfrm&1,b
 787           mcw  @rmark@,kind
 788           bce  prolit&7,type,a
 789           mcw  @g@,kind-4
 790           b    prolit&7
 791 prolit    mcw  @lit@,kind-2
 792           mcw  fixfrm&53,print&57
 793           mcw  fixfrm&16,opcode-2
 794 const     b    setadd
 795           a    @00@,count
 796           c    count,@00@
 797           bl   good
 798           mz   zone-1,ststmt
 799           b    setlit
 800 good      bce  areadf,print&27,#
 801           bwz  areadf,fixfrm&4,b
 802           mcw  oprand,holddt-1
 803           bce  setlit,print&27,@
 804           bwz  unsign,print&27,2
 805           mcw  count,xr1
 806           mz   blank4,print&27&x1
 807           mz   print&27,holdh&x1
 808 setlit    b    setloc
 809           b    condns
 810 litout    b    prntln
 811           b    bypass
 812 unsign    mcw  oprand,holddt#52
 813           b    setlit
 814 areadf    bw   *&5,typesw
 815           b    setlit
 816           mcw  fixfrm&13,lab
 817           mcw  blank4-2,print&31
 818           mcw  count
 819           mcw  @#@
 820           mcw  @area@,kind-1
 821           b    setlit
 822 dadc      b    setadd
 823           b    condns
 824           cs   print&132
 825           cs
 826           b    bypass
 827 *
 828 * set condense addresses for constants
 829 *
 830 setadd    sbr  addxt&3
 831           za   labadd,loadad
 832           mcw  loadad
 833           s    count,wmaddr
 834           a    &1,wmaddr
 835 addxt     b    xxxx
 836 *
 837 * get next records
 838 *
 839 typerr    h    xxxx,770
 840 bypass    b    get
 841           bw   analwk,typesw
 842           b    getorg
 843 *
 844 * free form record to print area
 845 *
 846 setfre    sbr  freext&3
 847           mcs  altno,alt
 848           mcs  pageno,pg
 849           mz   pageno,pg
 850           mcw  lineno,lin
 851           mcw  label,lab
 852           mcw  mnemon,opcode
 853           mcw  opernd,oprand
 854           bce  iogen,image&75,z
 855           bce  iogen,image&75,y
 856           bce  genstm,image&75,c
 857           bce  genstm,image&75,s
 858 freext    b    xxxx
 859 iogen     mcw  @io@,kind
 860 genstm    mcw  @gen@,kind-2
 861           bce  comerr,image&86,b
 862           b    freext
 863           dcw  @ @
 864 ov1gm     dc   @}@
 865 *
 866 * assembled information to print area
 867 *
 868 setloc    sbr  locxt&3
 869           mcs  count,ct
 870           mcw  sfxctr,suffix
 871           mn   labadd,locn
 872           mcw
 873           bwz  tstfr,labadd-1,2
 874           mcw  @x@,print&92
 875           mz   blank1,print&89
 876 tstfr     bce  fourch,labadd-4,0
 877 tstlbl    bm   dbldef,stlabl
 878 tststm    bm   stmbad,ststmt
 879           bwz  stmbad,ststmt,s
 880 locxt     b    xxxx
 881 fourch    mcw  blank1,locn-4
 882           b    tstlbl
 883 dbldef    mcw  @label@,print&120
 884           b    bmperr
 885           b    tststm
 886 stmbad    mcw  @bad statement@,print&128
 887           b    bmperr
 888           b    locxt
 889 *
 890 * instruction card
 891 *
 892 instr     mcw  dmod,indmod
 893           mcw  bop,inbop
 894           mcw  aop,inaop
 895           mcw  op,inop
 896           mcw  dmod,holdh&8
 897           mcw
 898           mcw
 899           mcw
 900           mcw  labadd,wmaddr#5
 901           mcw  labadd,loadad#5
 902           a    count,loadad
 903           s    &1,loadad
 904           bce  symund,bop,#
 905           bce  symund,aop,#
 906           bce  badop,op,
 907           b    setlit
 908 badop     mcw  @ op@,print&123
 909           b    bmperr
 910           b    setlit
 911 *
 912 * define area cards
 913 *
 914 da        bce  header,type,0
 915           mcw  supadd,wmaddr
 916           mcw  @field@,kind
 917           bwz  setda,type,b
 918           mcw  @sbf@,kind-2
 919           b    orgxt
 920 setda     b    setloc
 921           b    condns
 922           b    prntln
 923 bypda     b    get
 924           bce  rptout,type,'
 925           b    getorg
 926 rptout    mcw  supadd,wmaddr
 927           b    condns
 928           cs   print&132
 929           cs
 930           b    bypda
 931 header    bwz  badda,fixfrm&4,b
 932           b    setloc
 933 nxtrpt    mn   supadd,print&97
 934           mcw
 935           mcw  labadd,wmaddr
 936           b    condns
 937           b    get
 938           c    fixfrm&16,@da @
 939           bu   pntda
 940           bce  nxtrpt,type,'
 941 pntda     bce  addr4k,print&93,0
 942           c    print&97,objcor
 943           bl   puadsw
 944           b    prntln
 945           b    getorg
 946 badda     mcw  @ no b x l@,print&129
 947           b    bmperr
 948           b    header&8
 949 addr4k    sbr  ad4kxt&3
 950           mcw  blank1,print&93
 951 ad4kxt    b    xxxx
 952 *
 953 * print statements
 954 *
 955 prntln    sbr  prntxt&3
 956           bce  dopnt,locn,
 957           bce  dopnt,typea,7
 958           c    locn,@ 0081@
 959           bh   adderr
 960 dopnt     bw   *&2,lstop
 961           w
 962           b    wtape
 963           bce  clr,typea,7
 964           c    locn,objcor
 965           bl   puadsw
 966 clr       cs   print&132
 967           cs
 968           bce  prntxt,type,3
 969           a    &1,linct#2
 970           bce  ovrflo,linct-1,5
 971 prntxt    b    xxxx
 972 ovrflo    b    prthdg
 973           s    linct
 974           b    prntxt
 975 getov1    rtw  xtratp,isiocs
 976           nop  xxxx
 977           ber  tperr
 978           cw   ov1gm
 979           rwd  xtratp
 980           b    bypass
 981           dcw  @ @
 982 ende1     dcw  @}@
 983           xfr  librn
 984           job  1401 autocoder-pass 7 right main line     -version 3   3774l
 985           org  2000
 986 *
 987 * print page heading
 988 *
 989 prthdg    sbr  phdgxt&3
 990           mcw  @page@,print&109
 991           a    &1,number
 992           mcs  number,print&114
 993           mcw  job,oprand
 994           mcw  punch&80,locn
 995           bw   wthead,lstop
 996           cc   1
 997           w
 998              nk               was cc k in rev 0
 999 wthead    mcw  @1@,200
1000           b    wtape
1001           cs   print&132
1002           cs
1003           mcw  @sfx ct  locn  instruction type  card@,print&114
1004           mcw  @seq pg lin  label  op    operands@,print&34
1005           bw   *&2,lstop
1006           w
1007           mcw  @0@,200
1008           b    wtape
1009           cs   print&132
1010           cs
1011           bw   *&2,lstop
1012           w
1013           b    wtape
1014 phdgxt    b    xxxx
1015 wtape     sbr  wtxt&3
1016           bw   wtxt,tapop
1017           wt   3,200
1018           nop  xxxx
1019           ber  tperr
1020 wtxt      b    xxxx
1021 adderr    mcw  @ addr@,print&132
1022           b    bmperr
1023           b    dopnt
1024 *
1025 * comments card
1026 *
1027 setcom    b    setfre
1028           mcw  opernd,print&80
1029           mcw
1030           mcw
1031 comxt     b    prntln
1032           b    readog
1033           b    analog
1034 comerr    mcw  @macro error@,print&126
1035           b    bmperr
1036           b    freext
1037 *
1038 * org, ltorg cards
1039 *
1040 org       mcw  supadd,labadd
1041           mcw  orgadd,supadd
1042           bwz  badorg,fixfrm&1,2
1043 orgout    mn   supadd,print&97
1044           mcw
1045           bce  addr4k,print&93,0
1046           c    print&97,objcor
1047           bl   puadsw
1048 orgxt     b    setloc
1049           b    litout
1050 badorg    mcw  @ undef org@,print&130
1051           b    bmperr
1052           b    orgout
1053 *
1054 * ds, equ cards
1055 *
1056 ds        bce  symund,aop,#
1057           b    orgxt
1058 *
1059 * error - address exceeds core
1060 *
1061 puadsw    sbr  adswxt&3
1062           cw   addrsw
1063 adswxt    b    xxxx
1064 *
1065 * error - undefined symbol
1066 *
1067 symund    sbr  undxt&3
1068           mcw  @ sym@,print&127
1069           b    bmperr
1070 undxt     b    xxxx
1071 *
1072 * bump number of errors
1073 *
1074 bmperr    sbr  errext&3
1075           a    &1,errcnt
1076 errext    b    xxxx
1077 *
1078 * suffix card
1079 *
1080 sfx       mcw  image&21,sfxctr#1
1081           b    litout
1082 *
1083 * condense routine
1084 *
1085 condns    sbr  condxt&3
1086           cw   bigsw,dcsw
1087           bm   condxt,ststmt
1088           bw   pnchcd,wmsw
1089 *
1090 * process record
1091 *
1092 nxtrcd    bce  dowm,typea,0
1093           bce  endrtn,typea,3
1094           bwz  tstdc,type,b
1095 *
1096 * test room on card
1097 *
1098 tstrom    c    count,@39@
1099           bl   tstcon
1100           mcw  pnhloc,roomct#3
1101           a    count,roomct
1102           c    roomct,@039@
1103           bl   setpnh
1104           bw   rstctr,newsw#1
1105 *
1106 * test sequence
1107 *
1108           mcw  countr#5,seqct#5
1109           a    count,seqct
1110           c    loadad,seqct
1111           bu   setpnh
1112           a    count,countr
1113 *
1114 * move data to punch area
1115 *
1116 mvdata    sbr  xr3,holdh
1117           a    count,xr3
1118           a    count,pnhloc
1119           mcw  pnhloc,xr2
1120           mcw  xxxx&x3,punch&x2
1121           cw   datasw#1
1122           bw   first,newsw
1123           bwz  cndout,type,b
1124 *
1125 * set word mark address
1126 *
1127 dowm      mcw  wmaddr,cnvadd#5
1128           b    cnvrt
1129           a    &3,wmloc
1130           mcw  wmloc,xr1
1131           mcw  cnvadd,wmaddr-2
1132           mcw  wmaddr-2,xxxx&x1
1133           c    xr1,&wmstr-3
1134           bu   cndout
1135           sw   wmsw
1136           b    cndout
1137 rstctr    mcw  loadad,countr
1138           b    mvdata
1139 setpnh    b    pnchcd
1140           b    nxtrcd
1141 tstdc     bw   compwm,newsw
1142           b    tstrom
1143 compwm    c    wmloc,awmstr
1144           be   tstrom
1145           sw   dcsw#1
1146           b    pnchcd
1147           b    tstrom
1148 *
1149 * first data on card
1150 *
1151 first     cw   newsw
1152           bwz  prodc,type,b
1153           b    cndout
1154 *
1155 * condense dc cards
1156 *
1157 prodc     mcw  @)@,punch&47
1158           mcw  wmaddr,cnvadd
1159           b    cnvrt
1160           mcw  cnvadd,wmaddr-2
1161           mcw  wmaddr-2,wmstr-15
1162           mcw  wmaddr-2
1163           a    &6,wmloc
1164           b    cndout
1165 *
1166 * convert 5 to 3 digit address
1167 *
1168 cnvrt     sbr  cnvxt&3
1169           bav  *&1
1170 addagn    a    &96,cnvadd-3
1171           bav  addagn
1172           mz   cnvadd-4,cnvadd
1173           mn   cnvadd-3,*&4
1174           mz   zone,cnvadd-2
1175 cnvxt     b    xxxx
1176 *
1177 * punch a card
1178 *
1179 pnchcd    sbr  pnhxt&3
1180           bw   edit,dcsw
1181           bw   edit,datasw
1182           mcw  countr,cnvadd
1183           b    cnvrt
1184           mcw  cnvadd,wmstr-21
1185           mcw  pnhloc,wmstr-24
1186 edit      mce  wmstr,punch&71
1187           mn   @0@,punch&41
1188 tstpch    bce  *&2,condsw,0
1189           p
1190           b    wtap2
1191 *
1192 * reset counters and switches
1193 *
1194 newcrd    a    &1,punch&75
1195           cs   punch&71
1196           lca  @l0     ,      ,      ,      1   @,punch&71
1197           sw   newsw,datasw
1198           cw   wmsw,dcsw
1199           mcw  @000@,pnhloc
1200           mcw  awmstr,wmloc
1201           mcw  @001001040040040040040040040@,wmstr
1202 pnhxt     b    xxxx
1203 *
1204 * constant greater than 39 characters*
1205 *
1206 tstcon    bw   *&5,newsw
1207           b    pnchcd
1208           mcw  count,holdct#2
1209           mcw  loadad,countr
1210           mcw  @39@,count
1211           s    @39@,holdct
1212           s    holdct,countr
1213           mz   zone-3,holdct
1214           sw   bigsw#1
1215           mcw  wmaddr,savewm#5
1216           b    mvdata
1217 bigrn     b    pnchcd
1218           cw   bigsw
1219           mcw  holdct,count
1220           mcw  @a@,type
1221           mcw  holddt,holddt-39
1222           mcw  savewm,wmaddr
1223           a    @39@,wmaddr
1224           b    rstctr
1225 *
1226 * exit from condense routine*
1227 *
1228 cndout    mcs  punch&75,cardno
1229           s    xr3&1
1230           s
1231           s
1232           bw   bigrn,bigsw
1233           mcw  blank1,holddt
1234           mcw  holddt
1235 condxt    b    xxxx
1236 wtap2     sbr  wt2xt&3
1237           bw   wt2xt,tapop
1238           mcw  @&@,100
1239           wt   3,100
1240           nop  xxxx
1241           ber  tperr
1242 wt2xt     b    xxxx
1243 *
1244 * sequence error on input records
1245 *
1246 seqerr    h    xxxx,777
1247           b    seqerr
1248 getov2    rtw  systap,isiocs
1249           nop  xxxx
1250           ber  tperr
1251           cw   ov2gm
1252           bsp  systap
1253           b    exend
1254 *
1255 * get record from working tape
1256 *
1257 get       sbr  workxt&3
1258           c    blkct,kblkng
1259           bu   nxtrec
1260           s    holda
1261           sbr  lgtck&6,input5&13
1262           rt   worktp,input5
1263           b    chklgt
1264           ber  tperr
1265 nxtrec    a    &80,blkct
1266           mcw  blkct,xr3
1267           mcw  fixinp,fixfrm&80
1268           chain10
1269           s    xr3&1
1270           s
1271           s
1272 workxt    b    xxxx
1273 *
1274 * read original tape
1275 *
1276 readog    sbr  origxt&3
1277           mcw  blank1,image&21
1278           s    image&20
1279           s
1280           s
1281           s
1282           sbr  lgtck&6,input4&12
1283           rt   origtp,input4
1284           b    chklgt
1285           ber  tperr
1286           s    xr2&1
1287 origxt    b    xxxx
1288 *
1289 * check for short records
1290 *
1291 chklgt    sbr  xr2
1292           sbr  lgtxt&3
1293           mz   @b@,xr2
1294 lgtck     bce  4000-12&x2,xxxx,}
1295           chain12
1296 lgtxt     b    xxxx
1297 holda     dcw  &0000
1298 blkct     equ  holda-1
1299 kblkng    dcw  @080@
1300 objcor    dcw  @ 3999@
1301 condsw    dcw  @0@
1302 job       dcw  #52
1303 errcnt    dcw  @0000@
1304           dcw  @ @
1305 ssave     dcw  @ @
1306 tapop     dcw  @ @
1307 lstop     dcw  @ @
1308 noout     dcw  @ @
1309 savcon    equ  holda-3
1310 gmsave    dc   @}@
1311 wmloc     dsa  wmstr-21
1312 awmstr    dsa  wmstr-21
1313 pnhloc    dcw  @000@
1314 number    dcw  @001@
1315 wmstr     dcw  @001001040040040040040040040@
1316           ltorg*
1317 ende2     dcw  @}@
1318 blank1    equ  blank4-3
1319 holdh     equ  holddt-52
1320           ex   librn
1321           end  librn
