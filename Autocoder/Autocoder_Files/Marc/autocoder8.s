 101 000       job  1401 autocoder-pass 8 load tape-right main-version 3   3782l
 102           ctl  630 1
 103 *
 104 * equates used by program
 105 *
 106 initap    equ  %u0
 107 intape    equ  %u5
 108 outape    equ  %u6
 109 punch     equ  100
 110 output    equ  punch&1
 111 image     equ  0
 112 xxxx      equ  0
 113 count     equ  image&7
 114 labadd    equ  image&61
 115 supadd    equ  image&66
 116 aop       equ  image&70
 117 bop       equ  image&73
 118 dmod      equ  image&74
 119 type      equ  image&75
 120 print     equ  200
 121 librn     equ  0
 122           org  87
 123 xr1       dcw  000
 124           dc   00
 125 xr2       dcw  000
 126           dc   00
 127 xr3       dcw  000
 128           dc   00
 129 *
 130 * initialization routiune
 131 *
 132           org  336
 133 zone      dcw  @2skb@
 134 initlz    rwd  outape
 135           c    outopn,@2@
 136           bh   endjob
 137           c    outopn,@7@
 138           bl   endjob
 139           rwd  4
 140           rwd  intape
 141           cw   ltapsw,pnh4sw
 142           mcw  ssop,tstss
 143 *
 144 * test for ctl card
 145 *
 146 read4     mcw  @013@,lgtck&6
 147           rt   4,1
 148           b    chklgt
 149           ber  tperr
 150           c    18,@job@
 151           bu   ckctl
 152           mcw  79,ident#4
 153           cw   jobsw#1
 154           b    read4
 155 ckctl     c    18,@ctl@
 156           mcw  outopn,23
 157           rwd  4
 158           be   tstss
 159           lca  @33@,22
 160 tstss     bss  sensw,f
 161 tstop     bce  ltapop,23,2
 162           bce  ltapop,23,3
 163           bce  ltapop,23,6
 164           bce  ltapop,23,7
 165           sw   ltapsw#1
 166           b    start
 167 *
 168 * option to punch new source deck
 169 *
 170 pnh4op    sw   pnh4sw#1
 171           b    tstlsw
 172 *
 173 * test sense switches for option
 174 *
 175 sensw     lca  @0@,23
 176           bss  add1,b
 177 tstssc    bss  add2,c
 178 tstssg    bss  add4,g
 179 ssout     cw   23
 180           b    tstop
 181 add1      a    @1@,23
 182           b    tstssc
 183 add2      a    @2@,23
 184           b    tstssg
 185 add4      a    @4@,23
 186           b    ssout
 187 *
 188 * set up clear storage record
 189 *
 190 ltapop    cs   punch&80
 191           sw   grpmrk
 192           lca  grpmrk,punch&99
 193           lca  ident,punch&79
 194           lca  @  @
 195           lca  @b007@
 196           lca  @)021@
 197           lca  @b047l@
 198           lca  @l%u1001r@
 199           lca  @.@
 200           lca  bsptu1
 201 *
 202 * test object core size
 203 *
 204           c    22,@3@
 205           be   is4k
 206           bh   is4k
 207           c    22,@6@
 208           bl   is4k
 209           lca  @i0?@,punch&44
 210           lca  @099@
 211           lca  @b053@
 212           lca  @m074099@
 213           lca  @)099@
 214           lca  @b001/@
 215           lca  @c004041@
 216           lca  @#044004@
 217           lca  @/i9i@
 218           bce  btstrp,22,6
 219           bce  is12k,22,5
 220           mz   zone-2,punch&4
 221           b    btstrp
 222 is12k     mz   zone-1,punch&4
 223           b    btstrp
 224 is4k      lca  @i0@,punch&75
 225           lca  @b053@,punch&46
 226           lca  @m080099@
 227           lca  @)099@
 228           lca  @b001@
 229           lca  @b0320020@
 230           lca  @)002@
 231           lca  @a075003@
 232           lca  @,002@
 233           lca  @/i99@
 234           sw   punch&80
 235           bce  btstrp,22,3
 236           mcw  @z@,punch&2
 237           bce  btstrp,22,2
 238           mcw  @t@,punch&2
 239           bce  btstrp,22,1
 240           mcw  @i@,punch&2
 241 *
 242 * set up bootstrap program
 243 *
 244 btstrp    b    write1
 245           cw   punch&99
 246           lca  grpmrk,punch&80
 247           lca  @ @,punch&24
 248           lca  @.020@
 249           lca  ber1
 250           lca  rdrec
 251           lca  @.@
 252           lca  bsptu1
 253           b    write1
 254           cs   punch&75
 255           lca  @ @,punch&35
 256           lca  @b007@
 257           lca  @n000@
 258           lca  @l      @
 259           lca  ber1
 260           lca  rdrec
 261           lca  @.@
 262           lca  bsptu1
 263 *
 264 * test processor core size
 265 *
 266           c    21,@3@
 267           be   start
 268           bh   start
 269           c    21,@6@
 270           bl   start
 271           mn   21,savezn#1
 272           a    &3,savezn
 273           mn   savezn,*&4
 274           mz   zone,*&7
 275           lca  grpmrk,grpmrk
 276           cw   grpmrk
 277           mcw  @400@,kblkng
 278           bce  start,21,4
 279           a    @400@,kblkng
 280 *
 281 * set parameters
 282 *
 283 start     bce  pnh4op,23,4
 284           bce  pnh4op,23,5
 285           bce  pnh4op,23,6
 286           bce  pnh4op,23,7
 287 tstlsw    bw   eojob,ltapsw
 288           mcw  kblkng,blkct
 289           cs   80
 290           bw   setinp,jobsw
 291           rt   intape,input
 292 setinp    sw   image&23,image&57
 293           sw   image&62,image&67
 294           sw   image&68,image&71
 295           sw   image&74,image&6
 296           sw   image&1
 297           b    get
 298 *
 299 * analyze record type
 300 *
 301 analyz    bce  bypass,type,%
 302           bm   bypass,image&5
 303           bce  instr,type,
 304           bce  dojob,type,i
 305           mn   type,xr2
 306           a    xr2
 307           a    xr2
 308           b    *&1&x2
 309           b    da
 310           b    const
 311           b    dsa
 312           b    exend
 313           b    bypass
 314           b    bypass
 315           b    bypass
 316           b    bypass
 317           b    xtra
 318           b    bypass
 319 dojob     mcw  image&20,punch&79
 320           b    bypass
 321 *
 322 * process instructions
 323 *
 324 instr     mcw  dmod,punch&42
 325           mcw
 326           mcw
 327           mcw
 328           mcw  labadd,cnvadd
 329           a    count,cnvadd
 330           s    @1@,cnvadd
 331 instxt    b    setloc
 332           b    write2
 333           b    bypass
 334 *
 335 * process constants
 336 *
 337 const     a    @00@,count
 338           c    count,@00@
 339           bl   *&5
 340           b    bypass
 341           bce  pchcon,image&23,#
 342           bwz  pchcon,image&4,b
 343           mcw  image&53,holddt-22
 344           bce  alpha,image&23,@
 345           b    pchcon
 346 alpha     mcw  &holddt-51,xr1
 347           a    count,xr1
 348           mcw  blank1#1,xxxx&x1
 349 pchcon    mcw  holddt-20,punch&66
 350           mcw  labadd,cnvadd
 351           c    count,@32@
 352           bl   large
 353           bce  prodc,type,a
 354           b    instxt
 355 *
 356 * constants larger than 32 characters
 357 *
 358 large     s    @32@,count
 359           s    count,cnvadd
 360           mcw  count,holdct#2
 361           mcw  @32@,count
 362           b    setloc
 363           bce  lrgdc,type,a
 364 lrgxt     mcw  holdct,count
 365           mcw  holddt,temp#20
 366           b    write2
 367           mcw  temp,punch&54
 368 *
 369 * process dc
 370 *
 371 prodc     mcw  labadd,cnvadd
 372           s    count,cnvadd
 373           a    @1@,cnvadd
 374           b    cnvrt
 375           mcw  cnvwk,punch&30
 376           mcw  @)@
 377           mcw  labadd,cnvadd
 378           b    instxt
 379 *
 380 * dc greater than 32 characters
 381 *
 382 lrgdc     mcw  labadd,cnvadd
 383           s    holdct,cnvadd
 384           s    @31@,cnvadd
 385           b    cnvrt
 386           mcw  cnvwk,punch&30
 387           mcw  @)@
 388           b    lrgxt
 389 *
 390 * extra constant for constant over 32 characters
 391 *
 392 xtra      bce  bypass,image&21,
 393           mcw  image&73,holddt#52
 394           chain6
 395           b    bypass
 396 *
 397 * process dsa
 398 *
 399 dsa       mcw  bop,punch&37
 400           bce  prodc,type,b
 401           mcw  labadd,cnvadd
 402           b    instxt
 403 *
 404 * process define area
 405 *
 406 da        bce  bypass,type,!
 407           bce  header,type,0
 408 *
 409 * field, field repeat
 410 *
 411 field     mcw  supadd,cnvadd
 412           b    dartn
 413           bce  field,type,'
 414           b    analyz
 415 *
 416 * header, header repeat
 417 *
 418 header    mcw  labadd,cnvadd
 419           b    dartn
 420           bce  header,type,'
 421           b    analyz
 422 *
 423 * da subroutine
 424 *
 425 dartn     sbr  daxt&3
 426           b    cnvrt
 427           mcw  cnvwk,punch&26
 428           mcw  cnvwk
 429           mcw  @,@
 430           b    write2
 431           b    get
 432 daxt      b    xxxx
 433 *
 434 * process ex, end
 435 *
 436 exend     bce  end,type,3
 437           mcw  aop,punch&30
 438           mcw  @b@
 439           mcw  @n000000@
 440           b    write2
 441           lca  @ @,punch&24
 442           lca  @b007@
 443           b    get
 444           bce  isjob,type,i
 445 compat    b    write1
 446           lca  @l      @,punch&26
 447           b    analyz
 448 isjob     mcw  image&20,punch&79
 449           b    compat
 450 *
 451 * end
 452 *
 453 end       mcw  @/   080@,punch&26
 454           mcw  aop,punch&23
 455           b    write2
 456           wtm  outape
 457 eojob     bw   punch4,pnh4sw
 458           b    endjob
 459 *
 460 * punch new source deck
 461 *
 462 punch4    cs   punch&80
 463           mcw  @113@,lgtck&6
 464           rt   4,punch&1
 465           b    chklgt
 466           ber  tperr
 467           bce  dolto,punch&75,l
 468           bce  punch4,punch&75,s
 469           bce  punch4,punch&75,c
 470           bce  punch4,punch&75,z
 471           bce  punch4,punch&75,y
 472 bump      a    &1,seqct-1
 473           mcw  seqct,punch&5
 474           bce  dopch,punch&6,*
 475           mcw  blank4#4,punch&15
 476           c    punch&18,@job@
 477           bu   dopch
 478           mcw  blank4,punch&11
 479           mcw  blank4-2
 480 dopch     mcw  blank4-1,punch&75
 481           p
 482           ss   4
 483           c    punch&18,@end@
 484           bu   punch4
 485           bce  punch4,punch&6,*
 486           cs   punch&80
 487           p
 488           ss   8
 489           b    endjob
 490 dolto     mcw  @ltorg@,punch&20
 491           b    bump
 492           dcw  @ @
 493 endf1     dcw  @}@
 494           xfr  librn
 495           job  1401 autocoder-pass 8-load tape-left main -version 3   3781l
 496           org  2000
 497 outopn    dcw  @ @
 498 ssop      dcw  @b@
 499           rtw  1,1
 500           nop  xxxx
 501           ber  tperr
 502           cw   endf1,endf2
 503           b    initlz
 504 *
 505 * write clear storage and bootstrap
 506 *
 507 write1    sbr  wt1xt&3
 508           wtw  outape,output
 509           nop  xxxx
 510           ber  tperr
 511 wt1xt     b    xxxx
 512 *
 513 * go back to pass e for extra output
 514 *
 515 endjob    rtw  1,333
 516           nop  xxxx
 517           ber  tperr
 518           b    messag
 519 *
 520 * retrieve input record
 521 *
 522 get       sbr  getxt&3
 523           c    blkct,kblkng
 524           bu   nxtrec
 525           s    holda
 526           mcw  &input&13,lgtck&6
 527           rt   intape,input
 528           b    chklgt
 529           ber  tperr
 530 nxtrec    a    &80,blkct
 531           mcw  blkct,xr3
 532           mcw  input-1&x3,image&80
 533           chain8
 534           s    xr3&1
 535           s
 536           s
 537 getxt     b    xxxx
 538 *
 539 * do next record
 540 *
 541 bypass    b    get
 542           b    analyz
 543 *
 544 * set addresses in output
 545 *
 546 setloc    sbr  locxt&3
 547           b    cnvrt
 548           mcw  cnvwk,punch&26
 549           za   &34,cnvadd
 550           a    count,cnvadd
 551           b    cnvrt
 552           mcw  cnvwk,punch&23
 553 locxt     b    xxxx
 554 *
 555 * convert 5 to 3 digit address
 556 *
 557 cnvrt     sbr  cnvxt&3
 558           bav  *&1
 559 addagn    a    &96,cnvadd-3
 560           bav  addagn
 561           mz   cnvadd-4,cnvadd#5
 562           mn   cnvadd-3,*&4
 563           mz   zone,cnvadd-2
 564           mcw  cnvadd,cnvwk#3
 565 cnvxt     b    xxxx
 566 *
 567 * write output records
 568 *
 569 write2    sbr  wt2xt&3
 570           bce  dogm,punch&35,}
 571           wtw  outape,output&19
 572           nop  xxxx
 573           ber  tperr
 574           nop
 575 clear     mcw  blank1,punch&75
 576           mcw  punch&75
 577           mcw  blank1,holddt
 578           mcw  holddt
 579           mcw  @n000@,punch&30
 580           mcw  @l      @
 581 wt2xt     b    xxxx
 582 dogm      cs   299
 583           lca  punch&80,280
 584           lca
 585           mcw  punch&66,274
 586           lca  @ @
 587           lca  @b007@
 588           lca  @)043043@
 589           lca  punch&26
 590           lca  @,043@
 591           sw   225,235
 592           a    &8,227
 593           cw   225
 594           bce  wtgm,punch&27,n
 595           mcw  punch&30,237
 596 wtgm      cw   235
 597           wtw  outape,220
 598           nop  xxxx
 599           ber  tperr
 600           nop
 601           cw   280
 602           b    clear
 603 *
 604 * tape redundancy routine
 605 *
 606 tperr     sbr  xr2
 607           sbr  redxt&3
 608           mz   &9,xr2
 609           mcw  4000-10&x2,tpinst&7
 610           mn   tpinst&3,bsp1&3
 611           mcw  tpinst&7,inst2&7
 612 bsp1      bsp  initap
 613           bce  wrtred,tpinst&7,w
 614           mcw  &9,readct#1
 615 tpinst    rt   initap,xxxx
 616           ber  rdrerr
 617 redxt     b    xxxx
 618 rdrerr    mn   tpinst&3,bsp2&3
 619 bsp2      bsp  initap
 620           s    &1,readct
 621           bwz  tpinst,readct,b
 622           mn   tpinst&3,tphalt&6
 623 tphalt    h    xxxx,890
 624           mcw  tpinst&7,*&8
 625           rt   initap,xxxx
 626           bss  bsp1,e
 627           h    xxxx,811
 628           b    redxt
 629 wrtred    skp  1
 630           bce  subctr,wrtctr-1,5
 631           a    &1,wrtctr#2
 632 inst2     wt   initap,xxxx
 633           ber  bsp1
 634           b    redxt
 635 subctr    s    wrtctr
 636           mn   tpinst&3,*&7
 637           h    xxxx,860
 638           b    inst2
 639 *
 640 * check for short records
 641 *
 642 chklgt    sbr  xr2
 643           sbr  lgtxt&3
 644           mz   &9,xr2
 645 lgtck     bce  4000-12&x2,xxxx,}
 646           chain12
 647 lgtxt     b    xxxx
 648 ber1      dcw  @b001l@
 649 rdrec     dcw  @l%U1020r@
 650 bsptu1    dcw  @u%u1b@
 651 seqct     dcw  @0100 @
 652 kblkng    dcw  080
 653 holda     dcw  &0000
 654 blkct     equ  holda-1
 655 grpmrk    dc   @}@
 656           ltorg*
 657 *
 658 * input area
 659 *
 660 input     equ  *&1
 661 endf2     equ  3998
 662 3998      dcw  @}@
 663           xfr  librn
 664           job  1401 autocoder-pass 8 extra output overlay-version 3   3783l
 665           org  333
 666 *
 667 * print end of job messages
 668 *
 669 messag    cc   1
 670           cs   332
 671           cs
 672           mcw  @end of assembly@,print&15
 673           w
 674           cc   k
 675           mcw  @if extra output desired, set sense@,print&34
 676           mcw  @switch f on, and@, print&51
 677           w
 678           cc   j
 679           cs   print&71
 680           mcw  @b on for condensed cards@,print&24
 681           w
 682           mcw  @c on for loadable tape 6@,print&24
 683           w
 684           mcw  @d on for listing tape  3@,print&24
 685           w
 686           mcw  @e on to suppress listing@,print&24
 687           w
 688           mcw  @g on for new source deck@,print&24
 689           w
 690           cc   j
 691           cs   print&24
 692           mcw  @and press start@,print&15
 693           w
 694           cc   k
 695           mcw  @if no extra output desired, press start@,print&39
 696           w
 697           cc   1
 698           cw   grpmrk
 699           h    xxxx,880
 700           bss  gotoe,f
 701           cs   print&39
 702           mcw  @end of job@,print&10
 703           w
 704           cc   k
 705           mcw  @input for re-assembly on tape unit 4@,print&36
 706           w
 707           rwd  1
 708           rwd  4
 709           rwd  5
 710           rwd  6
 711           bw   final,ltapsw
 712           cs   236
 713           mlc  @loadable tape on tape unit 6@,print&28
 714           cc   k
 715           w
 716 final     cc   1
 717           h    xxxx,889
 718           b    final&2
 719 gotoe     cw   endf2,endf3
 720           cw   input&80
 721           cs   punch&99
 722           bsp  1
 723           bsp  1
 724           bsp  1
 725           bsp  1
 726           bsp  1
 727           bsp  1
 728           bsp  1
 729           bsp  1
 730           rtw  1,passe
 731           ber  tperr2
 732           b    passe&1
 733 tperr2    mcw  &9,readc#1
 734           bsp  1
 735 retry     rtw  1,passe
 736           ber  again
 737           b    passe&1
 738 again     bsp  1
 739           s    &1,readc
 740           bwz  retry,readc,b
 741           h    xxxx,891
 742           rtw  1,passe
 743           bss  tperr2,e
 744           h    xxxx,812
 745           b    passe&1
 746           ltorg*
 747 endf3     dcw  @}@
 748 passe     equ  1900
 749           ex   librn
 750           end  librn
