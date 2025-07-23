 101 003       job  1401 autocoder-pass 3-translator-initial  -version 3   3731l
 102           ctl  630 1
 103 *
 104 *equates
 105 *
 106 intape    equ  %u6
 107 outape    equ  %u4
 108 systap    equ  %u1
 109 initap    equ  %u0
 110 xxxx      equ  0000
 111 print     equ  200
 112 librn     equ  000
 113 *
 114 *tape redundancy routine
 115 *
 116           org  rtend&1
 117 tperr     sbr  xl3
 118           sbr  redxt&3
 119           mz   &9,xl3
 120           mcw  4000-10&x3,tpins&7         bring in instruction
 121           mn   tpins&3,bsp1&3              that caused
 122           mcw  tpins&7,inst2&7             redundancy
 123 bsp1      bsp  initap                     backspace tape
 124           bce  wrtrd,tpins&7,w            q. write redundancy
 125           mcw  &9,rdct#1                  initialize counter
 126 tpins     rt   initap,xxxx                re-read
 127           ber  rderr                      q. redundancy again
 128 redxt     b    xxxx                       exit
 129 rderr     mn   tpins&3,bsp2&3
 130 bsp2      bsp  initap                     backspace again
 131           s    &1,rdct                    reduce counter
 132           bwz  tpins,rdct,b               q. 10 successive reads
 133           mn   tpins&3,tphlt&6
 134 tphlt     h    xxxx,390                   halt
 135           mcw  tpins&7,*&8
 136           rt   initap,xxxx                re-read
 137           bss  bsp1,e                     determine option
 138           h    xxxx,302                   halt again
 139           b    redxt                      exit
 140 wrtrd     skp  systap                     erase tape
 141           bce  sbctr,wrtcr-1,5            q. fifty skips
 142           a    &1,wrtcr#2                 increase counter
 143 inst2     wt   initap,xxxx                re-write
 144           ber  bsp1                       q. redundancy again
 145           b    redxt
 146 sbctr     s    wrtcr                      reset counter
 147           mn   tpins&3,*&7
 148           h    xxxx,360                   halt
 149           b    inst2
 150 *
 151 * noise record routine
 152 *
 153 noise     sbr  xl3
 154           sbr  nsxt&3
 155           mz   &9,xl3
 156 n2        bce  4000-12&x3, xxxx, }        scan for group mark
 157           chain12
 158 nsxt      b    0
 159 objcor    dcw  @3@                        object core size code
 160 hival     dcw  @  999@                    highest object address
 161 manam     dcw  @#@                        equals # or A
 162           ltorg*
 163 *
 164 *begin     of main line
 165 *
 166 begin     rwd  intape                     rewind input tape
 167           rwd  5                          rewind 5
 168           cs   3999                       clear input area
 169           rtw  systap,001                 read lower half
 170           nop  0                           pass 3
 171           ber  tperr
 172           sw   gmk1,gmk2                  initialize group marks
 173           cw   sysmk2
 174           cs   080                        clear read area
 175           sw   eqvadd                     initialize to undef
 176           rwd  outape                     rwd output tape
 177           mcw  &free&13,n2&6
 178           mcw  @n@,n3                     cripple test for noise
 179           mcw  @n@,n4
 180           rt   5,free&1                   read in macro factor
 181           b    noise                       which is
 182           ber  tperr                       passed in from pass 2
 183           rwd  5                           and save value
 184           mcw  free&3,joblbl#3
 185           za   @101@,altrno               reset alter number
 186 *
 187 * process job card
 188 *
 189           b    get                        get first record
 190           bce  genjob,free&6,*            q. comments card
 191           c    free&18,@job@              q. job card
 192           bu   genjob
 193 codjob    mcw  joblbl,free&8              pickup factoor
 194           wt   outape,free&1              put job card
 195           nop  0
 196           ber  tperr
 197           a    &1,altrno
 198           b    get                        get next record
 199           mcw  @b@,n3                     reset noise routine
 200           mcw  @m@,n4
 201 *
 202 *process control card
 203 *
 204           c    free&18,@ctl@              q. control card
 205           bu   chnad
 206           cs   0
 207           sbr  clear&3
 208           sbr  svsz#3
 209           bwz  prosz,clear&3,2
 210 clear     cs   15999
 211           sbr  clear&3                    clear above 4k
 212           c    clear&3,@i99@              q. end of clearing
 213           bu   clear
 214 prosz     mcw  @6@,phold#1
 215           bwz  csz,svsz,b
 216           mcw  @5@,phold
 217           bwz  csz,svsz,k
 218           mcw  @4@,phold
 219           bwz  csz,svsz,s
 220           mcw  @3@,phold
 221 csz       c    free&21,phold
 222           be   inobj
 223 *         messg@incorrect processor machine size specified@,42
  02           cs   332
  03           cs
  04           mcw  @incorrect processor machine size specified@,42&200
  05           w
  07           bcv  *&5
  08           b    *&3
  09           cc   1
 224           mcw  phold,free&21
 225 inobj     mcw  free&22,objcor             save object machine code
 226           za   objcor,xl1
 227           s    &30,xl1&1
 228           a    xl1                        code -hival-
 229           mcw  objtbl&x1,hival-3
 230           c    free&22,@3@                q. object core gt 4k
 231           bl   getmn
 232           bce  sethi,free&24,1            q. ma hardware
 233           b    is4k
 234 genjob    bsp  intape
 235           mcw  free&74,free&73
 236           mcw  @job  @,free&20            generate job card
 237           mcw
 238           mcw  free&74,free&15            blank area
 239           mcw
 240           b    codjob
 241 chnad     mcw  &subxl,intxt&3             initialize exit
 242 is4k      mcw  @a@,manam
 243 sethi     mcw  @03@,hival-3
 244           b    getmn
 245 objtbl    dcw  @03@
 246           dcw  @07@
 247           dcw  @11@
 248           dcw  @15@
 249           ltorg2918  *
 250 sysmk2    dcw  @}@                        system group mark
 251           xfr  000
 252           job  1401 autocoder-pass 3 left main line      -version 3   3732l
 253 *
 254 *initialization of index registers
 255 *
 256 *         xinitxl1,xl2,xl3
  01 xl1       equ  089
  02 089       dcw  000
  04 091       dc   00
  05 xl2       equ  094
  06 094       dcw  000
  08 096       dc   00
  09 xl3       equ  099
  10 099       dcw  000
  12 100       dc   0
 257 *
 258 *free form input area
 259 *
 260           org  101
 261 free      equ  100
 262           da   1x86
 263                1,1
 264                19,19
 265                16,16
 266                6,6
 267                21,21
 268 altrno         81,84
 269                85,89
 270 gmk2      dc   @}@
 271 *
 272 *fixed form input area
 273 *
 274           org  333
 275 input     equ  *
 276           da   1x86
 277                40,40
 278                17,17
 279                28,28
 280                39,39
 281                76,76
 282 *
 283 * get upper half of pass 3
 284 *
 285 getmn     rtw  systap,begin
 286           nop  0
 287           ber  tperr
 288           mcw  manam,masym-3
 289           rtw  systap,ovl2
 290           nop  0
 291           ber  tperr
 292 intxt     b    nurec
 293 *
 294 * get fixed form overlay
 295 *
 296 gtfix     rtw  systap,ovl2
 297           nop  0
 298           ber  tperr
 299           bsp  systap
 300           bsp  systap
 301           bw   profix,freesw
 302           b    rstmod
 303 *
 304 * get free form overlay
 305 *
 306 gtfre     rtw  systap,ovl2
 307           nop  0
 308           ber  tperr
 309           b    pstnu
 310 *
 311 *get routine
 312 *
 313 get       sbr  getxt&3
 314           b    rdtap
 315           mcw  inarea&79,free&80
 316           chain4
 317           mcw  inarea&85,free&86
 318 getxt     b    xxxx
 319 rdtap     sbr  rdxt&3                     read tape
 320 n4        mcw  &inarea&12,n2&6
 321           rt   intape,inarea
 322 n3        b    noise                      check for noise
 323           ber  tperr
 324 rdxt      b    xxxx
 325 *
 326 *put routine
 327 *
 328 put       sbr  putxt&3
 329           cw   free&21
 330           wt   outape,free&1
 331           nop  0
 332           ber  tperr
 333           sw   free&21
 334           a    &1,altrno                  increase alter number
 335 putxt     b    xxxx
 336 ovl2      dcw  0
 337           dcw  @}@                        system group mark
 338           xfr  0
 339           job  1401 autocoder-pass 3 process free form   -version 3   3734l
 340 *
 341 *beginning of new free form record analysis
 342 *
 343           org  ovl2
 344 nurec     b    put
 345 pstnu     b    get
 346 subxl     sw   modesw
 347           cw   freesw
 348           bce  nurec,free&6,*
 349           bce  reg,free&75,
 350           bce  reg,free&75,l
 351           bce  nurec,free&75,s
 352           bce  nurec,free&75,z
 353           bce  nurec,free&85,r
 354           c    free&18,@cha@
 355           bce  ckchn,free&75,c
 356           bce  ckchn,free&75,y
 357           bu   nurec
 358           b    prchn
 359 ckchn     bu   reg
 360 prchn     za   free&22,warea2
 361           bce  *&5,warea2,&
 362           b    *&8
 363           za   warea2-1,warea2
 364           bce  *&5,free&75,c
 365           b    *&8
 366           mcw  @s@,free&75
 367           bce  *&5,free&75,y
 368           b    *&8
 369           mcw  @z@,free&75
 370           b    put
 371           c    warea2,&00                 account for chain 00
 372           bl   *&5
 373           b    pstnu
 374           mcw  free&75,hldcd#1
 375           mcw  @c@,free&75
 376           bce  blnkx,hldcd,r        rew:  bce  wmmchk,hldcd,r
 377           bce  blnkx,hldcd,s        res:  bce  wmmchk,hldcd,s
 378           mcw  @y@,free&75
 379 blnkx     mcw  blnk2,free&74
 380           mcw  free&74
 381           mcw  savop
 382           mcw
 383           mcw
 384           mcw  free&74,free&5             blank page/line
 385 chnlp     b    put
 386           mcw  free&74,free&11            blank label field
 387           s    &1,warea2
 388           c    warea2,&00
 389           bl   chnlp
 390           b    pstnu
 391 genps     mcw  @&1 @,free&15
 392           b    put
 393           mcw  free&73,free&72            to highest address of
 394           mcw  @c@,free&75                object core
 395           mcw  hival,free&25
 396           mcw  @equ  @
 397           mcw
 398           mcw  @$hival &p @
 399           mcw  free&73
 400           mcw  &nurec,genps&3
 401           mcw  @b@,ishiv
 402           b    nurec
 403 ishiv     nop  pstnu
 404           mcw  hival,free&25              set new highest value
 405           mcw  @b@,pssw2
 406           b    tstre
 407 reg       s    xl3&1
 408           s
 409           s
 410           c    free&18,@   @
 411           bu   svup3
 412           bce  tstre,free&19,
 413 svup3     mcw  free&20,savop#9
 414           mcw
 415           c    free&11, @$hival@          hival equate present
 416           be   ishiv
 417 pssw2     nop  tstre
 418           c    free&10,@$p   @            q. arith macro present
 419           be   genps
 420 tstre     bce  isrea,free&85,r
 421           b    tluop                      lookup mnemonic
 422 stfun     mcw  free&15,savop-5
 423           bw   nurec,eqvadd               q. instruction
 424           c    free&15,@3 @
 425           be   eoj
 426           b    nurec
 427 isrea     sw   free&12
 428           lca  free&15,eqvadd
 429           cw   free&12
 430           bce  typcl,free&15,&
 431           chain3
 432           b    stfun
 433 typcl     sw   eqvadd-2
 434           bce  stfun,free&12,&
 435           sw   eqvadd-1
 436           bce  stfun,free&13,&
 437           sw   eqvadd
 438           b    stfun
 439           dcw  0
 440           dcw  @}@                        system group mark
 441           xfr  0
 442           job  1401 autocoder-pass 3 process fix form    -version 3   3735l
 443           org  ovl2
 444 *
 445 *beginning of new fixed form record analysis
 446 *
 447 entsps    b    put                        put last record
 448           bw   gtfre,freesw               q. free done in fixed
 449 rstmod    cw   modesw#1,absw              reset switches
 450           b    rdtap                      get a record
 451           mcw  inarea&79,input&80         move to fixed form
 452           chain5
 453 profix    mcw  input&80,free&80           move identification
 454           mcw  blank,free&75              set operand portion
 455           mcw  free&75                     of -free- to blanks
 456           mcw  free&75,free&20            set balance to blank
 457           mcw
 458           mcw
 459           mcw  input&82,free&86           blank code positions
 460           mcw  input&13,free&11           move lane and pg/line
 461           mcw  input&5                     no to -free-
 462           bce  comcrd,input&8,*           q. comments card
 463           bce  lberr,free&11,,            check for invalid
 464           chain4                           characters in labels
 465           bce  lberr,free&10,-
 466           chain4
 467           bce  lberr,free&10,#
 468           chain4
 469           bce  lberr,free&10,&
 470           chain4
 471           bce  lberr,free&10,'
 472           chain4
 473           b    bck1
 474 lberr     cs   332
 475           cs
 476           mcw  @illegal label - sequence number@,231
 477           mcs  altrno,236
 478           w
 479 bck1      c    input&15,blnk2             q. actual op code
 480           be   absfix                      present in fixed form
 481           mcw  blnk2,savop
 482           mcw  input&16
 483           mcw  input&16,free&18           move mnemonic to free
 484 tlufix    s    xl3&1                      reset index locations
 485           s                                to zero
 486           s
 487           b    tluop                      lookup mnemonic
 488           bw   fixins,eqvadd              q. instruction
 489           bce  found,eqvadd,              q. control op
 490 *
 491 * process instruction
 492 *
 493 fixins    bce  lknop,input&17,            q. a operand
 494           bce  fixalf,input&17,@          q. alpha literal
 495           b    scan                       scan a operand
 496 ckb       bce  ckmod,input&28,            q. b operand
 497           a    &1,xl2                     move comma to free
 498           mcw  @,@,free&21&x2              to separate operands
 499           a    &1,xl2
 500           mcw  @011@,xl1
 501           bce  fixalf,input&28,@          q. alpha literal
 502           b    scan                       scan b operand
 503 ckop      c    input&16,@b  @             q. branch instruction
 504           be   makbce
 505           c    input&16,@  b@             q. actual branch inst
 506           be   movmod
 507           b    lknop
 508 ckmod     c    input&16,@b  @             q. branch instruction
 509           be   altrop
 510           c    input&16,@  b@             q. actual branch inst
 511           be   altrop
 512 lknop     c    input&16,@nop@             q. nop instruction
 513           be   cknop
 514           bw   pickup,absw                q. actual op code
 515           bce  pickup,input&39,           q. d character
 516 ismod     bce  movmod,free&15,            q. illegal op
 517           bwz  iotyp,free&15,2            q. i/o instruction
 518 movmod    mcw  input&39,free&23&x2        move d character to
 519           mcw  @,@                         free area
 520 pickup    mcw  input&55,free&72           pickup comments
 521           b    endfix
 522 makbce    mcw  @bce@,free&18              move -bce- mnemonic
 523           b    ismod                       to operation field
 524 altrop    bce  pickup,input&39,           q. d character, i.e.,
 525           mcw  @bin@,free&18               unconditional branch
 526           mcw  @& b@,free&15              set five char branch
 527           s    xl1&1
 528           mcw  blnk2,free&20
 529 tlubin    c    bintbl&x1,input&39         search 5-character
 530           be   binfnd                      branch table for
 531           bce  movmod,bintbl&5&x1,         appropriate unique
 532           a    &5,xl1                      mnemonic, if not
 533           b    tlubin                      present leave
 534 binfnd    mcw  bintbl-1&x1,free&19         mnemonic -bin-
 535           mcw
 536           c    free&18,@bss@              q. branch sense switch
 537           be   movmod
 538           mcw  input&39,free&14           pickup de character
 539           b    pickup
 540 cknop     bce  pickup,input&39,
 541 iotyp     mcw  input&39,free&14           code i/o instruction
 542           mcw  @&@                         in actual in
 543           mcw  input&39,free&20            operation field
 544           mcw  free&15
 545           mcw  blank3
 546           b    pickup
 547 fixalf    bce  endalf,input&27&x1,@       scan for at sign
 548           chain8
 549 value     a    &1,xl2                     process statement as
 550           mcw  @$$@,free&21&x2             unprocessable alpha
 551           b    whchop                      literal illegal opnd
 552 endalf    sbr  warea3                     pickup literal and
 553           s    &value&2,warea3             move to free form
 554           zs   warea3                      area
 555           a    warea3,xl1
 556           a    warea3,xl2
 557           mcw  input&17&x1,free&21&x2
 558 whchop    c    xl1,@011@                  exit on basis of which
 559           bh   ckb                         operand acting upon
 560           b    ckop
 561 absfix    bce  samfix,input&16,           print out message only
 562           mcw  input&16,free&19            once that actual ops
 563           mcw  input&39,free&20            are present in fixed
 564 sw1       nop  setabs                      form images
 565           cs   332                         this accounts for
 566           cs                               the possibility that
 567           mcw  @actual op codes present in fixed form images@,270
 568           cc   1                           the user forgot to
 569           w                                use an enter
 570           cc   1                           autocoder statement
 571           mcw  @b@,sw1                     when returning to
 572 setabs    sw   absw#1                      free form
 573           b    tlufix
 574 samfix    mcw  savop,free&20              process same op code
 575           mcw
 576           b    tlufix
 577 *
 578 * beginning of process control and declarative operation codes
 579 *
 580 found     bw   fixins,eqvadd              determine type of
 581           s    xl3&1                       control op and go to
 582           mn   eqvadd-1,xl3                appropriate routine
 583           a    xl3
 584           a    xl3
 585           b    *&1&x3
 586           b    badop                      da illegal in fixed form
 587           b    dcwstm                     go to constant routine
 588           b    erhlt                      should never occur
 589           b    oneop                      end, ex, xfr
 590           b    oneop                      go to suffix rtn
 591           b    erhlt                      should never occur
 592           b    cklor                      go to origin routine
 593           b    dstyp                      go to ds, equ routine
 594           b    inspc                      go to special routine
 595           mcw  input&55,free&59
 596           mcw                              to free form area
 597           mcw
 598           mcw
 599           b    endfix
 600 inspc     bce  nopnd,input&17,            process
 601           mcw  @b@,free&18                 cc and ccb and ss
 602           mcw  eqvadd-2,eqvadd             and ssb
 603           lca  blank
 604           mcw  eqvadd,free&15
 605           mcw  @ &@
 606           b    fixins
 607 nopnd     mcw  input&39,free&21           process two character
 608           b    endfix                      instructions
 609 erhlt     h    0,301                      system error halt
 610           b    erhlt
 611 *
 612 *process dcw, dc statements
 613 *
 614 dcwstm    bce  dcwtyp,input&17,*          q. dcw*
 615           a    blank,input&17             assure not blank
 616           mcw  free&18,warea6#6           generate equate
 617           mcw
 618           mcw  @equ@,free&18
 619           mcw  @&p @
 620           mcw  input&21,free&25
 621           b    put
 622           mcw  free&74,free&73
 623           mcw  input&22,free&11           generate free form
 624           mcw  warea6,free&18              dcw actual
 625           mcw
 626 dcwtyp    cw   input&40,input&39          remove word marks
 627           cw   input&28
 628           bce  dsartn,free&14,j           q. dsa statement
 629           bce  known,input&23,&           q. is the length of
 630           bce  known,input&23,-            the constant to be
 631           bce  known,input&23,@            computed by the
 632           mn   input&7,xl1                 processor
 633           mn
 634           a    blank,xl1
 635           c    xl1,@032@                  q. count gt 32 or
 636           bl   corerr                      lt zero. if
 637           c    xl1,@000@                   error attempt to
 638           be   corerr                      process record anyway
 639 rtndcw    mcw  input&23&x1,free&21&x1     constant to free form
 640           mcw  @@@,free&21                enclose dcw within
 641           mcw  @@@,free&22&x1             at signs
 642 rstwm     sw   input&40,input&39          reset word marks
 643           sw   input&28
 644           b    endfix
 645 known     mcw  input&55,free&53           pickup entire dcw area
 646           b    rstwm
 647 corerr    s    xl1&1
 648 lperr     bce  rtndcw,input&24&x1,        scan for first blank
 649           a    &1,xl1                      in attempt to correct
 650           c    xl1,@52@                   q) end of record
 651           be   rtndcw
 652           b    lperr
 653 *
 654 * process dsa statements
 655 *
 656 dsartn    s    xl2&2                      pickup fixed form dsa
 657           mcw  @011@,xl1                   and place in free for
 658           b    scan                        form area
 659           mcw  free&72,free&73            if unsigned make sign
 660           mcw  @&@                         plus
 661           bce  rstwm,input&27,            q. no sign
 662           mcw  input&27,free&21           sign address constant
 663           b    rstwm
 664 oneop     b    *&5,input&17,              process those
 665           b    scan                        instructions
 666           c    @3 @,eqvadd                 that only have one op
 667           be   preoj                      if end card go to eoj
 668           b    endfix
 669 *
 670 * process ds, equ statements
 671 *
 672 dstyp     bce  dsact,input&17,*           if ds is really an
 673           bce  *&5,input&17,               equ change op
 674           b    *&8                         code, assure
 675           nop  blank,input&17              operand not blank
 676 doequ     mcw  @equ@,free&18
 677           mcw  @p@,free&14
 678           b    oneop
 679 dsact     sw   input&6                    process ds actual
 680           a    blank,input&7
 681           cw   input&6
 682           c    input&7,@00@               q. no count
 683           be   doequ
 684           mcw  input&7,free&22
 685           b    endfix
 686 *
 687 *process comments cards
 688 *
 689 comcrd    mcw  input&55,free&53           process comments cards
 690           chain7
 691           b    entsps
 692 *
 693 * processs origin, ltorg statements
 694 *
 695 cklor     bce  oneop,free&16,o            change mnemonic to
 696           mcw  @ltorg@,free&20             -ltorg- if literal
 697           mcw                              org statement
 698           b    oneop
 699 *
 700 *scan routine which converts fixed form into free form
 701 *
 702 scan      sbr  scnxt&3
 703           s    xl3&1                      reset index 3
 704 loop1     bce  ck1bk,input&18&x1,         q. blank character
 705 cxl1      c    xl3,@05@                   q. end of address
 706           be   ndopd
 707           a    &1,xl1                     increase all index
 708           a    &1,xl2                      registers
 709           a    &1,xl3
 710           b    loop1
 711 ck1bk     c    xl3,@04@                   tolerate one blank
 712           be   ndopd
 713           bce  *&5,input&19&x1,
 714           b    cxl1
 715 ndopd     mcw  input&17&x1,free&21&x2     move address portion
 716           c    xl1,@011@                   to free form area
 717           s    xl1&2
 718           bh   *&8
 719           mcw  @011@,xl1
 720           bce  cklit2,input&23&x1,        q. no character adjust
 721           bwz  mkmin,input&23&x1,k        assure character adj
 722           mcw  @&@,input&23&x1             & or -
 723 rtn2      sw   input&24&x1,input&23&x1    process character
 724           a    blank,input&26&x1           adjustment
 725           a    &4,xl2
 726           mcw  input&26&x1,free&21&x2
 727           mcw
 728           cw   input&24&x1,input&23&x1
 729 noadj     bce  fixlit,input&17&x1,&       q. literal
 730           bce  fixlit,input&17&x1,-
 731           bce  scnxt,input&27&x1,         q. indexing
 732           a    &3,xl2                     process indexing
 733           mn   input&27&x1,free&21&x2
 734           mcw  @&x@
 735 scnxt     b    xxxx                       exit
 736 mkmin     mcw  @-@,input&23&x1            set char adj sign
 737           b    rtn2                        to minus
 738 fixlit    bce  not11,input&27&x1,         process remainder of
 739           a    &1,xl2                      fixed form numeric
 740           mn   input&27&x1,free&21&x2      literal
 741           b    scnxt
 742 not11     bce  subt,input&26&x1,
 743           b    scnxt
 744 subt      a    @i99@,xl1
 745           a    @i99@,xl2
 746           b    not11
 747 cklit2    bce  scnxt,input&17&x1,&        q. literal
 748           bce  scnxt,input&17&x1,-
 749           b    noadj
 750           dcw  0
 751 sysmk1    dcw  @}@                        system group mark
 752           xfr  0
 753 rtend     equ  *
 754           job  1401 autocoder-pass 3 right main line     -version 3   3733l
 755 *
 756 *table lookup of mnemonic op code
 757 *
 758           org  begin
 759 tluop     sbr  tluxt&3
 760           c    free&18,blank3#3           q. actual
 761           be   abscod                      op code
 762           mlc  free&18,xl2
 763           a    free&18,xl2-1
 764           a    free&18,xl2-2
 765           a    free&16,xl2                table lookup
 766 sub1      s    &5500,xl2&1                 uses address
 767           bwz  sub1,xl2&1,b                conversion technique
 768           mlcwaopnd-549&x2,eqvadd#9
 769           sar  getop&3
 770           s    xl2&2
 771 getop     mlcwaxxxx,eqvadd                search table for
 772           sar  getop&3                     mnemonic
 773           bce  badop,eqvadd,@             q. op not in table
 774           c    eqvadd,free&18             q. op code found
 775           bu   getop
 776           lca  eqvadd-3,eqvadd            shift table function
 777           c    @n @,eqvadd                q. enter card
 778           be   enter
 779           c    eqvadd,@b @                q. mlc, mlcwa type
 780           be   specin
 781           c    eqvadd,@2 @                q. ramac instn
 782           be   specin
 783 savcod    mcw  eqvadd,free&15             place table function
 784           sbr  xl3                         on record preceded by
 785           c    xl3,&free&11                a plus sign
 786           be   *&8
 787           mcw  @&@,000&x3
 788 tluxt     b    xxxx                       exit
 789 enter     c    free&23,@sps@              determine type of
 790           be   gtfix                       enter card and
 791           c    input&20,@auto@             go to appropriate
 792           be   gtfre                       routine
 793           bw   pstnu,modesw
 794           b    rstmod
 795 specin    bwz  mlctyp,eqvadd-1,b         q. mlc type
 796           lca  eqvadd-2,eqvadd
 797 ckel      bce  savcod,free&19,           q. should op be -l-
 798           mcw  @l@,eqvadd                make op code -l-
 799           b    savcod
 800 mlctyp    lca  @m@,eqvadd                make op code -m-
 801           b    ckel
 802 *
 803 * process illegal operation code
 804 *
 805 badop     lca  blank,eqvadd              make op blank
 806           bw   savcod,freesw             q. in free form mode
 807           bw   ckff,modesw               q. in free form mode
 808           b    savcod
 809 abscod    bce  savcod,free&19,      rew: bce  opblk,free&19,
 810           lca  blank,eqvadd              process actual op
 811           mcw  free&19,eqvadd             codes
 812           bce  savcod,free&20,
 813           cw   eqvadd
 814           sw
 815           mcw  free&20,eqvadd-1
 816           b    savcod
 817 ckff      bce  savcod,free&14,           if record appears to b
 818           mcw  free&80,input&80           be fixed form record
 819           chain9
 820           cs   332
 821           cs
 822           mcw  free&80,print&80
 823           chain4
 824           mcw  @processing as fixed form record@,332
 825           w
 826           sw   freesw
 827           bcv  restr
 828           b    gtfix
 829 restr     ccb  gtfix,1
 830 *
 831 * end of job procedure
 832 *
 833 preoj     rtw  systap,ovl2                skip past overlay
 834 eoj       b    put                        put end card
 835           wtm  outape                     write tape mark
 836 *         messg@pass 3 completed@,60,k,1
  01           cc   k
  02           cs   332
  03           cs
  04           mcw  @pass 3 completed@,60&200
  05           w
  06           cc   1
 837           cw   sysmk1                     clear group mk w/ wm
 838           cw   gmk1,gmk2
 839           rtw  systap,ovl2
 840           rtw  systap,085                 read in pass 4
 841           nop  0
 842           ber  tperr
 843           b    passb2                     go to next pass
 844           ltorg*
 845 *
 846 *table of mnemonic operation codes
 847 *
 848           org  3253
 849           dcw  @@@
 850           dcw  #4
 851           dcw  #2
 852           dcw  @nnop@
 853           dcw  @c xfr@
 854           dcw  @o lor@
 855           dcw  @i job@
 856           dcw  @/cs @
 857           dcw  @0 da @
 858           dcw  @s2wss@
 859 masym     dcw  @#ma @
 860           dcw  @3 end@
 861           dcw  @pmcm@
 862           dcw  @n ent@
 863           dcw  @brmrtb@
 864           dcw  @abblc@
 865           dcw  @ @
 866           dcw  @bmmbc@
 867           dcw  @%d  @
 868           dcw  @f3wm2 wdc@
 869           dcw  @ fccb@
 870           dcw  @s1dudcr@
 871           dcw  @ymlz@
 872           dcw  @@m  @
 873           dcw  @ueuskp@
 874           dcw  @o org@
 875           dcw  @hsbr@
 876           dcw  @k8 ss @
 877           dcw  @ymz @
 878           dcw  @ @
 879           dcw  @)cw @
 880           dcw  @uwlwtw@
 881           dcw  @b mlc@
 882           dcw  @zmcs@
 883           dcw  @uwmwt @
 884           dcw  @mmcw@
 885           dcw  @f2wm2 wdt@
 886           dcw  @qsar@
 887           dcw  @r6wrf@
 888           dcw  @s1euecr@
 889           dcw  @8srf@
 890           dcw  @)2wm @
 891           dcw  @1vbw @
 892           dcw  @9bbc9@
 893           dcw  @1r  @
 894           dcw  @urlrtw@
 895           dcw  @f1rmrd @
 896           dcw  @f1rlrdw@
 897           dcw  @mmu @
 898           dcw  @vbwz@
 899           dcw  @,sw @
 900           dcw  @rbbpc@
 901           dcw  @cc  @
 902           dcw  @c4pcb@
 903           dcw  @dmln@
 904           dcw  @umuwtm@
 905           dcw  @emce@
 906           dcw  @c ex @
 907           dcw  @ ucu @
 908           dcw  @zbbav@
 909           dcw  @5rp @
 910           dcw  @.h  @
 911           dcw  @llu @
 912           dcw  @bwmwtb@
 913           dcw  @ kssb@
 914           dcw  @kbbef@
 915           dcw  @pmrc@
 916           dcw  @ububsp@
 917           dcw  @urmrt @
 918           dcw  @sbbe @
 919           dcw  @3wr @
 920           dcw  @ss  @
 921           dcw  @bb  @
 922           dcw  @1 dcw@
 923           dcw  @wbbe@
 924           dcw  @j dsa@
 925           dcw  @llca@
 926           dcw  @a dc @
 927           dcw  @f1wlwdw@
 928           dcw  @7wrp@
 929           dcw  @ bbin@
 930           dcw  @kvbm @
 931           dcw  @pbbpb@
 932           dcw  @9spf@
 933           dcw  @m sfx@
 934           dcw  @4p  @
 935           dcw  @f0rmsd @
 936           dcw  @@bbcv@
 937           dcw  @!zs @
 938           dcw  @o lto@
 939           dcw  @p equ@
 940           dcw  @ bbss@
 941           dcw  @f8 cc @
 942           dcw  @aa  @
 943           dcw  @lbber@
 944           dcw  @/bbu @
 945           dcw  @bbce@
 946           dcw  @ubbh @
 947           dcw  @tbbl @
 948           dcw  @x ds @
 949           dcw  @f2rm2 rdt@
 950           dcw  @ammbd@
 951           dcw  @2w  @
 952           dcw  @f1wmwd @
 953           dcw  @dmn @
 954           dcw  @c1rcb@
 955           dcw  @6wp @
 956           dcw  @xmiz@
 957           dcw  #9
 958           dcw  #3
 959           dcw  @?za @
 960           dcw  #1
 961           dcw  @uuurwu@
 962           dcw  @ururwd@
 963           dcw  @r4rf @
 964 opnd      dcw  #1
 965 *
 966 * constants and tables
 967 *
 968 freesw    dc   0
 969 bintbl    dcw  @bav z@
 970           dcw  @bc9 9@
 971           dcw  @bu  /@
 972           dcw  @bcv @@
 973           dcw  @be  s@
 974           dcw  @bef k@
 975           dcw  @ber l@
 976           dcw  @bh  u@
 977           dcw  @bl  t@
 978           dcw  @blc a@
 979           dcw  @bpb p@
 980           dcw  @bpcbr@
 981           dcw  @bss b@
 982           dcw  @bss c@
 983           dcw  @bss d@
 984           dcw  @bss e@
 985           dcw  @bss f@
 986           dcw  @bss g@
 987 *
 988 *tape input area
 989 *
 990           ds   3
 991 inarea    da   1x86,g
 992 gmk1      equ  *
 993 *
 994 *  equates
 995 *
 996 blank     equ  blank3-2
 997 blnk2     equ  blank3-1
 998 endfix    equ  entsps
 999 warea3    equ  warea6-3
