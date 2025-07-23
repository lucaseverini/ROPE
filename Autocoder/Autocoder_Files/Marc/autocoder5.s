 101 000       job  autocoder-pass 5-process labels-initl-version 3        3751l
 102           ctl  63011
 103 *
 104 * equates used by program
 105 *
 106 initap    equ  %u0
 107 systpe    equ  %u1
 108 savetp    equ  %u4
 109 cinput    equ  %u5
 110 coutpt    equ  %u6
 111 doutpt    equ  %u5
 112 dinput    equ  %u6
 113 table     equ  2409
 114 addlo     equ  table-006&x2
 115 symho     equ  table-005&x2
 116 addho     equ  table-009&x2
 117 lblref    equ  table-008&x2
 118 symbol    equ  table&x2
 119 card      equ  0
 120 staop     equ  card&001
 121 stlabl    equ  card&002
 122 staddr    equ  card&003
 123 stbop     equ  card&004
 124 count     equ  card&007
 125 label     equ  card&013
 126 aoper     equ  card&022
 127 aopadj    equ  card&026
 128 aindex    equ  card&027
 129 orgadd    equ  card&032
 130 cnvlab    equ  card&056
 131 labadd    equ  card&061
 132 supadd    equ  card&066
 133 aop       equ  card&070
 134 type      equ  card&075
 135 aopho     equ  card&017
 136 lblho     equ  card&008
 137 hoadd     equ  card&057
 138 tparea    equ  3918
 139 input     equ  tparea-001&x3
 140 limit     equ  tparea&13
 141 xxxx      equ  0
 142 gpmrk3    equ  3998
 143 librn     equ  0
 144 *
 145 *
 146 * get, put, redundancy &
 147 * crossover routines common
 148 * to both passes
 149 *
 150 *
 151           org  endofc&1
 152 *
 153 * get & put
 154 *
 155 get       c    blkct,kblkng
 156           be   write
 157 nxtrec    a    &80,blkct
 158           mcw  blkct,xr3
 159 movein    mcw  input,card&80
 160           chain9
 161           s    xr3&001
 162           s
 163           s
 164           b    anal
 165 put       mcw  blkct,xr3
 166           mcw  card&80,input
 167           chain9
 168           b    get
 169 *
 170 *tape redundancy routine
 171 *
 172 tperr     sbr  xr1
 173           sbr  redxt&3
 174           mz   &9,xr1
 175           mcw  4000-10&x1,tpinst&7
 176           mn   tpinst&3,bsp1&3
 177           mcw  tpinst&7,inst2&7
 178 bsp1      bsp  initap
 179           bce  wrtred,tpinst&7,w
 180           mcw  &9,readct#1
 181 tpinst    rt   initap,xxxx
 182           ber  rdrerr
 183 redxt     b    xxxx
 184 rdrerr    mn   tpinst&3,bsp2&3
 185 bsp2      bsp  initap
 186           s    &1,readct
 187           bwz  tpinst,readct,b
 188           mn   tpinst&3,tphalt&6
 189 tphalt    h    xxxx,590
 190           mcw  tpinst&7,*&8
 191           rt   initap,xxxx
 192           bss  bsp1,e
 193 tphlt3    h    xxxx,511
 194           b    redxt
 195 wrtred    skp  systpe
 196           bce  subctr,wrtctr-1,5
 197           a    &1,wrtctr#2
 198 inst2     wt   initap,xxxx
 199           ber  bsp1
 200           b    redxt
 201 subctr    s    wrtctr
 202           mn   tpinst&3,*&7
 203 tphlt2    h    xxxx,560
 204           b    inst2
 205 *
 206 * check for short records
 207 *
 208 chklgt    sbr  xr1
 209           sbr  lgtxt&3
 210           mz   &9,xr1
 211 lgtck     bce  4000-12&x1,limit,}
 212           chain12
 213 lgtxt     b    xxxx
 214 *
 215 * crossover, c to d
 216 *
 217 rdpssd    rtw  systpe,1
 218           nop  xxxx
 219           ber  tperr
 220           cw   endofd
 221           b    passd
 222 *
 223 * crossover, d to c
 224 *
 225 rdpssc    rtw  coutpt,1
 226           nop  xxxx
 227           ber  tperr
 228           cw   endofc
 229           b    clrtab
 230 *
 231 * common constants
 232 *
 233 clrmax    dcw  @i97@
 234 clrmin    dsa  table-010
 235 fnctn     dcw  @      @
 236 tabmax    dcw  @v00@
 237 maxadd    dcw  @   @
 238 tablsz    dcw  &0150
 239 maxser    dcw  @    @
 240 sfxctr    dcw  @ @
 241 kblkng    dcw  @080@
 242 bumpop    dcw  @#@
 243 holda     dcw  &0000
 244 blkct     equ  holda-1
 245 tpad      dsa  tparea
 246           ltorg*
 247 *
 248 * protected constants
 249 *
 250 factor    equ  table-021
 251 machsz    equ  table-020
 252 totlab    equ  table-016
 253 unprsw    equ  table-015
 254 procsw    equ  table-014
 255 serchs    equ  table-010
 256 *
 257 * initialize pass c one time
 258 *
 259           org  table-009
 260           rwd  savetp
 261           rwd  cinput
 262           rwd  coutpt
 263           cs   3999
 264           sw   grpmrk
 265           lca  @00@,procsw
 266           lca  &0150,serchs
 267           lca  @0015@,factor
 268           rtw  systpe,1
 269           nop  xxxx
 270           ber  tperr
 271           cw   endint
 272 *
 273 * set i/o group mark
 274 *
 275           mcw  machsz,keep1#001
 276           a    &3,keep1
 277           mn   keep1,*&004
 278           mz   zone2,*&007
 279 setio     lca  grpmrk,gpmrk3
 280           bwz  setbmp,setio&006,2
 281           cs   4799
 282           cs   4399
 283           mcw  @#@,bump
 284           bce  set8k,machsz,4
 285 *
 286 * 12k constants
 287 *
 288           mcw  blkg12,kblkng
 289           mcw  tbsz12,tablsz
 290           mcw  tblm12,tabmax
 291           mcw  tpad12,tpad
 292           mcw  mdtp12,mdtp#003
 293           a    &72,factor
 294           bce  settp,machsz,5
 295 *
 296 * 16k constants
 297 *
 298           a    &400,tablsz
 299           a    &40,factor
 300           mz   abbit,tabmax
 301           mz   abbit,tpad
 302           mz   abbit,mdtp
 303           b    settp
 304 *
 305 * 8k constants
 306 *
 307 set8k     mcw  blkg8k,kblkng
 308           mcw  tbsz8k,tablsz
 309           mcw  tblm8k,tabmax
 310           mcw  tpad8k,tpad
 311           mcw  mdtp8k,mdtp
 312           a    &36,factor
 313 settp     mz   tpad,clrmax
 314           mcw  mdtp,movein&003
 315           mcw  mdtp,put&013
 316           mcw  tpad,write&006
 317           mcw  tpad,read&010
 318           mcw  tpad,limad#3
 319           ma   &13,limad                  ??? &013 ???
 320           mcw  limad,lgtck&6
 321 setbmp    mcw  bump,bumpop
 322           lca  grpmrk,endofc
 323 *
 324 * write pass c checkpoint on 6
 325 *
 326           cs   80
 327           sw   card&001,card&006
 328           sw   card&017,card&024
 329           sw   card&028,card&035
 330           sw   card&057,card&062
 331           sw   card&068,card&071
 332           wtw  coutpt,1
 333           nop  xxxx
 334           ber  tperr
 335           cw   endofc,grpmrk
 336           c    totlab,tablsz
 337           mcw  tablsz,serchs
 338           s    totlab
 339           be   clrtab
 340           bh   clrtab
 341           mcw  &0009,serchs
 342           b    clrtab
 343 blkg8k    dcw  @400@
 344 tbsz8k    dcw  &0510
 345 tblm8k    dsa  5100
 346 tpad8k    dsa  7598
 347 mdtp8k    dsa  7597&x3
 348 blkg12    dcw  @800@
 349 tbsz12    dcw  &0870
 350 tblm12    dsa  8700
 351 tpad12    dsa  11198
 352 mdtp12    dsa  11197&x3
 353 grpmrk    dc   @}@
 354           ltorg*
 355 endint    dcw  @}@
 356           xfr  librn
 357           job  autocoder-pass 5 main line           -version 3        3752l
 358 *
 359 * pass c-load symbol table& set addresses
 360 *
 361 zone      equ  113
 362 113       dcw  @2skb@
 363 zone2     equ  109
 364 109       dcw  @2skb@
 365 abbit     equ  zone
 366 bbit      equ  zone-001
 367 abit      equ  zone-002
 368 nobit     equ  zone-003
 369 xr1       equ  89
 370 89        dcw  @000@
 371 xr2       equ  94
 372 94        dcw  @000@
 373 xr3       equ  99
 374 99        dcw  @000@
 375           org  zone&001
 376 *
 377 * determine record type
 378 *
 379 anal      bm   put,card&005
 380           bce  put,type,%
 381           bce  instr,type,
 382           mn   type,xr2
 383           bce  da,xr2,0
 384           mcw  @0@,indftr
 385           mcw  @0@,dasw
 386           a    xr2
 387           a    xr2
 388           b    *&001&x2
 389           nop  xxxx
 390           b    const
 391           b    const
 392           b    exend
 393           b    sfx
 394           b    put
 395           b    org
 396           b    ds
 397           b    put
 398           b    put
 399 *
 400 * process instructions
 401 *
 402 instr     mcw  @0@,indftr
 403           b    prcadd
 404           b    proclb
 405           bwz  put,staddr,2
 406           a    count,nowctr
 407           s    @1@,nowctr
 408           b    put
 409 *
 410 * process constants & dcw
 411 *
 412 const     bce  prcast,aopho,*
 413           mcw  @1@,actsw
 414           b    proclb
 415           b    put
 416 *
 417 * constantds with asterisk address
 418 *
 419 prcast    b    prcadd
 420           b    proclb
 421           b    put
 422 *
 423 * process ds & equates
 424 *
 425 ds        bce  proctu,aopho,%
 426           a    aindex,indftr
 427           bce  const,aopho,*
 428           bwz  const,aopho,2
 429           bwz  *&5,staop,2
 430           b    const
 431 *
 432 * equate
 433 *
 434           b    setaop
 435           mcw  dsaput,labrtn&003
 436           bwz  unproc,staop,2
 437           b    const
 438 *
 439 * ds of input device
 440 *
 441 proctu    mcw  aoper-003,labadd-001
 442           mcw  @0@
 443           b    const
 444 *
 445 * process origin & literal origin
 446 *
 447 org       bwz  sethgh,card&033,b
 448           za   labadd,orgadd
 449           a    @1@,orgadd
 450           mz   abbit,card&033
 451 sethgh    bce  orgsav,maxsw,1
 452           c    nowctr,hghctr
 453           bh   orgsav
 454           za   nowctr,hghctr
 455 *
 456 * process save counter of origin
 457 *
 458 orgsav    bce  aopor,lblho,
 459           mcw  @005@,xr1
 460           mcw  &aopor,labrtn&003
 461           bwz  *&005,stlabl,2
 462           b    aopor
 463           bce  strsav,supadd,
 464 btolab    b    dolabl
 465           b    search
 466           bce  store,dblsw,1
 467           bce  store,spcsw,0
 468           b    unproc
 469 strsav    bce  unproc,addrsw,1
 470           bce  unproc,litrsw,1
 471           mcw  nowctr,supadd
 472           a    @1@,supadd
 473           b    btolab
 474 *
 475 * process a operand of origin
 476 *
 477 aopor     bwz  *&005,staop,2
 478           b    actual
 479           bce  astrsk,aopho,*
 480           mcw  @0@,litrsw
 481           s    nowctr
 482           bce  blkaop,aopho,
 483 *
 484 * symbolic origin
 485 *
 486           mcw  @0@,orgsw
 487           s    xr1&001
 488           b    setaop
 489           bce  setorg,orgsw,1
 490 setsws    mcw  @11@,maxsw
 491           b    scntb&7
 492 setorg    mcw  labadd,orgctr
 493 rstswa    mcw  @0@,addrsw
 494           bce  *&005,aopadj-002,x
 495           b    aopout
 496 *
 497 * adjustment of x00
 498 *
 499           bce  nxtcnt,aopho,*
 500           c    orgctr,&00
 501           be   aopout
 502 nxtcnt    mcw  &00,orgctr
 503           a    @1@,orgctr-002
 504 aopout    a    orgctr,orgadd
 505           za   orgctr,labadd
 506           za   orgadd,nowctr
 507           s    @1@,nowctr
 508           mz   abbit,staop
 509           b    put
 510 *
 511 * origin asterisk
 512 *
 513 astrsk    bce  put,addrsw,1
 514           bce  setsws,litrsw,1
 515           mcw  nowctr,orgctr
 516           b    rstswa
 517 *
 518 * origin maximum
 519 *
 520 blkaop    bce  setsws,maxsw,1
 521           mcw  hghctr,orgctr
 522           a    @1@,orgctr
 523           b    rstswa
 524 *
 525 * origin actual or processed
 526 *
 527 actual    za   orgadd,nowctr
 528           s    @1@,nowctr
 529           bce  tstx00,aopho,*
 530           mcw  @0@,litrsw
 531           bwz  scntb,aopho,2
 532           bwz  setorg,staop,k
 533 scntb     mcw  @0@,addrsw
 534           s    orgctr
 535           b    put
 536 tstx00    bce  put,aopadj-002,x
 537           bwz  put,card&034,b
 538           a    orgctr,orgadd
 539           bce  put,addrsw,1
 540           bce  put,litrsw,1
 541           mz   abbit,card&34
 542           b    actual
 543 *
 544 * process da statements
 545 *
 546 da        bce  origda,type,0
 547           bce  tstrpt,actsw,1
 548 btoadd    c    labadd,supadd
 549           bl   *&8
 550           mcw  @005@,xr3
 551           b    prcadd
 552 tstrpt    bce  put,type,'
 553           b    proclb
 554           b    put
 555 *
 556 * da header
 557 *
 558 origda    mcw  @0@,indftr
 559           a    aindex,indftr
 560           mcw  @1@,dasw
 561           mcw  @0@,actsw
 562           bce  btoadd,aopho,*
 563           mcw  @1@,actsw
 564           b    tstrpt
 565 *
 566 * ??? missing from listing in CE manual ***
 567 * ??? missing from listing in CE manual ***
 568 exend     bwz  put,type,b
 569           mcw  @b@,branch
 570           b    write
 571 *
 572 * process suffix
 573 *
 574 sfx       mcw  aopho,sfxctr
 575           b    put
 576 *
 577 * process addresses
 578 *
 579 prcadd    sbr  addrtn&003
 580           mcw  @0@,actsw
 581           bwz  littst,stlabl,k
 582 tstadd    bwz  addrtn,staddr,b
 583           bce  addrtn,addrsw,1
 584           a    orgctr,labadd
 585           a    orgctr,supadd
 586           c    nowctr,labadd&x3
 587           bl   *&008
 588           za   labadd&x3,nowctr
 589           bce  addrtn,litrsw,1
 590           mz   abbit,staddr
 591 addrtn    b    xxxx
 592 littst    mcw  dsaput,labrtn&003
 593           bce  litral,type,/
 594           b    tstadd
 595 *
 596 * process label
 597 *
 598 proclb    sbr  labrtn&003
 599           bwz  *&005,stlabl,2
 600           b    labrtn
 601           bce  mrkprc,lblho,
 602           bce  btolbl,actsw,1
 603           bce  tstdbl,litrsw,1
 604           bce  tstdbl,addrsw,1
 605 btolbl    b    dolabl
 606           b    search
 607           bce  dbldef,dblsw,1
 608           bce  store,spcsw,0
 609 *
 610 * unprocessed label
 611 *
 612 unproc    mcw  @1@,unprsw
 613           a    @1@,totlab
 614           bce  setswl,type,/
 615           b    labrtn
 616 *
 617 * search table for dbl def literal
 618 *
 619 tstdbl    bce  unproc,lblho,$
 620           b    dolabl
 621           b    search
 622           bce  unproc,dblsw,0
 623           bce  unproc,addho,
 624           mz   bbit,stlabl
 625           b    labrtn
 626 *
 627 * unprocessed label of literal
 628 *
 629 setswl    bce  labrtn,lblho,$
 630           mcw  @11@,litrsw
 631           b    labrtn
 632 *
 633 * store label in table
 634 *
 635 store     lca  fnctn,symbol
 636           lca  holdad
 637 mrkprc    mz   abbit,stlabl
 638           mcw  @1@,procsw
 639 labrtn    b    xxxx
 640 *
 641 * doubly defined label
 642 *
 643 dbldef    bce  store,addho,
 644           mz   bbit,stlabl
 645           bce  litral,type,/
 646           b    labrtn
 647 *
 648 * double defined literal
 649 *
 650 litral    bwz  labrtn,stbop,b
 651           mcw  @%@,type
 652           s    count,orgctr
 653           s    count,nowctr
 654           b    labrtn
 655 *
 656 * set up label & address
 657 * for table search
 658 *
 659 dolabl    sbr  dolabr&003
 660           mcw  label,fnctn
 661           mcw  cnvlab,argumt#3
 662 setfun    bce  *&5,fnctn,
 663           b    *&8
 664           mcw  sfxctr,fnctn
 665           mcw  labadd&x1,holdad#004
 666           bce  doindx,hoadd&x1,0
 667           mz   abit,holdad-003
 668 doindx    mn   indftr,*&004
 669           mz   zone,holdad-001
 670 dolabr    b    xxxx
 671 *
 672 * process a operand of origin & equate
 673 *
 674 setaop    sbr  aoprtn&003
 675           mcw  &brsrh,dolabr&003
 676           mcw  aoper,fnctn
 677           mcw  aop,argumt
 678           b    setfun
 679 brsrh     b    search
 680           bce  addbnk,dblsw,1
 681           bce  strbnk,spcsw,0
 682 aoprtn    b    xxxx
 683 *
 684 * label not in table, store
 685 * with blank address
 686 *
 687 strbnk    lca  fnctn,symbol
 688           lca  @    @
 689           b    aoprtn
 690 *
 691 * retrieve value from table
 692 *
 693 addbnk    bce  aoprtn,addho,
 694           mcw  @1@,orgsw
 695           bwz  *&5,lblref,2
 696           b    *&8
 697           mz   abit,lblref
 698           mcw  addlo,labadd
 699           bce  aoproc,labadd-3,%
 700           bwz  *&008,labadd-003,2
 701           mcw  @1@,hoadd
 702           bce  aoprtn,type,o
 703 *
 704 * add character adjustment for equate
 705 *
 706           mz   labadd-001,savezn#001
 707           a    aopadj,labadd
 708           mz   savezn,labadd-001
 709           bce  aoproc,aindex,
 710           mn   indftr,*&004
 711           mz   zone,labadd-001
 712 aoproc    mz   abbit,staop
 713           b    aoprtn
 714 *
 715 * table search
 716 *
 717 search    sbr  return&003
 718           mcw  dblsw&001,dblsw
 719           mcw  tabmax,maxadd
 720           mcw  argumt,xr2
 721           mcw  serchs,maxser
 722 tblsrh    c    fnctn,symbol
 723           be   setdbl
 724           bce  return,symho,
 725 bump      a    @010@,xr2
 726           s    @1@,maxser
 727           bm   setspc,maxser
 728           c    xr2,maxadd
 729           bu   tblsrh
 730           bce  setspc,wrapsw,1
 731           mcw  @1@,wrapsw
 732           mcw  argumt,maxadd
 733           s    xr2&001
 734           b    tblsrh
 735 *
 736 * label in table
 737 *
 738 setdbl    mcw  @1@,dblsw
 739           b    return
 740 *
 741 * space available
 742 *
 743 setspc    mcw  @1@,spcsw
 744 return    b    xxxx
 745 *
 746 * input/output - pass c
 747 *
 748 write     wt   coutpt,tparea
 749           nop  xxxx
 750           ber  tperr
 751 branch    nop  final
 752 read      s    holda
 753           rt   cinput,tparea
 754           b    chklgt
 755           ber  tperr
 756           b    nxtrec
 757 *
 758 * clear table area
 759 *
 760 clrtab    mcw  clrmax,clear&003
 761 clear     cs   xxxx
 762           sbr  clear&003
 763           c    clear&003,clrmin
 764           bu   clear
 765           b    read
 766 nowctr    dcw  &00000
 767 orgctr    dcw  &00000
 768 hghctr    dcw  &00000
 769 addrsw    dcw  @0@
 770 maxsw     dc   @0@
 771 litrsw    dc   @0@
 772 wrapsw    dcw  @0@
 773 spcsw     dc   @0@
 774 dblsw     dc   @0@
 775           dc   @0@
 776 orgsw     dcw  @0@
 777 actsw     dcw  @0@
 778 dasw      dcw  @0@
 779 indftr    dcw  @0@
 780 dsaput    dsa  put
 781 *
 782 * end of pass c, get pass d
 783 *
 784 final     wtm  coutpt
 785           rwd  cinput
 786           rwd  coutpt
 787           b    rdpssd
 788           ltorg*
 789 endofc    dcw  @}@
 790           xfr  librn
 791           job  autocoder-pass 6-process operands    -version 3        3761l
 792 *
 793 91        dcw  @00000@
 794 96        dcw  @00000@
 795 101       dcw  @00000@
 796 109       dcw  @2skb@
 797 113       dcw  @2skb@
 798           org  zone&001
 799 *
 800 * determine record type
 801 *
 802           mcw  @0@,astrsw
 803           bm   put,card&005
 804           bce  put,type,%
 805           mn   type,typea#001
 806           bce  prinst,typea,
 807           bce  prdsa,typea,2
 808           bce  proend,typea,3
 809           bce  prosfx,typea,4
 810           bce  orgequ,typea,6
 811           bce  orgequ,typea,7
 812           b    put
 813 *
 814 * process instructions
 815 *
 816 prinst    bwz  setast,staddr,2
 817           b    loaddr
 818 setast    mcw  @1@,astrsw
 819 *
 820 * set asterisk address
 821 *
 822 loaddr    za   labadd,astadd#005
 823           a    count,astadd
 824           s    @1@,astadd
 825 *
 826 * test for a operand
 827 *
 828           bce  put,count,1
 829           bce  put,count,2
 830           bwz  *&005,staop,2
 831           b    seebop
 832           b    procop
 833 *
 834 * test for b operand
 835 *
 836 seebop    bce  put,count,4
 837           bce  put,count,5
 838           bwz  *&005,stbop,2
 839           b    put
 840           mcw  @003@,xr3
 841           mcw  @011@,xr1
 842           b    procop
 843           b    put
 844 *
 845 * process dsa and adcon
 846 *
 847 prdsa     bwz  *&005,staddr,2
 848           b    tstprc
 849           mcw  @1@,astrsw
 850 setdsa    za   labadd,astadd
 851           mcw  @003@,xr3
 852           mcw  @011@,xr1
 853           bwz  *&005,stbop,2
 854           b    put
 855           b    procop
 856           bwz  put,stbop,2
 857           bce  cmp16k,aindex,-
 858 comprs    mcw  &put,oprtn&3
 859           bce  put,aop&1,%
 860           b    cnvto3
 861 *
 862 * get 16000 complement
 863 *
 864 cmp16k    mcw  &16000,fnctn-001
 865           s    holdar,fnctn-001
 866           za   fnctn-001,holdar#005
 867           b    comprs
 868 tstprc    bwz  setdsa,stbop,2
 869           b    put
 870 *
 871 * process ex & end
 872 *
 873 proend    s    astadd
 874           bwz  *&005,staop,2
 875           b    *&005
 876           b    procop
 877           bce  endopn,type,3
 878           b    put
 879 endopn    mcw  @b@,brnch2
 880           b    put
 881 *
 882 * process origin & equate
 883 *
 884 orgequ    bwz  *&005,staop,2
 885           b    orgout
 886           bce  orgout,aopho,
 887           bwz  orgout,aopho,2
 888           bce  orgout,aopho,*
 889           bce  orgout,aopho,%
 890           b    procop
 891           bwz  orgout,staop,2
 892           mcw  @0@,itersw
 893           bce  *&008,typea,7
 894           mz   bbit,staop
 895           mcw  holdar,labadd
 896 orgout    b    put
 897 *
 898 * process operand sub-routine
 899 *
 900 procop    sbr  oprtn&003
 901           bwz  *&005,staop&x3,2
 902           b    oprtn
 903           bce  setzro,aopho&x1,
 904           bce  percnt,aopho&x1,%
 905           bwz  float,aopho&x1,2
 906           bce  proast,aopho&x1,*
 907 *
 908 * convert symbol to table address
 909 *
 910 cnvsym    bce  *&005,aop-002&x3,
 911           b    setsym
 912           mcw  aoper&x1,w6area#006
 913           bce  *&5,w6area,
 914           b    *&8
 915           mcw  sfxctr,w6area
 916           za   &2,hold2#002
 917           za   w6area-2,hold4#004
 918           a    w6area,hold4
 919           a    w6area,hold4-002
 920           mz   nobit,hold4
 921           za   factor,hold7
 922 mpylp     mn   hold7,hold1
 923           za
 924 mult      bce  nxtdgt,hold1,?
 925           a    hold4,hold7-002
 926           s    &1,hold1
 927           b    mult
 928 nxtdgt    s    &1,hold2
 929           bwz  mpylp,hold2,b
 930           mcw  @000@,aop&x3
 931           bav  *&001
 932 loop1     a    &96,hold7-005
 933           bav  loop1
 934           mz   hold7-006,aop&x3
 935           mcw  hold7-003
 936           mn   hold7-005,*&004
 937           mz   zone2,aop-002&x3
 938 *
 939 * symbolic operand
 940 *
 941 setsym    mcw  aoper&x1,fnctn
 942           bce  *&005,fnctn,
 943           b    *&008
 944           mcw  sfxctr,fnctn
 945           mcw  tabmax,maxadd
 946           mcw  @0@,swich1
 947           mcw  aop&x3,xr2
 948           mcw  serchs,maxser
 949 *
 950 * table search
 951 *
 952 srhlop    c    fnctn,symbol
 953           be   recall
 954           bce  undef,symho,
 955 bumper    a    @010@,xr2
 956           s    @1@,maxser
 957           bm   undef,maxser
 958           c    xr2,maxadd
 959           bu   srhlop
 960           bce  undef,swich1,1
 961           mcw  @1@,swich1
 962           mcw  aop&x3,maxadd
 963           s    xr2&001
 964           b    srhlop
 965 *
 966 * blank operand
 967 *
 968 setzro    s    holdar
 969           b    chradj
 970 *
 971 * percent operand
 972 *
 973 percnt    mcw  aoper-003&x1,aop&x3
 974           b    mark
 975 *
 976 * undefined operand
 977 *
 978 undef     bce  oprtn,itersw,0
 979           mcw  @###@,aop&x3
 980           b    oprtn
 981 *
 982 * retrieve value from table
 983 *
 984 recall    bce  undef,addho,
 985           bwz  *&5,lblref,2
 986           b    *&8
 987           mz   abit,lblref
 988           mcw  addlo,holdar
 989           mcw  @0@
 990           bce  ioadd,holdar-003,%
 991           bwz  *&008,holdar-003,2
 992           mcw  @1@,holdar-4
 993           bce  tstcnv,typea,6
 994 *
 995 * add character adjustment
 996 *
 997 chradj    mz   holdar-001,holdzn#001
 998           bce  tstcnv,aopadj-002&x1,x
 999           a    aopadj&x1,holdar
