#include <xc.inc>

    psect   init, class=CODE, delta=2
    psect   end_init, class=CODE, delta=2
    psect   powerup, class=CODE, delta=2
    psect   cinit,class=CODE,delta=2
    psect   functab,class=ENTRY,delta=2
    psect   idloc,class=IDLOC,delta=2,noexec
    psect   eeprom_data,class=EEDATA,delta=2,space=3,noexec
    psect   intentry, class=CODE, delta=2
    psect   reset_vec, class=CODE, delta=2

    global _main, reset_vec, start_initialization

psect config, class=CONFIG, delta=2
    dw	0xDFEC
    dw	0xF7FF
    dw	0xFFBF
    dw	0xEFFE
    dw	0xFFFF
    
    psect	reset_vec
reset_vec:
    ljmp	_main
    
    psect cinit
start_initialization:
   
    psect	CommonVar, class=COMMON, space=1, delta=1
charcase: ds 1h

    psect intentry
intentry:
    retfie
    
psect   main,class=CODE,delta=2 ; PIC10/12/16
    
 global _main
_main:

;write code here

end reset_vec