1000 warea2    equ  warea6-4
1001           ex   librn
1002           job  1401 autocoder-pass 4-left main line      -version 3   3741l
1003           sfx  z
1004 *
1005 * initialization of index locations
1006 *
1007           org  85
1008 grpmk1    dc   @}@
1009           dc   0
1010 xl1       dcw  000
1011           dc   00
1012 xl2       dcw  000
1013           dc   00
1014 xl3       dcw  000
1015           ds   1
1016 *
1017 *fixed form image area
1018 *
1019 image     equ  *
1020           ds   84
1021 grpmk4    dc   @}@
1022 zone      dcw  @2skb@
1023 exovfl    dcw  99                         constants used in
1024 exnumb    dcw  00                          making in literal labels
1025 procor    dcw  #1
1026 totlbl    dcw  &0000
1027 jobsw     dcw  0
1028 *
1029 * read in control card overlay
1030 *
1031 passb2    rtw  systap,doprog
1032           nop  0
1033           ber  tperr
1034           b    start
1035 *
1036 *tape redundancy routine
1037 *
1038 tperr     sbr  xl3
1039           sbr  redxt&3
1040           mz   &9,xl3
1041           mcw  4000-10&x3,tpins&7         bring in instruction
1042           mn   tpins&3,bsp1&3              that caused
1043           mcw  tpins&7,inst2&7             redundancy
1044 bsp1      bsp  initap                     backspace tape
1045           bce  wrtrd,tpins&7,w            q. write redundancy
1046           mcw  &9,rdct#1                  initialize counter
1047 tpins     rt   initap,xxxx                re-read
1048           ber  rderr                      q. redundancy
1049 redxt     b    xxxx                       exit
1050 rderr     mn   tpins&3,bsp2&3
1051 bsp2      bsp  initap                     backspace again
1052           s    &1,rdct                    reduce counter
1053           bwz  tpins,rdct,b               q. 10 successive retries
1054           mn   tpins&3,tphlt&6
1055 tphlt     h    xxxx,490                   halt
1056           mcw  tpins&7,*&8
1057           rt   initap,xxxx                re-read
1058           bss  bsp1,e                     determine option
1059           h    xxxx,402                   halt again
1060           b    redxt                      exit
1061 wrtrd     skp  systap                    erase tape
1062           bce  sbctr,wrtcr-1,5            q. fifty skips
1063           a    &1,wrtcr#2                 increase count
1064 inst2     wt   initap,xxxx                re-write
1065           ber  bsp1                       q. redundancy again
1066           b    redxt
1067 sbctr     s    wrtcr                      reset counter
1068           mn   tpins&3,*&7
1069           h    xxxx,460                   halt
1070           b    inst2
1071 *
1072 * noise record routine
1073 *
1074 noise     sbr  xl3
1075           sbr  nsxt&3
1076           mz   &9,xl3
1077 n2        bce  4000-12&x3,xxxx,}          scan for group mark
1078           chain12
1079 nsxt      b    xxxx
1080           ltorg*
1081 *
1082 *end of control card analysis, read in main line
1083 *
1084 cwi98     cw   3998
1085           sw   jobsw
1086           b    put
1087 rtnjb     cw   jobsw
1088           b    wrtp
1089 ldoptb    rtw  systap,doprog              read in main line
1090           nop  0
1091           ber  tperr
1092           cw   grpmk5,grpmk8
1093           mlc  @0@,factor-3
1094 *
1095 *beginning of main line
1096 *
1097 bypass    b    get                        process bypassed cards
1098           s    xl3&1
1099           s
1100           s
1101           b    ckcom
1102 *
1103 *beginning of new card analysis
1104 *
1105 nurec     b    put  ??? so getxt goes to ckcom ???  put last record
1106 get       sbr  getxt&3                    get routine
1107           cs   input&80
1108           sw   input&21
1109           sbr  n2&6,input&13
1110           rt   intap,input&1              read tape
1111           b    noise                      check for noise
1112           ber  tperr
1113 getxt     b    xxxx                       exit
1114 *
1115 *image to output area
1116 *
1117 wrtp      sbr  wrtxt&3
1118           wt   outap,output&1             write tape
1119           nop  0
1120           ber  tperr
1121           mlc  @000@,holdc
1122 wrtxt     b    xxxx
1123 put       sbr  putxt&3
1124           mlc  holdc,xl3
1125           mlc  image&80,output&80&x3      work area to output
1126           chain10
1127 tpyet     a    &80,holdc#3
1128 cktap     bce  wrtp,xl3-2,0               q. write yet
1129           bw   dcwxt,dcwsw2               q. dcw gt 30 cards
1130           bw   spglin,initsw              q. da record
1131           cs   input&80                   clear input and
1132           sw   input&21                    image areas
1133           mrcm input&1,image&1
1134           bw   rtnjb,jobsw                q. job card
1135 spglin    s    image&5                    wipe out pg/lin number
1136           s    xl3&1
1137           s
1138           s
1139 putxt     b    xxxx
1140 save2     org  *
1141 ckcom     bce  bypass,input&6,*           q. comments card
1142           mn   input&75,ck2&7
1143           mz   input&75,ck2&7
1144 ck2       bce  bypass,@rswz@,0
1145           chain3
1146           mlc  input&84,image&80          alter no to fixed form
1147           bwz  *&5,input&6,2              q. is there label
1148           b    prolbl                     process label
1149           mcw  input&18,image&16          mnemonic to fixed form
1150           sw   scansw                     reset scan switch
1151           mlc  @000@,freea#3
1152           lca  blank4,equadd              retrieve table function
1153           mcw  @i9i@,xl1                   that was
1154 plscan    bce  plusfd,input&15&x1,&        generated by pass 3
1155 gobk      c    xl1,@i9g@
1156           a    @i99@,xl1
1157           bl   plscan
1158 plusfd    bce  gobk,input&14&x1,&
1159           sw   equadd&1&x1
1160           mcw  input&15,equadd#4
1161           s    xl1&2
1162           bw   instr,equadd               q. regular instruction
1163           bce  ctrlop,equadd,             q. control op
1164           b    instr
1165 *
1166 *scan for comma or blank
1167 *
1168 comscn    sbr  cscnxt&3                   index location 3
1169           s    xl3&1                       contains total
1170           sw   input&21&x2,scansw          positions scanned
1171 tstcom    a    &1,xl2                      including comma or
1172           a    &1,xl3                      blank for operand
1173           bce  prscxt,input&20&x2,,       index location 2
1174           c    input&21&x2,blank2          contains total
1175           be   cscnxt                      positions scanned for
1176           c    xl2,@54@                    all operands
1177           be   scnerr                     scansw shows whether
1178           b    tstcom                      scan terminated by
1179 prscxt    cw   scansw#1                    comma or two blanks
1180 cscnxt    b    xxxx
1181 scnerr    mz   bbit,image&5
1182           bce  cscnxt,image&75,3
1183           b    nurec
1184 *
1185 *convert free to fixed
1186 *
1187 fr2fix    sbr  fr2fxt&3
1188           mcw  blank,w6area
1189           mcw  xl2&1,xl3&1
1190 scndex    c    xl3,@04@                   any character adj
1191           bh   doadrs                      or indexing
1192           be   ckadj
1193           c    input&18&x3,@&x@           q. indexing
1194           bu   ckadj                      process indexing
1195           mn   input&19&x3,image&27&x1
1196           a    &k4k-3,xl3
1197           b    scndex
1198 ckadj     bce  ckmin,input&18&x3,&
1199 scanb     equ  *-1                        character adjustment
1200           bce                             or area definition
1201           bce                             literal code
1202 domin     bce  isadj,input&18&x3,-
1203           bce
1204           bce
1205           bce  isadj,input&18&x3,#
1206           bce
1207           bce
1208           b    doadrs
1209 isadj     sbr  w3area                     process character
1210 proadj    s    &scanb,w3area               adjustment
1211           mlc  xl2,hold3
1212           mlns w3area,xl2
1213           mlc  @00@
1214           mlc  input&19&x3,w3area-4&x2
1215           s    xl2&1,xl3&1
1216           mz   input&20&x3,w3area-4&x2
1217           mn   input&20&x3,w6area
1218           sw   image&24&x1
1219           a    w3area-4&x2,image&26&x1    add char adjustment to
1220           cw   image&24&x1                 fixed form
1221           mlc  hold3,xl2
1222           b    scndex
1223 ckmin     sbr  w3area                     account for possible
1224           bce  domin,input&18&x3,-         multi-char adj of
1225           b    proadj                      &1-2 type
1226 doadrs    s    freea,xl3                  process address
1227           c    xl3,&007                   q. ollegal address
1228           bl   fixer                       length
1229           a    freea,xl3
1230           mz   blank,xl3
1231           mcw  @'@,input&20&x3
1232           mlc  freea,xl3
1233           mrcm input&21&x3,image&17&x1    move address to image
1234           sbr  xl3
1235           mz   abbit,xl3
1236           mcw  blank,4000-1&x3
1237           mn   w6area,image&23&x1
1238 fr2fxt    b    xxxx                       exit
1239 fixer     sw   fixsw#1
1240 opder     mcw  @000@,xl3                  code statement
1241           mz   abit,image&5                bad but processable
1242           bce  *&8,xl1,0
1243           mcw  @003@,xl3
1244           mcw  @###@,image&70&x3
1245           mz   abbit,image&1&x3
1246           bw   fr2fxt,fixsw
1247           b    lter2
1248 *
1249 *scan for sign
1250 *
1251 scanat    sbr  scnatx&3
1252           sw   input&21&x2,scansw         scan is executed from
1253           za   @510@,xl3&1                 right to left
1254 a1alf     bce  ndascn,input&21&x3,@
1255           s    &10,xl3&1
1256           b    a1alf
1257 ndascn    c    xl2,xl3                    q. no ending at sign
1258           be   lterr
1259           bce  setsw,input&22&x3,,        q. is ending at sign
1260           c    input&23&x3,blank2          followed by comma or
1261           bu   lterr                       two blanks
1262 sxl       s    xl2&1,xl3&1
1263           a    &2,xl3
1264           a    xl3,xl2
1265 scnatx    b    xxxx                       xxxx
1266 setsw     cw   scansw
1267           b    sxl
1268 *
1269 *improperly coded statement routine
1270 *
1271 lterr     mlzs abit,image&5               mark statement
1272           cw   fixsw                       bad but processable
1273           b    opder
1274 lter2     b    comscn
1275           mcw  @@@,input&20&x3
1276           a    &1,xl3
1277           b    scnatx
1278 *
1279 *place literals on  master tape
1280 *
1281 call      bw   cklor,litsw#1              q. any literals
1282           rt   systap,input&1             read in process
1283           rtw  systap,doprog               literals overlap
1284           nop  0
1285           ber  tperr
1286           b    ovllit                     go to routine
1287 recall    rtw  systap,doprog              recall main line
1288           nop  0                           overlap
1289           ber  tperr
1290 cklor     bce  bypass,image&75,           q. literal origin
1291           bce  nurec,image&75,c           q. execute
1292           rt   systap,input&1             skip past overlaps
1293           rt   systap,input&1              and read in end of
1294           rtw  systap,eojrt                job overlap
1295           nop  0
1296           ber  tperr
1297           b    eojrt
1298 *
1299 *generate entry address for labels
1300 *
1301 prolbl    sbr  xtlabl&3
1302           mlc  input&11,image&13
1303           mlc  image&13,w6area
1304           b    prolab
1305           mlc  w3area,image&56
1306           a    &1,totlbl
1307 xtlabl    b    xxxx
1308 *
1309 *convert free form number to five characters
1310 *
1311 cvrt5     sbr  cvt5xt&3
1312           bce  *&5,w5area,&
1313 cvt5xt    b    xxxx
1314           za   w5area-1,w5area
1315           b    cvrt5&4
1316 *
1317 * check for final operand
1318 *
1319 fnlop     sbr  fnlxt&3                    q. final operand
1320           bw   fnlxt,scansw                followed by two
1321           mz   abit,image&5                blanks
1322 fnlxt     b    xxxx
1323 *
1324 *convert floating a operand actual address to five characters
1325 *
1326 cvtfla    sbr  flaxt&3
1327           za   image&21,w5area
1328           b    cvrt5                      link to subroutine
1329 flaxt     b    xxxx
1330 *
1331 *convert symbols to three character entry address
1332 *
1333 prolab    sbr  lblxt&3
1334           za   &2,hold2
1335           bce  *&5,w6area,                add suffix char to
1336           b    *&8                         labels five chars
1337           mcw  sfxhld,w6area               or less
1338           za   w6area-2,hold4
1339           a    w6area,hold4               fold symbol to
1340           a    w6area,hold4-2              four characters
1341           mlzs blank,hold4
1342           za   factor,hold7               multiply by factor
1343 mpylp     mlns hold7,hold1
1344           za
1345 mult      bce  nxtdgt,hold1,?
1346           a    hold4,hold7-2
1347           s    &1,hold1
1348           b    mult
1349 nxtdgt    s    &1,hold2
1350           bwz  mpylp,hold2,b
1351           s    w5area
1352           bav  *&1
1353 loop1     a    &96,hold7-5                fold five character
1354           bav  loop1                       result to three
1355           mlzs hold7-6,w3area              character table entry
1356           mlc  hold7-3                     address
1357           mlns hold7-5,*&4
1358           mlzs zone,w3area-2
1359 lblxt     b    xxxx
1360 *
1361 *process dcw, dc, dsa cards
1362 *
1363 dcwcd     bce  dcwalf,input&21,@          q. alpha constant
1364           bce  ardef,input&21,#           q. area definition
1365           bce  ckdcw,input&21,&           q. numeric literal
1366           bce  ckdcw,input&21,-
1367           mlc  input&72,input&73          shift right
1368           mlc  @&@
1369           sw   dcwsw                      set no zoning switch
1370 ckdcw     b    comscn                     scan for blank
1371           bce  isdsa,input&22,@           q. adcon of literal
1372           b    fnlop                      check last operand
1373           bce  isdsa,image&75,j           q. dsa statement
1374           bwz  isdcw,input&22,2           q. dc, dcw statement
1375 *
1376 *process dsa cards, subset of dcw
1377 *
1378 isdsa     mlc  @011@,xl1
1379           mlns &2,image&75                code record
1380           mz   input&21,image&27
1381           mcw  blank,input&21
1382           bwz  *&5,image&75,k
1383           b    *&8
1384           mz   blank,image&75
1385           sw   dsasw2                         set dsa switch
1386           mlc  @001@,freea
1387           mcw  input&34,image&53
1388           bce  dsadc,input&22,@
1389           bce  dsadc,input&22,&
1390           bce  dsadc,input&22,-
1391           b    fr2fix                     convert free to fixed
1392           mz   image&27,input&21
1393 dsax1     mz   image&27,image&40
1394           mlc  @03@,image&7               insert count
1395           mlc  @03@,xl2
1396 ckaop     bce  dcwast,input&6,            q. any label
1397           bwz  dcwast,image&75,s          q. literal
1398           bwz  *&5,input&6,2              q. actual address
1399           b    dcwast
1400           mlc  input&10,image&21          process actual
1401           b    cvtfla                      address
1402 dcwact    mlc  w5area,image&21            address to fixed
1403           mlc  w5area,image&61             form
1404           b    ckmacr
1405 dcwast    a    xl2,orgctr                 bump origin counter
1406 bmpctr    mcw  @*@,image&17               set to dcw *
1407 dsetad    a    orgctr,image&61            assign address
1408 ckmacr    bce  nurec,image&75,p           q. equ statement
1409           bce  nurec,image&75,x           q. ds statement
1410           bw   dcwxt,dsasw2               q. dsa statement
1411           mlc  input&51,image&53          move constant to
1412           mlc                              fixed form
1413           mlc
1414           mlc  xl2,image&7                count to fixed form
1415           c    xl2,@030@                  q. count greater than
1416           bh   dcwxt                       30
1417           mn   @8@,input&75               write free form record
1418           bwz  *&8,image&75,b              on tape
1419           mz   image&75,input&75
1420           mcw  holdc,xl3
1421           mcw  input&80,output&80&x3
1422           sw   dcwsw2
1423           b    tpyet
1424 dcwxt     cw   dsasw2,dcwsw2              reset switches
1425           bw   *&5,litsw2
1426           b    nurec
1427           bce  litrtn,input&21,@
1428           bce  ltgen,input&22,&           q. adcon of literal
1429           bce  ltgen,input&22,-
1430           bce  ltgen,input&22,@
1431           b    litrtn
1432 pdcwlf    s    xl2&2
1433 dcwalf    b    scanat                     scan for ending at sign
1434           b    fnlop                      check last operand
1435           bw   acnrt,dsasw2               q. adcon of literal
1436           s    &30,xl2&1
1437           b    ckaop
1438 isdcw     s    &20,xl2&1
1439           bw   nozone,dcwsw               q. constant zoned
1440           mlzs input&21,input&21&x2       zone constant
1441 nozone    cw   dcwsw
1442           b    ckaop
1443 ardef     sw   input&22                   process area
1444           za   input&24,w5area
1445           b    cvrt5
1446           mlzs abbit,image&4              code record
1447           mlns w5area,xl2
1448           mlc
1449           c    xl2,@053@                  q. illegal length
1450           bh   ckaop
1451           mz   bbit,image&5               mark bad statement
1452           b    ckaop
1453 dsadc     bce  pdcwlf,input&22,@          q. adcon of alpha lit
1454 acnrt     s    &10,xl3&1
1455           mcw  xl3,w3area
1456           c    xl3,@006@                  q. large literal
1457           bl   dobig
1458           bce  xalf1,input&22,@           q. alpha literal
1459           b    xlit1
1460 ltgen     b    put                        put adcon
1461           mcw  @/@,image&75               set up literal
1462           mcw  larea&72,input&72           to be processed
1463           mcw                             note, address constant
1464           mcw                              logic makes it
1465           mcw                              recursive
1466           mcw  larea&74,larea&73
1467           b    prolbl
1468           s    xl2&2
1469           s
1470           b    dcwcd
1471 *
1472 *call in da routine
1473 *
1474 dartn     rtw  systap,doprog              call da routine
1475           nop  0
1476           ber  tperr
1477           b    dastmt                     go to da routine
1478 finda     rtw  systap,doprog
1479           nop  0
1480           ber  tperr
1481           b    ckcom
1482           ltorg*
1483 grpmk5    dcw  @}@
1484           ex   dozero
1485           job  1401 autocoder-pass 4 process job/ctl     -version 3   3742l
1486 *
1487 *process control card
1488 *
1489 doprog    org  *
1490 start     cs   input&84
1491           cs   3999
1492           sw   input&21,input&81          set word marks in
1493           sw   image&1,image&6             fixed form image area
1494           sw   image&8,image&14
1495           sw   image&17,image&28
1496           sw   image&39,image&57
1497           sw   image&62,image&67
1498           sw   image&23
1499           sw   grpmk1,grpmk8              initialize group marks
1500           sw   grpmk3,grpmk4
1501           cw   initsw
1502           rwd  intap
1503           rwd  outap
1504           rwd  litape
1505           mlc  @000@,holdc
1506           b    get                        get job card
1507           mcw  input&80,image&21          process job card
1508           mcw  @i@,image&75                identification
1509           sw   3998
1510           b    get                        get second record
1511           bce  noctl,input&6,*            q. comments card
1512           c    input&18,@ctl@             q. control card
1513           bu   noctl
1514           mlns input&21,ctl3&7            check processor size
1515 ctl3      bce  ctl2,ckpro,                 for valid code
1516           bce
1517           bce
1518           bce
1519           b    noctl
1520 ctl2      mlc  input&21,procor            initialize areas
1521           za   input&21,xl1
1522           s    &30,xl1&1                   processor machine
1523           a    xl1                         size
1524           a    xl1
1525           mlc  fctbl&x1,factor
1526           mlc  @0@,factor-3
1527           mlc  fctbl-3&x1,cktap&7
1528           bce  is16k,input&21,6           q. 16k processor
1529           bce  is16k,input&21,5           q. 16k processor
1530           bce  is8k,input&21,4            q. 8k processor
1531           mlc  @3@,procor
1532 *
1533 * initialize output area and set up blocking size
1534 *
1535 is4k      lca  grpmk8,3998                set group mark at end
1536           b    put
1537           b    ldoptb                      of output area
1538 is8k      lca  grpmk8,4318
1539           mcw  @%@
1540           mcw  4317
1541           b    cwi98
1542 is16k     lca  grpmk8,4718
1543           mcw  @%@
1544           mcw  4717
1545           b    cwi98
1546 noctl     mlc  fctbl,factor               process when no
1547           mlc  @3@,procor                  control card
1548           bsp  intap
1549           b    is4k
1550 fctbl     dcw  0015
1551           dcw  3051
1552           dcw  7087
1553           dcw  7127
1554 ckpro     dcw  3456
1555           ltorg*
1556 *
1557 *M A I N   L I N E   C O N S T A N T S   A N D   W O R K   A R E A S
1558 *
1559 *literal hold area
1560 *
1561           org  save
1562 larea     equ  *
1563           dcw  &00000
1564           dcw  #10
1565           dcw  @dcw  @
1566           dcw  #1
1567           ds   53
1568           dcw  @/@
1569           ds   9
1570 grpmk3    dc   @}@
1571 hldlit    equ  larea&1
1572 *
1573 *constants and work areas
1574 *
1575 factor    dcw  @0000@                     label conversion factor
1576 bigctr    dcw  @00000@                    big literal label cntr
1577 orgctr    dcw  @00332@                    origin counter
1578 blank4    dcw  #4                         blanks
1579 b2cntr    dcw  #5                         work area
1580 hold4     dcw  #4                         work area
1581 w6area    dcw  #6                         work area
1582 hold7     dcw  #7                         used for label
1583 hold1     dcw  &0                          conversion only
1584 sfxhld    dcw  0                          suffix character
1585 initsw    dcw  0                          da switch
1586 marksw    dc   0                          da switch
1587 dcwsw     dc   0                          dcw switch
1588 litsw2    dc   0                          literal switch
1589 dsasw2    dc   0                          dsa switch
1590 dcwsw2    dc   0                          dcw switch
1591 grpmk8    equ  3899
1592 3899      dcw  @}@                        system group mark
1593           ex   dozero
1594           job  1401 autocoder-pass 4 main line overlay   -version 3   3743l
1595 *
1596 *process instruction statements
1597 *
1598           org  doprog
1599 instr     mcw  equadd,image&67            get actual op
1600           cw   lensw#1                    reset switch
1601           mlc  @01@,image&7               set count to 1
1602           bw   *&5,equadd                 q. regular op code
1603           b    augmnt
1604 docnt     bce  done,input&21&x2,          q. is there operand
1605           bce  xisalf,input&21&x2,@       q. alphameric literal
1606           lca  blank2&1,input&20&x2       wipe out prev operand
1607           b    comscn                     scan for comma, blank
1608           mlc  xl3,w3area
1609           mlc  freea,xl3
1610           bce  xislit,input&21&x3,&       q. numeric literal or
1611           bce  xislit,input&21&x3,-        address constant
1612           b    fr2fix                     convert free to fixed
1613           bce  smltyp,image&23&x1,#       q. area def literal
1614 ckdone    a    &3,image&7                 add three to count
1615           bw   fremod,lensw               q. five char inst
1616           c    xl1,@010@                  q. b operand just
1617           bl   done                        processed
1618           mlc  @011@,xl1
1619           bw   *&5,scansw                 q. two blanks after op
1620           b    elmblk                     eliminate blanks
1621 intxl1    mcw  xl2,freea
1622           b    docnt
1623 done      bw   ckmod1,scansw              q. d modifier in
1624 fremod    mlc  input&21&x2,image&39        operand field
1625           bce  *&5,image&39,              q. d modifier offset
1626           b    c1                          one position
1627           bce  c1,input&22&x2,            if both positions
1628           mcw  input&22&x2,image&39        blank assume first
1629           a    &1,xl2                      blank significant
1630 c1        c    input&23&x2,blank2         q. d modifier
1631           be   ismod                       followed by two
1632           mz   abit,image&5                blanks
1633           b    ismod
1634 ckmod1    bce  doiadd,image&39,           q. d character
1635 ismod     a    &1,image&7                 process d character
1636           mlc  image&7,xl2
1637           mlc  image&39,image&66&x2
1638 doiadd    mlc  orgctr,image&61            assign address and
1639           a    &1,image&61                 bump up counter
1640           a    image&7,orgctr
1641           mlc  blank,image&75             code record
1642           b    nurec
1643 loopbl    a    &1,xl2                     weed out blanks
1644           c    xl2,@51@                    between operands
1645           bl   errblk
1646 elmblk    bce  loopbl,input&21&x2,
1647           b    intxl1
1648 errblk    mz   abit,image&5
1649           b    ckdone
1650 *
1651 *process unique mnemonics
1652 *
1653 augmnt    mcw  equadd-1,image&39          d mod to image area
1654           bce  isfive,equadd-1,           q. bin type
1655 ckreg     bw   docnt,equadd-1             q. typical unique mnem
1656           bw   tapaug,equadd-2            q. tape type
1657           mcw  equadd-2,image&70          ergo ramac type
1658           mlc  @%@
1659           b    opdone
1660 tapaug    c    input&21,@0@               process tape type of
1661           bh   docnt                       unique mnemonics
1662           bce  mscsw,input&22,,           check for properly
1663           c    input&23,blank2            coded a operand
1664           be   getpop
1665           mcw  @###@,image&70
1666           b    opdone
1667 mscsw     cw   scansw
1668 getpop    mn   input&21,image&70
1669           mcw  equadd-2
1670           mcw  @%@
1671           mlc  @002@,xl2
1672 opdone    mlzs abbit,image&1              mark A operand done
1673           b    ckdone
1674 isfive    sw   lensw                      set switch for five
1675           b    ckreg                       char instruction
1676 *
1677 *process area definition literal
1678 *
1679 smltyp    sw   image&24&x1                move length to
1680           mlc  image&26&x1,larea&24        literal hold area
1681           mlc  @#@
1682           cw   image&24&x1                remove length from
1683           mcw  blank4,image&26&x1          char adj portion
1684           mcw  input&84,larea&4            of operand and save
1685           b    wrtlit                      alter number
1686 *
1687 *process alphameric literals
1688 *
1689 xisalf    b    scanat                     scan for at sign
1690           c    xl3,@07@                   q. big literal
1691           bl   dobig
1692 xalf1     a    xl3,xl1
1693           mcw  input&19&x2,image&15&x1    generate unique label
1694           bce  gm1,free&18&x2,}            and strip zoning
1695           bce                              off group marks in
1696           bce                              literal to eliminate
1697           bce                              conflict
1698 add       s    xl3&1,xl1&1                 with noise record
1699           mz   exovfl-1,image&17&x1        routine
1700 setex     mcw  exnumb-1,image&22&x1       give literal section
1701           b    prolit                      code
1702 gm1       mz   blank4,image&14&x1
1703           mz
1704           mz
1705           mz
1706           b    add
1707 *
1708 *process big literals
1709 *
1710 dobig     mlc  bigctr,image&22&x1         generate big literal
1711           mlc  @$@                         label
1712           a    &1,bigctr
1713           mcw  input&84,larea&4           save alter number
1714 *
1715 *place literals in hold area and write out on literal tape
1716 *
1717 prolit    mlc  input&19&x2,larea&19&x3    literal to hold area
1718 wrtlit    mlc  image&22&x1,larea&11       literal label to area
1719           bw   dsax1,litsw2
1720           wt   litape,hldlit              write out literal
1721           nop  0
1722           ber  tperr
1723           mcw  blank4,larea&4             clear hold area
1724           mlc  larea&74,larea&73
1725           cw   litsw                      set sw to indicate at
1726           bw   dsax1,dsasw2               q. recursive dcw
1727           b    ckdone                     least one lit exists
1728 *
1729 *process numeric literals
1730 *
1731 xislit    c    input&22&x3,@0@            q. address constant
1732           mlc  w3area,xl3
1733           bh   dobig
1734           c    xl3,@07@                   q. big literal
1735           bl   dobig
1736 xlit1     a    xl1,xl3                    process small numeric
1737           mlc  input&19&x2,image&14&x3     literals
1738           mz   exovfl-1,image&21&x1       generate unique label
1739           mlc  freea,xl3                   for literal
1740           mlzs input&21&x3,image&18&x1
1741           mlc  w3area,xl3
1742           b    setex
1743 *
1744 *generate label entry address for symbolic operands
1745 *
1746 propnd    sbr  bopxt&3
1747              b bopxt,image&17         ??? originally 7-char bce
1748           mcw  image&22,w6area
1749           b    prolab                     link to subroutine
1750           mlc  w3area,image&70
1751 bopxt     b    xxxx
1752 *
1753 *determine type of control op
1754 *
1755 ctrlop    mcw  equadd-1,image&75          code record
1756           s    xl3&1
1757           mn   equadd-1,xl3               branch to appropriate
1758           a    xl3                         routine
1759           a    xl3
1760           b    *&1&x3
1761           b    dartn
1762           b    dcwcd
1763           b    errhlt
1764           b    exend
1765           b    dosfx
1766           b    errhlt
1767           b    orgstm
1768           b    dsstmt
1769           b    inspc
1770           mcw  input&80,image&21
1771           b    nurec
1772 inspc     mcw  equadd-2,image&67          process cc, ss
1773           mcw  blank2,image&75             type of
1774           mlc  @01@,image&7                instructions
1775           b    fremod
1776 errhlt    h    0,0402                     system error halt
1777           b    errhlt                      should never occur
1778 *
1779 *process literal origin and origin cards
1780 *
1781 orgstm    b    comscn                     scan for blank
1782           b    fnlop                      check last operand
1783           b    fr2fix                     free to fixed form
1784           bce  suborg,image&24,x          q. adjustment &xod
1785           bce  orgpro,image&17,*          q. asterisk operand
1786           zs   &1,orgctr                  set counter to -1
1787           bce  orgadj,image&17,           q. blank operand
1788           bwz  orgcvt,image&17,2          q. actual origin
1789           s    xl2&1                      process a operand of
1790           b    propnd                      symbolic origin
1791 orgadj    a    image&26,orgctr            add char adjustment
1792 typorg    mlc  orgctr,image&61            save origin value
1793           bce  nurec,input&16,o           q. origin card
1794           b    put                        put ltorg record
1795           b    call                       go to literal routine
1796 suborg    zs   &1,orgctr                  set counter to -1
1797           b    propnd                     process a operand
1798           b    typorg
1799 orgcvt    b    cvtfla                     reset counter to actl
1800           a    w5area,orgctr               address less one
1801 orgpro    mz   abbit,image&1              mark a operand
1802           b    orgadj                      processed
1803 *
1804 *process ds statements
1805 *
1806 dsstmt    b    comscn                     scan for comma/blank
1807           b    fnlop                      check last operand
1808           b    fr2fix                     convert to fixed form
1809           bwz  ckequ,input&21,2           q. actual operand
1810           bce  ck4adj,image&17,*          q. asterisk operand
1811           bce  nurec,image&17,%           q. i/o operand
1812           b    propnd                     generate label address
1813           b    nurec
1814 ck4adj    za   image&26,image&61          pickup character
1815           b    dsetad                      adjustment
1816 ckequ     za   image&21,w5area            convert actual opnd of
1817           b    cvrt5                       equ and ds
1818           a    image&26,w5area            add character adj
1819           bce  dcwact,image&75,p          q. equ code
1820           a    w5area,orgctr              process ds
1821           b    bmpctr
1822 *
1823 *process suffix statements
1824 *
1825 dosfx     mlc  input&21,image&17          sabe suffix
1826           mcw  input&21,sfxhld             character
1827           b    nurec
1828 *
1829 *process execute, end statements
1830 *
1831 exend     b    comscn                     scan for comma/blank
1832           b    fnlop                      check last operand
1833           b    fr2fix                     convert to fixed form
1834           bce  nurec,input&16,x
1835           b    call                       merge literals
1836           ltorg*
1837 grpmk2    dcw  @}@                        system group mark
1838 save      equ  *&1
1839           ex   dozero
1840           job  1401 autocoder-pass 4 process da          -version 3   3744l
1841 *
1842 *process da statements
1843 *
1844           org  doprog
1845 dastmt    bsp  systap                     reposition system
1846           bsp  systap                      tape
1847           sw   numsw,dacsw                q. first char -x-
1848           sw   frmksw,dgmksw              set switches
1849           bce  daerr,input&21,x
1850 exscan    bce  ndxscn,input&22&x2,x
1851           bce  daerr,xl2,4
1852           a    &1,xl2
1853           b    exscan
1854 ndxscn    a    input&21&x2,blkctr         get blocking factor
1855           a    &2,xl2
1856           b    comscn
1857           za   input&19&x2,recntr#5       get record length
1858 finhed    bce  daindx,input&21&x2,x       q. indexing
1859           bce  dagmrk,input&21&x2,g       q. group mark
1860           bce  dafmrk,input&21&x2,'       q. record mark
1861           bce  daclr,input&21&x2,c        q. clear option
1862           bce  cmpsz,input&20&x2,         q. no other options
1863           mz   abit,image&5
1864 cmpsz     s    w5area
1865           mcw  blkctr,b2cntr              compute size of area
1866 darep     s    &1,b2cntr                  and store in b2cntr
1867           bm   sfans,b2cntr
1868           a    recntr,w5area
1869           b    darep
1870 sfans     mcw  w5area,b2cntr
1871           mlc  @*@,image&17
1872           bce  dastr,input&6,             determine whether
1873           bwz  danum,input&6,2             location of da is
1874 dastr     mlc  orgctr,daloc#5              actual or asterisk
1875           a    &1,daloc                   process da*
1876           a    w5area,orgctr              bump origin counter
1877           b    endda
1878 danum     mlc  input&10,image&21          process actual da
1879           cw   numsw#1                    set actual da switch
1880           b    cvtfla
1881           mlc  w5area,daloc
1882 endda     mlc  daloc,image&66             generate high order
1883           mlc  daloc                       location of da
1884           a    recntr,image&66
1885           s    &1,image&66
1886           s    &1,daloc
1887           cw   hedsw#1
1888           bw   daloop,dacsw               q. clear option
1889           mcw  image&80,dahld             save image
1890           chain10
1891           mcw  @a@,image&75               code dc statement and
1892           mcw  blank4,image&80             to clear entire da
1893           mcw  blank4,image&55             area
1894           mcw  blank4,image&27            note - each dc is 19
1895           sw   initsw                      characters
1896           mcw  blank4,image&11             optimizing the
1897           mcw  @dc @,image&16              condensed card
1898           mcw  @19@,image&7
1899           mcw  daloc,image&61
1900 ckndq     c    b2cntr,&0020
1901           bh   dolst
1902           a    &19,image&61
1903           mz   abbit,image&1
1904           b    put
1905           s    &19,b2cntr
1906           b    ckndq
1907 dolst     c    b2cntr,&0000
1908           be   rtmge
1909           mn   b2cntr,image&7
1910           mn
1911           a    b2cntr,image&61
1912           mz   abbit,image&1
1913           b    put
1914 rtmge     mcw  dahld,image&80             restore image area
1915           chain10
1916 daloop    sw   initsw
1917           za   &1,b2cntr
1918 daput     c    b2cntr,blkctr              generate -b- number
1919           bh   putit
1920 daget     cw   initsw
1921           bw   daput2,hedsw               q. da header
1922           mcw  image&66,gmkadd#5          save last address
1923           a    &1,gmkadd                   as potential group
1924           sw   hedsw                       mark address
1925 daput2    b    put
1926           bw   ckfnlg,marksw              q. rec mark loop
1927 get1      b    get
1928           bce  get1,input&6,*
1929           c    input&19,blank4            q. field card
1930           bu   ckfmrk
1931           mcw  input&84,image&80          pickup alter number
1932           bce  *&5,input&6,               q. label
1933           b    prolbl
1934           mlc  &0,image&75                code record
1935           s    xl2&1
1936           b    comscn
1937           za   input&19&x2,image&66
1938           c    recntr,image&66            q. does field exceed
1939           bh   tferr                       limit of da
1940           bce  subfld,input&20&x2,        q. subfield
1941           b    comscn
1942           b    fnlop
1943           za   input&19&x2,image&61
1944           c    recntr,image&61            q. does field exceed
1945           bh   tferr                       limit of da
1946           c    image&61,image&66          q. fields specified in
1947           bh   flderr                      in correct order
1948 addrec    a    daloc,image&61             create address for
1949           a    daloc,image&66              fields
1950           bm   daget,image&75             q. sub field
1951           b    daloop
1952 subfld    mlzs bbit,image&75              process subfields
1953           mlc  image&66,image&61
1954           b    addrec
1955 putit     b    put
1956           bw   *&8,marksw                 q. record mark loop
1957           mz   abit,image&75              code repeats
1958           a    &1,b2cntr
1959           a    recntr,image&61            compute field limits
1960           a    recntr,image&66
1961           b    daput
1962 daerr     mlzs abbit,image&4              improperly coded da
1963           za   &1,blkctr                   header routine
1964           za   &1,recntr
1965           b    cmpsz
1966 tferr     sbr  *&11
1967           mz   abit,image&5
1968           b    xxxx
1969 flderr    mz   bbit,image&5               improperly coded da
1970           b    daput2                      field routine
1971 daclr     cw   dacsw#1                    process clear option
1972           b    datwo                       on header record
1973 daindx    mlns input&22&x2,image&27       process indexing on
1974           a    &3,xl2                      header record
1975           b    finhed
1976 dagmrk    cw   dgmksw#1                   initialize to show
1977 datwo     a    &2,xl2                      there is group
1978           b    finhed                      mark after area
1979 dafmrk    a    &1,recntr                  initialize to show
1980           cw   frmksw#1                    presence of record
1981           b    datwo                       marks between records
1982 ckfmrk    sw   marksw
1983           bw   ckfnlg,frmksw              q. record marks
1984           mlc  @@'@@,image&25             generate -b- number
1985           mlc  @dc *@,image&17             of record marks
1986           mlc
1987           mlc  &1,image&75
1988           mlc  @01@,image&7
1989           mlc  daloc,image&61
1990           a    recntr,image&61
1991           bw   daloop,numsw
1992           mcw  blank,image&17
1993           mz   abbit,image&3
1994           b    daloop
1995 ckfnlg    bw   callop,dgmksw              q. set group mark
1996           mlc  @dcw@,image&16             generage record to set
1997           mlc  @1@,image&75                group mark at end of
1998           mlc  @01@,image&7                da statement
1999           mcw  gmkadd,image&61
2000           mlc  @@}@@,image&25
2001           bw   gmkast,numsw
2002           mcw  blank,image&17
2003           mz   abbit,image&3
2004 putgmk    b    put                        put group mark record
2005           b    callop                     go back to main line
2006 gmkast    a    &1,orgctr
2007           mcw  @*@,image&17
2008           b    putgmk
2009 callop    bsp  intap
2010           b    get
2011           cw   marksw,grpmk6
2012           b    finda
2013 blkctr    dcw  &00000
2014           ltorg*
2015           da   1x80
2016 dahld          80
2017 grpmk6    dcw  @}@                        system group mark
2018           ex   dozero
2019           job  1401 autocoder-pass 4 process literals    -version 3   3745l
2020           org  doprog
2021 ovllit    wtm  litape
2022           wtw  litape,image&1             save image area
2023           nop  0
2024           ber  tperr
2025           bef  *&1                        reset eof trigger
2026           wtw  litape,image&1             note - must write out
2027           nop  0                           image area twice
2028           ber  tperr                       because eof treated
2029 *                                        as noise record
2030           rwd  litape
2031           bsp  systap                     position system tape
2032           bsp  systap                      to bring back
2033           bsp  systap                      main line
2034           cw   grpmk7
2035           cs   input&80                   blank input and fixed
2036           sw   input&16,litsw2             form area
2037           mrcm input&1,image&1
2038           mlc  blank4,image&80
2039           s    xl2&2
2040           s
2041           mlc  @dcw@,image&16
2042 litgb     mcw  &input&13,n2&6
2043           rt   litape,input&1             read in literal
2044           b    noise
2045           ber  tperr
2046           bef  rtnlit                     q. any more literals
2047           mcw  input&4,image&70           code mother recd number
2048           mlc  @/@,image&75               code record
2049           b    prolbl                     process label
2050           b    dcwcd                      process statement
2051 litrtn    b    put                        put record
2052           b    litgb
2053 rtnlit    mcw  &image&13,n2&6
2054           rtw  litape,image&1             regenerate image area
2055           b    noise
2056           ber  tperr
2057           rwd  litape
2058           sw   litsw                      reset literal switch
2059           cw   litsw2
2060           a    &10,exnumb                 section to guarantee
2061           bce  *&5,exnumb-1,0              uniqueness of
2062           b    recall                      literal labels up to
2063           a    &96,exovfl                  80 ltorg or ex cards
2064           a    &96,exovfl
2065           b    recall
2066           ltorg*
2067 grpmk7    dcw  @}@                        system group mark
2068           ex   dozero
2069           job  1401 autocoder-pass 4 end of pass overlay -version 3   3746l
2070           org  save2
2071 eojrt     rwd  litape
2072           b    put                        put end card
2073           wt   outap,output&1             assure last record
2074           nop  0                           is written
2075           ber  tperr                       when blocking
2076           wtm  outap
2077           rwd  outap
2079           cs   input&85                   clear all group
2080           cw   grpmk2,grpmk3               marks
2081           cw   grpmk4
2082           rtw  systap,passc1              read pass 5
2083           nop  0
2084           ber  tperr
2085           lca  totlbl,2393                pass information to
2086           lca  procor,2389                 pass 5
2087           b    passc2                     go to pass 5
2088           dcw  0
2089           dcw  @}@                        system group mark
2090           ex   0
2091 *
2092 * equates
2093 *
2094 intap     equ  %u4
2095 outap     equ  %u5
2096 litape    equ  %u6
2097 k4k       equ  4000
2098 w3area    equ  w6area-3                   equates
2099 w5area    equ  w6area-1
2100 blank     equ  blank4-3
2101 blank2    equ  blank4-2
2102 hold2     equ  b2cntr-3
2103 hold3     equ  b2cntr-2
2104 abit      equ  zone-2
2105 bbit      equ  zone-1
2106 abbit     equ  zone
2107 xxxx      equ  000
2108 input     equ  000
2109 output    equ  3917
2110 passc1    equ  1925
2111 passc2    equ  2400
2112 dozero    equ  000
2113 free      equ  input
2114           end  start
