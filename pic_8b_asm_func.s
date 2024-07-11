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
display_data: ds 4h
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
#define EIGHT_DIS  0x7F
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
display:
    // 软件译码
    call    display_encode
    // 位选切换
    // 如果是4,则切换到1
    movf    digit_select, w
    xorlw   0x04
    btfss   STATUS, 2
    goto    display_1
    // 如果是1,则切换到2
    movf    digit_select, w
    xorlw   0x01
    btfss   STATUS, 2
    goto    display_2
    // 如果是2,则切换到3
    movf    digit_select, w
    xorlw   0x02
    btfss   STATUS, 2
    goto    display_3
    // 如果是3,则切换到4
    movf    digit_select, w
    xorlw   0x03
    btfss   STATUS, 2
    goto    display_4
display_next://下一步操作


    return/
display_1://将位选切换到1
    movlw   0x01
    movwf   digit_select
    goto    display_next
display_2://将位选切换到2
    movlw   0x02
    movwf   digit_select
    goto    display_next
display_3://将位选切换到3
    movlw   0x03
    movwf   digit_select
    goto    display_next
display_4://将位选切换到4
    movlw   0x04
    movwf   digit_select
    goto    display_next
/**
 * @breif 译码子程序
 * @param display_data 2个字节的显示数据
 * @details 
 */
display_encode:
    ; 取出第一个半字节
    movf    display_data, w
    call    display_encode_hf
    movwf   display_data_decode
    
    ; 取出第二个半字节
    movf    display_data + 1, w
    call    display_encode_hf
    movwf   display_data_decode + 1
    
    ; 取出第三个半字节
    movf    display_data + 2, w
    call    display_encode_hf
    movwf   display_data_decode + 2
    
    ; 取出第四个半字节
    movf    display_data + 3, w
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
    andlw   0x0F
    addwf   PCL, f
    
    ; 数码管显示编码表
    dt      ZERO_DIS
    dt      ONE_DIS
    dt      TWO_DIS
    dt      THREE_DIS
    dt      FOUR_DIS
    dt      FIVE_DIS
    dt      SIX_DIS
    dt      SEVEN_DIS
    dt      EIGHT_DIS
    dt      NINE_DIS
    dt      A_DIS
    dt      B_DIS
    dt      C_DIS
    dt      D_DIS
    dt      E_DIS
    dt      F_DIS
    
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
    //@wanwanzhi TODO:完成下这里的端口初始化
    call   display

    // 无限循环
loop:
    goto loop    
    end

