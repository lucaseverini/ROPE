 101 000       JOB  1401 autocoder-pass 1-generate system tape-version 3   3711l
 102           ctl  630 1
 103 systp     equ  %u1
 104 card      equ  0
 105 print     equ  200
 106           org  87
 107 xr1       dcw  000
 108           dc   00
 109 xr2       dcw  000
 110           dc   00
 111 xr3       dcw  000
 112           dc   000000
 113 zone      dcw  @2skb@
 114 abit      equ  zone-2
 115 nobit     equ  zone-3
 116 xxxx      equ  0
 117 *
 118 * Start of main line
 119 *
 120           org  333
 121 start     rwd  systp
 122           cc   1
 123           mcw  @generating 1401 autocoder system@,print&32
 124           w
 125           cc   1
 126           cs   print&132
 127           cs
 128           mcw  card&75,seqno#4
 129 *
 130 * start up next block
 131 *
 132 nxtbk     r
 133           c    card&12,@control@
 134           bu   macro
 135           bwz  ckseq,card&80,2   Comment out to turn off seq chk
 136           bce  eojob,card&78,9
 137           sw   card&21
 138           za   card&25,hold5#5
 139           cw   card&21
 140 *
 141 * float address to five characters
 142 *
 143 float     bce  *&5,hold5,&
 144           b    comp1
 145           za   hold5-1,hold5
 146           b    float
 147 *
 148 * test address against home address
 149 * to develop index value
 150 *
 151 comp1     mz   nobit,hold5
 152           s    xr1&2
 153           c    hold5,@01500@
 154           be   docor
 155           bh   sub1
 156           s    @01500@,hold5
 157           mcw  @16000@,work5#5
 158 sub2      s    hold5,work5
 159 *
 160 * convert index value to 3 digit machine address
 161 *
 162 cnvrt     bav  *&1
 163           a    @96@,work5-3
 164           bav  cnvrt&5
 165           mz   work5-4,work5
 166           mn   work5-3,*&4
 167           mz   zone,work5-2
 168           mcw  work5,xr1
 169           b    docor
 170 sub1      mcw  @01500@,work5
 171           b    sub2
 172 *
 173 * read condensed cards
 174 *
 175 docor     r
 176           mcw  @045@,xr3
 177           mcw  @042@,xr2
 178           bwz  ckseq,card&80,2   Comment out to turn off seq chk
 179           bce  wtap1,card&68,b
 180           bce  setwm,card&40,n
 181           c    card&46,@001@
 182           be   setwm
 183           mz   abit,card&45
 184 *
 185 * set return address
 186 *
 187 setwm     mcw  &docor,card&71
 188           mcw  @B@
 189 *
 190 * index word mark addresses
 191 *
 192 comp2     c    xr2,@063@
 193           be   card&40
 194           a    &7,xr3
 195           a    &7,xr2
 196           c    card&1&x2,@040@
 197           be   *&8
 198           mz   abit,card&x2
 199           c    card&1&x3,@040@
 200           be   comp2
 201           mz   abit,card&x3
 202           b    comp2
 203 *
 204 * write core on tape
 205 *
 206 wtap1     lca  @}@,3998
 207           wtw  systp,1500
 208           ber  wterr
 209 *
 210 * clear input area
 211 *
 212           mcw  @I99@,clear&3
 213 clear     cs   xxxx
 214           sbr  clear&3
 215           c    clear&3,@u99@
 216           bu   clear
 217           b    nxtbk
 218 *
 219 * check card sequence
 220 *
 221 ckseq     sbr  seqxt&3
 222           a    &1,seqno
 223           c    card&75,seqno
 224           mcw  card&75,seqno
 225           bu   seqer
 226 seqxt     b    xxxx
 227 *
 228 * card sequence error
 229 *
 230 seqer     mcw  card&80,print&80
 231           chain6
 232           mcw  @sequence error@,print&98
 233           w
 234           h    0,176
 235           b    doseq
 236 *
 237 * process macro library
 238 *
 239 macro     nop  crder
 240           c    card&20,@headr@
 241           bu   crder
 242           bwz  ckseq,card&80,2  comment out to turn of seq chk
 243           mcw  @B@,macro
 244           lca  @}@,81
 245 *
 246 * write skeleton instructions on tape
 247 *
 248 wtap2     wt   systp,card&1
 249           ber  wterr
 250           c    card&11,@999999@
 251           be   wttm
 252           r
 253           bwz  ckseq,card&80,2  comment out to turn of seq chk
 254           b    wtap2
 255 wttm      wtm  systp
 256           b    nxtbk
 257 *
 258 * end of generation
 259 *
 260 eojob     wtm  systp
 261           rwd  systp
 262           cw   @}@
 263           cs   print&132
 264           cs
 265           mcw  @1401 autocoder system generated on tape unit 1@,246
 266           w
 267           cc   1
 268 *
 269 * final halt
 270 *
 271 halt      h    0,142
 272           b    halt
 273 *
 274 * missing control card
 275 *
 276 crder     cs   print&132
 277           cs
 278           mcw  @system control card missing@,print&27
 279           w
 280 halt2     h    0,177
 281           b    halt2
 282 *
 283 * after sequence error, check balance of deck
 284 *
 285 doseq     r
 286           bwz  ckseq,card&80,2
 287           bce  endsq,card&78,9
 288           b    doseq
 289 endsq     h    0,152
 290           b    endsq
 291 *
 292 * write redundancy routine
 293 *
 294 wterr     sbr  wtxt&3
 295           sbr  xr3
 296           mz   &9,xr3
 297           mcw  4000-6&x3,retry&7
 298 bsp       bsp  systp
 299           skp  systp
 300           bce  subct,wtct-1,1
 301           a    &1,wtct#2
 302 retry     wt   systp,xxxx
 303           ber  bsp
 304 wtxt      b    xxxx
 305 subct     s    wtct
 306           h    0,161
 307           b    retry
 308           ex   start
 309           job  autocoder-pass 1 select program           -version 3   3712l
 310           sfx  b
 311 passa     equ  1650
 312 dopsa     equ  1900
 313 systp     equ  %u1
 314 *
 315 * branch from tape load routine
 316 *
 317           org  1
 318           b    333
 319           h    *-3
 320 loadd     dcw  @599@
 321           org  87
 322 xr1       dcw  000
 323           dc   00
 324           dcw  000
 325           dc   00
 326           dcw  000
 327           dc   00
 328 *
 329 * begin program
 330 *
 331           org  333
 332           ber  halt1
 333           sw   gmrk1
 334 clear     cs   3999
 335           sbr  clear&3
 336           c    clear&3,@U99@
 337           bu   clear
 338 *
 339 * get past library
 340 *
 341 loop1     sw   gmrk1
 342           rt   systp,gmrk1-21
 343           c    gmrk1-2,@999999    headr@
 344           bu   loop1
 345           sw   gmrk1
 346           rt   systp,gmrk1-1
 347           bef  tstss
 348           b    loop1
 349 *
 350 * redundancy on tape load
 351 *
 352 halt1     h    0,199
 353           b    halt1
 354 tstss     bss  librn,f
 355 *
 356 * retrieve pass 2 for assembly run
 357 *
 358           sw   gmrk1
 359           lca  gmrk1,3998
 360           mcw  &passa&13,nois2&6
 361 *
 362 * get past librarian
 363 *
 364 loop2     bce  lopsa,byct,4
 365           sw   3998
 366           rtw  systp,passa
 367           b    noise
 368           a    &1,byct#1
 369           b    loop2
 370 *
 371 * pass 2 found
 372 *
 373 lopsa     rtw  systp,passa
 374           b    noise
 375           ber  rderr
 376           cw   gmrk1
 377 clr       cs   passa-1
 378           sbr  clr&3
 379           c    clr&3,loadd
 380           bu   clr
 381           b    dopsa
 382 *
 383 * library run
 384 *
 385 librn     mcw  @!13@,nois2&6
 386           cw   gmrk1
 387           bss  outpt,b
 388 *
 389 * retrieve update program
 390 *
 391           rtw  systp,2000
 392           b    noise
 393           ber  rderr
 394           b    2000
 395 *
 396 * retrieve output program
 397 *
 398 outpt     rtw  systp,2000
 399           b    noise
 400           sw   gmrk1
 401           lca  gmrk1,3998
 402           rtw  systp,2000
 403           b    noise
 404           rtw  systp,2000
 405           b    noise
 406           sw   3998
 407           rtw  systp,2000
 408           b    noise
 409           ber  rderr
 410           cw   gmrk1,3998
 411           b    2000
 412 *
 413 * test for noise records
 414 *
 415 noise     sbr  nosxt&3
 416           sbr  xr1
 417           mz   &9,xr1
 418 nois2     bce  4000-12&x1,0,}
 419           chain12
 420 nosxt     b    0
 421 *
 422 * read redundancy routine
 423 *
 424 rderr     sbr  xr1
 425           sbr  rdxt&3
 426           mz   &9,xr1
 427           mcw  4000-10&x1,rdtry&7
 428 bsp       bsp  systp
 429           mcw  &9,rdct#1
 430 rdtry     rtw  systp,0
 431           ber  *&5
 432 rdxt      b    0
 433           bsp  systp
 434           s    &1,rdct
 435           bwz  rdtry,rdct,b
 436           h    0,191
 437           mcw  rdtry&7,*&8
 438           rtw  systp,0
 439           bss  bsp,e
 440           h    0,111
 441           b    rdxt
 442           ltorg*
 443           dcw  #22
 444 gmrk1     dcw  @}@
 445           ex   0
 446           job  autocoder-pass 1 retrieve update          -version 3   3713l
 447           sfx  r
 448 systp     equ  %u1
 449 ltapsw    equ  2725
 450           org  2000
 451           bss  list,g
 452           cw   endrt
 453 start     rtw  systp,1
 454           bce  start,013,}
 455           chain12
 456           ber  rderr
 457           b    333
 458 rderr     bsp  systp
 459           mcw  &9,rdct#1
 460 rdtry     rtw  systp,1
 461           ber  *&5
 462           b    333
 463           bsp  systp
 464           s    &1,rdct
 465           bwz  rdtry,rdct,b
 466           h    0,191
 467 again     rtw  systp,1
 468           bss  rderr,e
 469           h    0,111
 470           b    333
 471 list      sw   endrt
 472           lca  endrt,1998
 473           rtw  systp,333
 474           bef  get
 475           b    list
 476 get       bsp  systp
 477           bsp  systp
 478           cw   endrt,1998
 479           sw   ltapsw
 480           mcw  @333@,rdtry&6
 481           mcw  @333@,again&6
 482           rtw  systp,333
 483           ber  rderr
 484           b    333
 485           ltorg*
 486 endrt     dcw  @}@
 487           ex   0
 488           job  autocoder-pass 1 copy system tape         -version 3   3714l
 489           sfx  u
 490           org  87
 491 xr1       dcw  000
 492           dc   00
 493 xr2       dcw  000
 494           dc   00
 495 xr3       dcw  000
 496           dc   00
 497 systp     equ  %u1
 498 outap     equ  %u6
 499 input     equ  1500
 500 *
 501 * begin program
 502 *
 503           org  333
 504           sw   endup
 505           rwd  systp
 506           rwd  outap
 507           cc   1
 508           cs   332
 509           cs
 510           b    clear
 511           bss  copy,c
 512 *
 513 * retrieve update program
 514 *
 515           rtw  systp,input
 516           sbr  xr1
 517           mn   0&x1
 518           sw
 519           dcw  @N0000@
 520           b    noise
 521           ber  rderr
 522           wtw  outap,input
 523           ber  wterr
 524           b    clear
 525 bypss     rtw  systp,input
 526           c    input&19,@999999    headr@
 527           bu   bypss
 528           rtw  systp,input
 529           bef  getup
 530           b    bypss
 531 getup     bce  ldupd,byct,3
 532           rtw  systp,input
 533           dcw  @N0000000000000@
 534           b    noise
 535           ber  rderr
 536           a    &1,byct#1
 537           b    getup
 538 ldupd     cs   199
 539           cs   80
 540           sw   6,16
 541           sw   21
 542           b    head
 543           b    begin
 544 *
 545 * copy system
 546 *
 547 copy      rtw  systp,input
 548           sbr  xr1
 549           mn   0&x1
 550           sw
 551           bef  eof
 552           b    noise
 553           ber  rderr
 554 *
 555 * test end of library
 556 *
 557 swich     nop  wtap1
 558           sw   libsw
 559           c    input&10,@999999@
 560           bu   wtap1
 561           cw   libsw#1
 562 *
 563 * write tape
 564 *
 565 wtap1     wtw  outap,input
 566           ber  wterr
 567 *
 568 * do next block
 569 *
 570 reout     b    clear
 571           b    copy
 572 *
 573 * end of file
 574 *
 575 eof       wtm  outap
 576           bw   ismor,eofsw#1
 577           b    clear
 578           lca  endup,3998
 579           bw   erase,updsw
 580           b    halt1
 581 *
 582 * erase tape
 583 *
 584 erase     skp  outap
 585           wt   outap,input
 586           bce  halt1,skpct-1,2
 587           a    &1,skpct#2
 588           b    erase
 589 *
 590 * end of copy run
 591 *
 592 halt1     mcw  @1401 autocoder system copied on tape unit 6@,243
 593           w
 594           cc   1
 595           bw   cpynd,updsw#1
 596           rwd  outap
 597 cpynd     rwd  systp
 598           h    0,122
 599           b    clear
 600           s    skpct
 601           mcw  @n@,swich
 602           sw   eofsw
 603           b    copy
 604 *
 605 * set up copy of rest of system
 606 *
 607 ismor     bw   bdeof,libsw
 608           cw   eofsw
 609           mcw  @b@,swich
 610           b    reout
 611 *
 612 * false end of file
 613 *
 614 bdeof     bsp  outap
 615           b    reout
 616 *
 617 * test for noise records
 618 *
 619 noise     sbr  nosxt&3
 620           sbr  xr2
 621           mz   &9,xr2
 622 nois2     bce  4000-26&x2,input&13,}
 623           chain12
 624 nosxt     b    0
 625 *
 626 * read redundancy routine
 627 *
 628 rderr     sbr  rdxt&3
 629           sbr  xr3
 630           mz   &9,xr3
 631           mcw  4000-24&x3,rdtry&7
 632           mn   rdtry&3,bsp1&3
 633 bsp1      bsp  systp
 634           mcw  &9,rdct#1
 635 rdtry     rt   systp,0
 636           ber  *&5
 637 rdxt      b    0
 638           mn   rdtry&3,bsp2&3
 639 bsp2      bsp  systp
 640           s    &1,rdct
 641           bwz  rdtry,rdct,b
 642           mn   rdtry&3,*&7
 643           h    0,190
 644           mcw  rdtry&7,*&8
 645           rt   systp,0
 646           bss  bsp1,e
 647           h    0,111
 648           b    rdxt
 649 *
 650 * write redundancy routine
 651 *
 652 wterr     sbr  wtxt&3
 653           sbr  xr3
 654           mz   &9,xr3
 655           mcw  4000-6&x3,wttry&7
 656           mn   wttry&3,bsp3&3
 657 bsp3      bsp  outap
 658           skp  systp
 659           bce  subct,wtct-1,1
 660           a    &1,wtct#2
 661 wttry     wt   outap,0
 662           ber  bsp3
 663 wtxt      b    0
 664 subct     s    wtct
 665           mn   wttry&3,*&7
 666           h    0,160
 667           b    wttry
 668 *
 669 * clear output area
 670 *
 671 clear     sbr  clrxt&3
 672           mcw  @I99@,clr&3
 673 clr       cs   3999
 674           sbr  clr&3
 675           c    clr&3,&input-1
 676           bu   clr
 677 clrxt     b    0
 678           ltorg*
 679 endup     dcw  @}@
 680           ex   0
 681           job  autocoder-pass 1 update library           -version 3   3715l
 682 image     equ  101
 683 *
 684 * begin update
 685 *
 686           org  input
 687 begin     rwd  systp
 688           cw   hedsw,endsw
 689           mcw  &image&13,nois2&6
 690           lca  endup,image&80
 691           rt   systp,image
 692           dcw  @N0000000000000@
 693           b    noise
 694           cs   image&79
 695           b    rdtp
 696 rebeg     b    read
 697           bw   serch,insw
 698           bw   serch,delsw
 699           b    rebeg
 700 *
 701 * search for correct subroutine
 702 *
 703 serch     b    doctl
 704           c    11,@999999@
 705           be   clnup
 706           c    8,name#3
 707           be   found
 708           bh   quit
 709           mcw  8,name
 710           s    seqno
 711 loop1     bw   headr,hedsw
 712           b    rdtp
 713           bw   headr,hedsw
 714 more      b    wtap2
 715           b    loop1
 716 *
 717 * header located on tape
 718 *
 719 headr     bw   past,endsw
 720           c    image&7,name
 721           be   found
 722           cw   hedsw
 723           bl   past
 724           b    more
 725 *
 726 * subroutine not on tape
 727 *
 728 past      bsp  systp
 729           cs   image&79
 730           cw   hedsw
 731           bw   unkwn,delsw
 732           c    22,@  @
 733           bu   unkwn
 734 back      b    ptctl
 735           b    inser
 736 *
 737 * subroutine found
 738 *
 739 found     c    22,@  @
 740           bu   partl
 741 *
 742 * delete and/or insert whole subroutines
 743 *
 744 all       mcw  @delet@,218
 745           b    ptctl
 746           s    seqno
 747 loop2     b    print
 748           b    rdtp
 749           bw   exit,hedsw
 750           b    loop2
 751 exit      bsp  systp
 752           cs   image&79
 753           cw   hedsw
 754           bw   rebeg,delsw
 755 *
 756 * insertion of whole subroutine
 757 *
 758           b    doctl
 759           b    ptctl
 760 inser     s    seqno
 761 loop3     b    read
 762           bw   serch,insw
 763           bw   serch,delsw
 764           b    doout
 765           b    print
 766           b    wtap2
 767           b    loop3
 768 *
 769 * delete and/or insert parts
 770 *
 771 partl     s    xr3&2
 772           bwz  some,21,2
 773           c    24,@  @
 774           be   all
 775           a    &2,xr3
 776           sw   23
 777 *
 778 * scan for values of operands
 779 *
 780 some      sw   opsw#1
 781 test1     bce  twoop,21&x3,,
 782           c    22&x3,@  @
 783           be   twoop
 784           a    &1,xr3
 785           b    test1
 786 twoop     za   20&x3,wk1#4
 787           a    @0@,wk1
 788           bce  nxtop,21&x3,,
 789           b    out
 790 nxtop     sw   22&x3
 791           sbr  xr2
 792 add       a    &1,xr3
 793           c    22&x3,@  @
 794           bu   add
 795           za   20&x3,wk2#4
 796           a    @0@,wk2
 797           c    wk1,wk2
 798           bl   badst
 799           be   onop
 800 is2op     cw   opsw
 801 clrwm     cw   1&x2
 802 out       cw   23
 803           bw   *&8,opsw
 804           mcw  @delet@,218
 805           b    ptctl
 806 *
 807 * search for first statement
 808 *
 809 comp      c    wk1,seqno
 810           be   gotit
 811           a    &1,seqno
 812           b    wtap2
 813           b    rdtp
 814           bw   ntfnd,hedsw
 815           b    comp
 816 *
 817 * first statement found
 818 *
 819 gotit     bw   qinsr,opsw
 820 *
 821 * search for second statement
 822 *
 823 comp2     b    print
 824           b    rdtp
 825           c    wk2,seqno
 826           bh   bspc
 827           bw   ntfnd,hedsw
 828           b    comp2
 829 *
 830 * second statement found
 831 *
 832 bspc      bsp  systp
 833           cs   image&79
 834           s    &1,seqno
 835 thru      bw   loop3,delsw
 836           b    doctl
 837           b    ptctl
 838           b    insr&4
 839 *
 840 * test insert or delete
 841 *
 842 qinsr     bw   insr,insw
 843           b    print
 844           s    &1,seqno
 845           cs   image&79
 846           b    thru
 847 *
 848 * insert statements
 849 *
 850 insr      b    wtap2
 851           b    read
 852           bw   serch,insw
 853           bw   serch,delsw
 854           b    doout
 855           cw   seqsw#1
 856           b    print
 857           s    &1,seqno
 858           b    insr
 859 onop      bw   is2op,insw
 860           sw   opsw
 861           b    clrwm
 862 *
 863 * replicate library
 864 *
 865 repet     b    wtap2
 866 clnup     b    rdtp
 867           b    wtap2
 868           bw   final,endsw
 869           b    clnup
 870 *
 871 * end of update - go to copy routine
 872 *
 873 final     wtm  outap
 874           mcw  &input&13,nois2&6
 875           cw   libsw,eofsw
 876           cw   updsw
 877           cs   332
 878           cs
 879           cc   1
 880 byp1      rt   systp,image
 881           bef  reout
 882           b    byp1
 883 *
 884 * set up insert card
 885 *
 886 doout     sbr  outxt&3
 887           mcw  80,image&79
 888           mcw
 889           mcw
 890 outxt     b    0
 891 *
 892 * read card subroutine
 893 *
 894 read      sbr  cdxt&3
 895           bw   rdcd,lstsw
 896           b    clnup
 897 rdcd      r
 898           cw   insw,delsw
 899           c    20,@inser@
 900           bu   ckdel
 901           sw   insw#1
 902           b    cdxt-5
 903 ckdel     c    20,@delet@
 904           bu   ckrep
 905           sw   delsw#1
 906           b    cdxt-5
 907 ckrep     c    20,@repet@
 908           be   repet
 909           blc  lstcd
 910 cdxt      b    0
 911 lstcd     cw   lstsw#1
 912           b    cdxt
 913 *
 914 * read tape subroutine
 915 *
 916 rdtp      sbr  rtxt&3
 917           rt   systp,image
 918           sw   image&80
 919           dcw  @n000000000@
 920           b    noise
 921           ber  rderr
 922           cw   hedsw,endsw
 923           c    image&19,@headr@
 924           bu   rtxt
 925           sw   hedsw#1
 926           c    image&10,@999999@
 927           bu   rtxt
 928           sw   endsw#1
 929 rtxt      b    0
 930 *
 931 * write tape subroutine
 932 *
 933 wtap2     sbr  wt2xt&3
 934           c    image&79,blank
 935           be   wt2xt
 936           wt   outap,image
 937           ber  wterr
 938           cs   image&79
 939 wt2xt     b    0
 940 *
 941 * print heading
 942 *
 943 head      sbr  hdxt&3
 944           cs   332
 945           cs
 946           mcw  @1401 autocoder - library changes@,251
 947           mcw  @page@,275
 948           a    &1,pgno#3
 949           mcs  pgno,279
 950           w
 951           cc   k
 952           cs   279
 953           mcw  @seq  label  op    operands@,227
 954           w
 955           cc   k
 956           cs   228
 957 hdxt      b    0
 958 *
 959 * set up control card for printing
 960 *
 961 doctl     sbr  ctlxt&3
 962           cc   k
 963           cs   332
 964           cs
 965           mcw  72,271
 966           mcw  22,221
 967           mcw  20,218
 968           mcw  11,212
 969 ctlxt     b    0
 970 *
 971 * print control card
 972 *
 973 ptctl     sbr  ptcxt&3
 974           w
 975           cc   j
 976           cs   332
 977           cs
 978           bcv  newpg
 979 ptcxt     b    0
 980 *
 981 * new page
 982 *
 983 newpg     sbr  newxt&3
 984           cc   1
 985           b    head
 986 newxt     b    0
 987 *
 988 * print statements
 989 *
 990 print     sbr  ptxt&3
 991           sw   220,214
 992           sw   207
 993           bce  comnt,image&5,*
 994           mcw  image&71,271
 995           mcw  image&19,218
 996           mcw  image&10,212
 997 tstsq     bw   seqnc,seqsw
 998           sw   seqsw
 999           b    bump
