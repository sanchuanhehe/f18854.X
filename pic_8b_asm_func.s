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
; char_case: ds 1h  /**< @brief 字符变量 */
/** @brief 显示数据,display子函数的参数 
 *  @details 数据结构从高位到低位分别为：数码管1、数码管2、数码管3、数码管4
 *           每个数码管的数据结构为：8位,从0到15分别对应0到F
 */
display_data:
    ds 4h       ; 分配4个字节的空间，并初始化为0
/**
 * @brief 译码后的数据
 */
display_data_decode: ds 4h
/**
 * @brief 位选数据
 */
digit_select: ds 1h

/** @brief 中断服务程序向量 */
psect intentry
intentry:
    retfie

/**
 * @brief 宏定义数码管显示
 */
#define ZERO_DIS   0x3F
#define ONE_DIS    0x06
#define TWO_DIS    0x5B
#define THREE_DIS  0x4F
#define FOUR_DIS   0x66
#define FIVE_DIS   0x6D
#define SIX_DIS    0x7D
#define SEVEN_DIS  0x07
#define EIGHT_DIS  0x7f
#define NINE_DIS   0x6F
#define A_DIS      0x77
#define B_DIS      0x7C
#define C_DIS      0x39
#define D_DIS      0x5E
#define E_DIS      0x79
#define F_DIS      0x71


/** @brief 显示子程序
 *  @param display_data 4个字节的显示数据
 *  @details 数据结构从高位到低位分别为：数码管1、数码管2、数码管3、数码管4
 *           每个数码管的数据结构为：4位,从0到15分别对应0到F
 */
 
psect display, class=CODE, delta=2
global display_0
display_0:
    // 软件译码
    call    display_encode
    // 位选切换 TODO:优化位选切换
    // 如果是4(0b0111),则切换到1
    movlw   0b0111
    xorwf   digit_select, w
    btfsc   STATUS, 2
    goto    display_1
    // 如果是1,则切换到2
    movlw   0b1110
    xorwf   digit_select, w
    btfsc   STATUS, 2
    goto    display_2
    // 如果是2,则切换到3
    movlw   0b1101
    xorwf   digit_select, w
    btfsc   STATUS, 2
    goto    display_3
    // 如果是3,则切换到4
    movlw   0b1011
    xorwf   digit_select, w
    btfsc   STATUS, 2
    goto    display_4
    // 如果是其他,则切换到1
    movlw   0b1110
    movwf   digit_select
    goto    display_1

display_next://下一步操作,将位选加载到PORTA
    movf    digit_select, w
    movwf   PORTA
    return
display_1://将位选切换到1
    movlw   0b1110
    movwf   digit_select
    //从display_data_decode中取出数据
    movf    display_data_decode, w
    banksel PORTC
    movwf   PORTC
    goto    display_next
display_2://将位选切换到2
    movlw   0b1101
    movwf   digit_select
    //从display_data_decode+1中取出数据
    movf    display_data_decode+1, w
    banksel PORTC
    movwf   PORTC
    goto    display_next
display_3://将位选切换到3
    movlw   0b1011
    movwf   digit_select
    //从display_data_decode+2中取出数据
    movf    display_data_decode+2, w
    banksel PORTC
    movwf   PORTC
    goto    display_next
display_4://将位选切换到4
    movlw   0b0111
    movwf   digit_select
    //从display_data_decode+3中取出数据
    movf    display_data_decode+3, w
    banksel PORTC
    movwf   PORTC
    goto    display_next
/**
 * @breif 译码子程序
 * @param display_data 2个字节的显示数据
 * @details 
 */
display_encode:
    ; 取出第一个半字节
    movf    display_data, 0
    call    display_encode_hf
    movwf   display_data_decode
    
    ; 取出第二个半字节
    movf    display_data + 1, 0
    call    display_encode_hf
    movwf   display_data_decode + 1
    
    ; 取出第三个半字节
    movf    display_data + 2, 0
    call    display_encode_hf
    movwf   display_data_decode + 2
    
    ; 取出第四个半字节
    movf    display_data + 3, 0
    call    display_encode_hf
    movwf   display_data_decode + 3
    
    return

/**
 * @brief 译码子程序,半字译码
 * @param 从display_data中取出数据一个半字节
 * @details 从display_data中取出数据一个半字节并进行译码，返回数码管显示编码
 */
display_encode_hf:
    ; 从display_data + display_offset中取出数据一个半字节
    BRW
    ; 数码管显示编码表
    retlw      ZERO_DIS
    retlw      ONE_DIS
    retlw      TWO_DIS
    retlw      THREE_DIS
    retlw      FOUR_DIS
    retlw      FIVE_DIS
    retlw      SIX_DIS
    retlw      SEVEN_DIS
    retlw      EIGHT_DIS
    retlw      NINE_DIS
    retlw      A_DIS
    retlw      B_DIS
    retlw      C_DIS
    retlw      D_DIS
    retlw      E_DIS
    retlw      F_DIS
    
    return

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
    BANKSEL PORTA  ;
    CLRF  PORTA  ;Init PORTA
    BANKSEL LATA  ;Data Latch
    CLRF  LATA  ;
    BANKSEL ANSELA  ;
    CLRF  ANSELA  ;digital I/O
    BANKSEL TRISA  ;
    MOVLW 00000000B
    MOVWF TRISA

    BANKSEL PORTC  ;
    CLRF  PORTC  ;Init PORTC
    BANKSEL LATC  ;Data Latch
    CLRF  LATC  ;
    BANKSEL ANSELC  ;
    CLRF  ANSELC  ;digital I/O
    BANKSEL TRISC  ;
    MOVLW 00000000B
    MOVWF TRISC

    //@wanwanzhi TODO:完成下这里的端口初始化
   

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
    //T0CON0=0b10001000
    //T0CON1=0b01010110
    BANKSEL T0CON0
    MOVLW   0b10001000 // T0CON0配置
    MOVWF   T0CON0
    BANKSEL T0CON1
    MOVLW   0b01010110 // T0CON1配置
    MOVWF   T0CON1
    //TMR0H=216=217-1
    BANKSEL TMR0H
    MOVLW   216
    MOVWF   TMR0H
    call    display_0
    //初始化显示数据为8888
    MOVLW   0x08
    MOVWF   display_data
    MOVWF   display_data + 1
    MOVWF   display_data + 2
    MOVWF   display_data + 3
    // 无限循环
loop:
    call    display_0
    goto loop

    end