1000           mz   holdzn,holdar-001
1001 tstcnv    bm   mark,type
1002           bce  mark,typea,2
1003 *
1004 * convert five digit address to three digit addr
1005 *
1006 cnvto3    bav  *&001
1007           a    @96@,holdar-003
1008           bav  cnvto3&005
1009           mz   holdar-004,holdar
1010           mn   holdar-003,*&004
1011           mz   zone2,holdar-002
1012           mz   holdzn,holdar-001
1013           bce  stradd,aindex&x1,
1014           mn   aindex&x1,*&004
1015           mz   zone,holdar-001
1016 stradd    mcw  holdar,aop&x3
1017 *
1018 * mark operand processing
1019 *
1020 mark      mz   abbit,staop&x3
1021 oprtn     b    xxxx
1022 *
1023 * I/O address in table
1024 *
1025 ioadd     mcw  holdar-001,aop&x3
1026           b    mark
1027 *
1028 * asterisk operand
1029 *
1030 proast    bce  *&5,aoper&x1,
1031           b    cnvsym
1032           bce  oprtn,astrsw,1
1033           mcw  astadd,holdar
1034           b    chradj
1035 *
1036 * actual operand - float to 5 digits
1037 *
1038 float     bce  cnvsym,aopho&x1,#
1039           bce  cnvsym,aopho&x1,@
1040           bwz  *&005,aoper-004&x1,2
1041           b    cnvsym
1042           za   aoper-001&x1,holdar
1043 reflot    bce  *&005,holdar,&
1044           b    chradj
1045           za   holdar-001,holdar
1046           b    reflot
1047 *
1048 * process suffix
1049 *
1050 prosfx    mcw  aopho,sfxctr
1051           b    put
1052 *
1053 * initialize pass d
1054 *
1055 passd     sw   grpmk2-1
1056           rtw  dinput,byprd
1057           cw   grpmk2-1
1058           cs   card&80
1059           sw   card&001,card&006
1060           sw   card&017,card&024
1061           sw   card&028,card&035
1062           sw   card&057,card&062
1063           sw   card&068,card&071
1064           mcw  bumpop,bumper
1065           mcw  @6@,tphalt&4
1066           mcw  @6@,tphlt2&4
1067           mcw  @6@,tphlt3&4
1068           mcw  tpad,write2&006
1069           mcw  tpad,read2&010
1070           mcw  @ @,sfxctr
1071 *
1072 * test last iteration
1073 *
1074           bce  lstitr,procsw,0
1075           bce
1076           b    read2
1077 lstitr    mcw  @1@,itersw
1078           b    read2
1079 astrsw    dcw  0
1080 swich1    dcw  @0@
1081 hold7     dcw  @       @
1082 hold1     dcw  &0
1083 itersw    dcw  @0@
1084 byprd     dcw  @ @
1085 grpmk2    dc   @} @
1086 ssop      equ  1900
1087           ltorg*
1088 *
1089 * input/output - pass d
1090 *
1091           org  write
1092 write2    wt   doutpt,tparea
1093           nop  xxxx
1094           ber  tperr
1095 brnch2    nop  finald
1096 read2     s    holda
1097           rt   dinput,tparea
1098           b    chklgt
1099           ber  tperr
1100           b    nxtrecd
1101 *
1102 finald    wtm  doutpt
1103           rwd  dinput
1104           rwd  doutpt
1105           rtw  systpe,333
1106           nop  xxxx
1107           ber  tperr
1108           cw   endovl
1109           mcw  bumpop,tstlst
1110           mcw  bumpop,not
1111           b    tstref
1112           dcw  @ @
1113 endofd    dcw  @}@
1114           ex   librn
1115           job  autocoder-pass 6 print symbol table  -version 3        3762l
1116 *
1117           org  333
1118 *
1119 * end of pass d
1120 *
1121 * print list of unreferenced labels
1122 *
1123 tstref    cs   0332
1124           cs
1125           s    xr3&1
1126           s
1127           s
1128           sw   headsw#001
1129 nxtlbl    bce  tstlst,symho,
1130           bce  tstlst,addho,
1131           bce  lozng,symho,)
1132           c    symho,@A@
1133           bh   doref
1134           c    symho,@Z@
1135           bl   doref
1136           mn   symho,xr3
1137           bwz  swtab,symho,b
1138           a    @010@,xr3
1139           bm   swtab,symho
1140           a    @010@,xr3
1141 swtab     sw   sortab&x3
1142           s    xr3&2
1143 doref     bwz  *&5,lblref,2
1144           b    tstlst
1145           bw   newpge,headsw
1146 donext    cw   headsw
1147           b    print
1148           w
1149           cs   216
1150 tstlst    a    @010@,xr2
1151           c    xr2,tabmax
1152           be   dump
1153           bcv  newpge
1154           b    nxtlbl
1155 newpge    cc   1
1156           mcw  @unreferenced labels@,219
1157           cc   t
1158           w
1159           cs   0219
1160           bw   donext,headsw
1161           b    nxtlbl
1162 lozng     sw   list-1
1163           b    doref
1164 *
1165 * print subroutine for unreferenced labels & symbol tabble
1166 *
1167 print     sbr  prtxt&3
1168           mcw  symbol,206&x1
1169           bce  doio,addho,%
1170           mn   addlo,212&x1
1171           mn
1172           mn
1173           mn
1174           bwz  *&8,addho,2
1175           mcw  @1@,208&x1
1176           bwz  prtxt,addlo-1,2
1177           mn   @1@,215&x1
1178           mcw  @&x@
1179           bwz  prtxt,addlo-1,s
1180           mn   @2@,215&x1
1181           bwz  prtxt,addlo-1,k
1182           mn   @3@,215&x1
1183 prtxt     b    xxxx
1184 doio      mcw  addlo,212&x1
1185           b    prtxt
1186 *
1187 * print symbol table
1188 *
1189 dump      b    nxtpge
1190           s    xr3&1
1191           s
1192           s
1193 nxtctr    sw   endsw#1
1194           bw   scan,sortab&1&x3
1195 bmpxr3    bce  tsteoj,sortab&1&x3,@
1196           a    &1,xr3
1197           b    nxtctr
1198 scan      bce  bmpxr3,sortab&1&x3,!
1199           bce  bmpxr3,sortab&1&x3,'
1200           bce  bmpxr3,sortab&1&x3,/
1201           mcw  sortab&1&x3,tstlbl&7
1202 tstlbl    bce  dopnt,symho,x
1203 not       a    @010@,xr2
1204           c    xr2,tabmax
1205           bu   tstlbl
1206           s    xr2&1
1207           s
1208           a    &1,xr3
1209           cw   endsw
1210           bw   pntsym,pntsw
1211           sw   pntsw
1212           b    tstesw
1213 dopnt     bce  not,addho,
1214           b    print
1215           sw   pntsw
1216           a    @016@,xr1
1217           c    xr1,@128@
1218           bu   not
1219 pntsym    w
1220           cw   pntsw#1
1221           cs   332
1222           cs
1223           s    xr1&1
1224           bw   *&9,endsw
1225           bce  tsteoj,sortab&1&x3,@
1226           bcv  nxtpge
1227 tstesw    bw   not,endsw
1228           b    nxtctr
1229 nxtpge    sbr  pgxt&3
1230           cs   332
1231           cs
1232           cc   1
1233           mcw  @symbol table@,212
1234           w
1235           cc   k
1236           cs   212
1237 pgxt      b    xxxx
1238 tsteoj    bw   *&3,headsw
1239           cc   1
12391          cs   332
12392          chain3
1240           bce  eojob,itersw,1
1241 *
1242 * get pass c
1243 *
1244           bsp  systpe
1245           bsp  systpe
1246           mcw  @5@,tphalt&4
1247           mcw  @5@,tphlt2&4
1248           mcw  @5@,tphlt3&4
1249           mcw  @00@,procsw
1250           mcw  @ @,sfxctr
1251 *
1252 * set number of seeks for table search
1253 *
1254           c    totlab,tablsz
1255           mcw  tablsz,serchs
1256           s    totlab
1257           be   rdpssc
1258           bh   rdpssc
1259           mcw  &0009,serchs
1260           b    rdpssc
1261 *
1262 * last iteration, get pass c
1263 *
1264 eojob     cw   grpmk2-1
1265           cs   3999
1266           bce  reade,machsz,3
1267           cs   4799
1268           chain7
12681clr       cs   3999
12682          sbr  clr&3
12683          c    clr&3,&ssop-1
12684          bu   clr
1269 reade     rtw  systpe,ssop
1270           ber  syserr
1271 gotoe     mcw  @n@,ssop
1272           b    ssop&1
1273 syserr    mcw  &9,rdct#1
1274           bsp  systpe
1275 retry     rtw  systpe,ssop
1276           ber  again
1277           b    gotoe
1278 again     bsp  systpe
1279           s    @1@,rdct
1280           bwz  retry,rdct,b
1281           h    xxxx,691
1282           rtw  systpe,ssop
1283           bss  syserr,e
1284           h    xxxx,612
1285           b    gotoe
1286 list      dcw  @ abcdefghi!jklmnopqr'/stuvwxyz)@@
1287 sortab    equ  list-31
1288           ltorg*
1289 endovl    dcw  @}@
1290           ex   librn
1291           end  librn