1000 comnt     mcw  image&71,273
1001           mcw
1002           mcw
1003           b    tstsq
1004 seqnc     mn   seqno,204
1005           mcs
1006 bump      a    &1,seqno#4
1007           w
1008           cs   332
1009           cs
1010           bcv  newpg
1011 ptxt      b    0
1012 *
1013 * sequence error
1014 *
1015 quit      cs   332
1016           cs
1017           mcw  @input cards out of sequence - start over@,240
1018           w
1019           cc   1
1020 halt2     h    0,133
1021           b    halt2
1022 *
1023 * subroutine unknown
1024 *
1025 unkwn     bwz  isunk,21,2
1026           c    24,@  @
1027           be   back
1028 isunk     mcw  @subroutine unknown@,299
1029           w
1030           cc   l
1031           cs   299
1032 loop4     b    read
1033           bw   serch,insw
1034           bw   serch,delsw
1035           b    loop4
1036 *
1037 * bad control card
1038 *
1039 badst     mcw  @bad statement@,299
1040           w
1041           cc   l
1042           cs   299
1043           cw   1&x2,23
1044           b    loop4
1045 *
1046 * statement does not exist in subroutine
1047 *
1048 ntfnd     mcw  @statement does not exist@,299
1049           w
1050           cc   l
1051           cs   299
1052           bw   end99,endsw
1053           b    loop4
1054 *
1055 * end of library reached before routine found
1056 *
1057 end99     mcw  @subroutine unknown@,299
1058           w
1059           cc   l
1060           cs   299
1061           mcw  @end of library reached@,222
1062           w
1063           bsp  systp
1064           cs   image&79
1065 loop6     b    read
1066           b    loop6
1067           dcw  #50
1068 blank     dc   #29
1069           ltorg*
1070 3998      dcw  @}@
1071           ex   0
1072           job  autocoder-pass 1 output library           -version 3   3716l
1073           sfx  p
1074 systp     equ  %u1
1075 xr1       equ  89
1076 *
1077 * begin program
1078 *
1079           org  2000
1080           sw   endot
1081           lca  endot,181
1082           cs
1083           cs   80
1084           sw   6,16
1085           cs   332
1086           cs
1087           cc   1
1088           rwd  systp
1089           rt   systp,101
1090           cs   180
1091           sw   106,116
1092           sw   121
1093           bss  doall,e
1094 *
1095 * print and/or punch selected macros
1096 *
1097           cw   hdrsw
1098 read      cc   1
1099           b    prthd
1100           r
1101           mcw  @2@,opcod
1102           c    20,@print@
1103           be   selmc
1104           c    20,@punch@
1105           bu   error
1106 *
1107 * punch option
1108 *
1109           a    &4,opcod
1110           mn   &4,opsav#1
1111 *
1112 * search for macro
1113 *
1114 selmc     c    8,name#3
1115           be   tstlc
1116           mcw  20,218
1117           mcw  11,212
1118           bl   rdtp2
1119           rwd  systp
1120           lca  endot,181
1121           rt   systp,101
1122           cs   180
1123           sw   106,116
1124           sw   121
1125 rdtp2     rt   systp,101
1126           b    noise
1127           ber  rderr
1128           c    111,@999999@
1129           be   unkn
1130           c    120,@headr@
1131           bu   rdtp2
1132           c    8,108
1133           bu   rdtp2
1134 *
1135 * desired macro found
1136 *
1137           mcw  8,name
1138           cc   k
1139           w
1140           s    seqno
1141           b    inser
1142           cc   k
1143 ptagn     b    print
1144           rt   systp,101
1145           b    noise
1146           ber  rderr
1147           c    120,@headr@
1148           bu   ptagn
1149           bsp  systp
1150 *
1151 * test end of run
1152 *
1153 tstlc     blc  eojob
1154           b    read
1155 *
1156 * macro not on tape
1157 *
1158 unkn      mcw  @unknown@,299
1159           w
1160           cs   299
1161           mcw  @999@,name
1162           b    tstlc
1163 *
1164 * print and/or punch all or print headers only
1165 *
1166 doall     bss  setup,d
1167           cw   hdrsw#1
1168           bss  *&5,g
1169           b    setup
1170 *
1171 * punch all
1172 *
1173           a    &4,opcod
1174           mn   &4,opsav
1175 setup     b    head1
1176           cw   hdsw1#1
1177           b    prthd
1178 rdtp      rt   systp,101
1179           b    noise
1180           ber  rderr
1181           c    111,@999999@
1182           be   eojob
1183           c    120,@headr@
1184           bu   dopnt
1185           b    inser
1186           cc   k
1187           sbr  prtxt&3,*&6
1188           bcv  newpg
1189           s    seqno#4
1190 dopnt     b    print
1191           sw   106,116
1192           sw   121
1193           b    rdtp
1194 *
1195 * end of job
1196 *
1197 eojob     cs   332
1198           cs
1199           cc   k
1200           mcw  @end of library@,214
1201           w
1202           cc   1
1203           cs   180
1204           bce  clrph,opsav,4
1205 rwd       rwd  systp
1206 halt      h    0,155
1207           b    halt
1208 clrph     p
1209           ss   8
1210           b    rwd
1211 *
1212 * incorrect input card
1213 *
1214 error     h    0,144
1215           b    tstlc
1216 inser     sbr  insxt&3
1217           mcw  @     @,105
1218           mcw  @inser@,120
1219           bce  *&5,opsav,4
1220           b    *&2
1221           p
1222           mcw  @headr@,120
1223 insxt     b    0
1224 *
1225 * print heading
1226 *
1227 prthd     sbr  hdxt&3
1228           mcw  @seq  label  op    operands@,227
1229           w
1230           cc   k
1231           cs   228
1232 hdxt      b    0
1233 *
1234 * print statement
1235 *
1236 print     sbr  prtxt&3
1237           c    120,@headr@
1238           be   dohdr
1239           bw   clr,hdrsw
1240 dohdr     cs   332
1241           cs
1242           bce  comnt,106,*
1243           mcw  172,271
1244           mcw  120,218
1245           mcw  111,212
1246 doseq     mn   seqno,204
1247           mcs
1248           mn   seqno,104
1249           mcw
1250           a    &1,seqno
1251           mcw  @ @,105
1252 opcod     w
1253 clr       cs   332
1254           cs
1255           bcv  newpg
1256 prtxt     b    0
1257 comnt     mcw  172,273
1258           mcw
1259           mcw
1260           b    doseq
1261 *
1262 * start new page
1263 *
1264 newpg     cc   1
1265           bw   *&5,hdsw1
1266           b    head1
1267           b    prthd
1268           b    prtxt
1269 *
1270 * print main heading
1271 *
1272 head1     sbr  hd2xt&3
1273           cs   332
1274           cs
1275           mcw  @1401 autocoder - library@,243
1276           mcw  @page@,275
1277           a    &1,pgno#3
1278           mcs  pgno,279
1279           w
1280           cc   l
1281           cs   299
1282 hd2xt     b    0
1283 *
1284 * test for noise records
1285 *
1286 noise     sbr  nosxt&3
1287           sbr  xr1
1288           mz   &9,xr1
1289           bce  4000-12&x1,113,}
1290           chain12
1291 nosxt     b    0
1292 *
1293 * read redundancy routine
1294 *
1295 rderr     sbr  rdxt&3
1296 bsp       bsp  systp
1297           mcw  &9,rdct#1
1298 rdtry     rt   systp,101
1299           ber  *&5
1300 rdxt      b    0
1301           bsp  systp
1302           s    &1,rdct
1303           bwz  rdtry,rdct,b
1304           h    0,191
1305           rt   systp,101
1306           bss  bsp,e
1307           h    0,111
1308           b    rdxt
1309           ltorg*
1310 endot     dcw  @}@
1311           ex   0
1312           end  0
