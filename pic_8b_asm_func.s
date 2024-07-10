#include <xc.inc>

/** @brief 配置和初始化段 */
psect   init, class=CODE, delta=2
psect   end_init, class=CODE, delta=2
psect   powerup, class=CODE, delta=2
psect   cinit, class=CODE, delta=2
psect   functab, class=ENTRY, delta=2
psect   idloc, class=IDLOC, delta=2, noexec
psect   eeprom_data, class=EEDATA, delta=2, space=3, noexec
psect   intentry, class=CODE, delta=2
psect   reset_vec, class=CODE, delta=2

/** @brief 全局定义 */
global _main, reset_vec, start_initialization

/** @brief 配置设置 */
psect config, class=CONFIG, delta=2
    dw    0xDFEC
    dw    0xF7FF
    dw    0xFFBF
    dw    0xEFFE
    dw    0xFFFF
    
/** @brief 复位向量，跳转到主函数 */
psect reset_vec
reset_vec:
    ljmp    _main

/** @brief 初始化段 */
psect cinit
start_initialization:

/** @brief 公共变量 */
psect CommonVar, class=COMMON, space=1, delta=1
char_case: ds 1  /**< @brief 字符变量 */


/** @brief 中断服务程序向量 */
psect intentry
intentry:
    retfie

/** @brief 主代码段 */
psect main, class=CODE, delta=2

global _main

/** @def RP0
 *  @brief 寄存器页0
 */
#define RP0 5
/** @def RP1
 *  @brief 寄存器页1
 */
#define RP1 6

/**
 * @brief 主函数
 *
 * 该函数初始化微控制器，设置I/O端口
 * 初始化定时器0，设置定时器0实现0.5s延时
 */
_main:
    /** 初始化PORTB和LATB为0 */
    BANKSEL PORTB
    CLRF    PORTB
    BANKSEL LATB
    CLRF    LATB

    /** 将ANSELB设置为数字I/O（默认是模拟） */
    BANKSEL ANSELB
    CLRF    ANSELB

    /** 设置RB0为输出 */
    BANKSEL TRISB
    BCF     TRISB, 0

    /** 设置端脚复用*/
    BANKSEL RB0PPS
    MOVLW   0x18//TMR0=0x18
    MOVWF   RB0PPS

    /** 初始化time 0*/
    //T0CON0=1xx10001
    //T0CON1=01010010
    BANKSEL T0CON0
    MOVLW   0b10010001 // T0CON0配置
    MOVWF   T0CON0
    BANKSEL T0CON1
    MOVLW   0b01010000 // T0CON1配置
    MOVWF   T0CON1

    //死循环
    LOOP:
        GOTO    LOOP

    END