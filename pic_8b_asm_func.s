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
delay_value_1:  ds  1  /**< @brief 延时变量1 */
delay_value_2:  ds  1  /**< @brief 延时变量2 */

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
 * 该函数初始化微控制器，设置I/O端口，并进入主循环以控制连接到RB0的LED。
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

/** @brief 主循环，切换LED状态 */
loop:
    /** 点亮连接到RB0的LED（阳极连接到RB0） */
    BANKSEL LATB
    BSF     LATB, 0

    /** 延时循环 */
    MOVLW   250    
    MOVWF   delay_value_1
loop1:
    MOVLW   250    
    MOVWF   delay_value_2
loop2:
    DECFSZ  delay_value_2, f
    goto    loop2  /**< @brief 如果delay_value_2不为0，继续减1 */
    DECFSZ  delay_value_1, f
    goto    loop1  /**< @brief 如果delay_value_1不为0，跳回到loop2 */

    /** 熄灭LED */
    BANKSEL LATB
    BCF     LATB, 0

    /** 延时循环 */
    MOVLW   250
    MOVWF   delay_value_1
loop3:
    MOVLW   250
    MOVWF   delay_value_2
loop4:
    DECFSZ  delay_value_2, f
    goto    loop4  /**< @brief 如果delay_value_2不为0，继续减1 */
    DECFSZ  delay_value_1, f
    goto    loop3  /**< @brief 如果delay_value_1不为0，跳回到loop4 */

    goto loop  /**< @brief 返回主循环 */

    end
