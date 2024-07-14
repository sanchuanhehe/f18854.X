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
/**
 * @brief key_data
 */
key_data: ds 1h
/**
 * @brief 公共索引变量
 */
index: ds 1h
index_1: ds 1h


/** @brief 中断服务程序向量 */
psect intentry
intentry:
    call display_without_encode
    banksel PIR0
    bcf PIR0, 5
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
#define ZERO_DIS_DP   0xBF
#define ONE_DIS_DP    0x86
#define TWO_DIS_DP    0xDB
#define THREE_DIS_DP  0xCF
#define FOUR_DIS_DP   0xE6
#define FIVE_DIS_DP   0xED
#define SIX_DIS_DP    0xFD
#define SEVEN_DIS_DP  0x87
#define EIGHT_DIS_DP  0xFF
#define NINE_DIS_DP   0xEF
#define A_DIS_DP      0xF7
#define B_DIS_DP      0xFC
#define C_DIS_DP      0xB9
#define D_DIS_DP      0xDE
#define E_DIS_DP      0xF9
#define F_DIS_DP      0xF1
#define G_DIS         0x7D
#define G_DIS_DP      0xFD
#define H_DIS         0x76
#define H_DIS_DP      0xF6
#define I_DIS         0x06
#define I_DIS_DP      0x86
#define J_DIS         0x1E
#define J_DIS_DP      0x9E
#define K_DIS         0x76
#define K_DIS_DP      0xF6
#define L_DIS         0x38
#define L_DIS_DP      0xB8
#define M_DIS         0x55
#define M_DIS_DP      0xD5
#define N_DIS         0x37
#define N_DIS_DP      0xB7
#define O_DIS         0x3F
#define O_DIS_DP      0xBF
#define P_DIS         0x73
#define P_DIS_DP      0xF3
#define Q_DIS         0x67
#define Q_DIS_DP      0xE7
#define R_DIS         0x33
#define R_DIS_DP      0xB3
#define S_DIS         0x6D
#define S_DIS_DP      0xED
#define T_DIS         0x78
#define T_DIS_DP      0xF8
#define U_DIS         0x3E
#define U_DIS_DP      0xBE
#define V_DIS         0x3E
#define V_DIS_DP      0xBE
#define W_DIS         0x3E
#define W_DIS_DP      0xBE
#define X_DIS         0x76
#define X_DIS_DP      0xF6
#define Y_DIS         0x6E
#define Y_DIS_DP      0xEE
#define Z_DIS         0x5B
#define Z_DIS_DP      0xDB
#define BLANK_DIS     0x00
#define BLANK_DIS_DP  0x80
#define DASH_DIS      0x40
#define DASH_DIS_DP   0xC0
#define UNDERLINE_DIS 0x08
#define UNDERLINE_DIS_DP 0x88
#define EQUAL_DIS     0x48
#define EQUAL_DIS_DP  0xC8
#define PLUS_DIS      0x70
#define PLUS_DIS_DP   0xF0
#define ASTERISK_DIS  0x37
#define ASTERISK_DIS_DP 0xB7
#define SLASH_DIS     0x5B
#define SLASH_DIS_DP  0xDB
#define BACKSLASH_DIS 0x6E
#define BACKSLASH_DIS_DP 0xEE
#define PERCENT_DIS   0x72
#define PERCENT_DIS_DP 0xF2
#define LESS_DIS      0x71
#define LESS_DIS_DP   0xF1
#define GREATER_DIS   0x76
#define GREATER_DIS_DP 0xF6
#define QUESTION_DIS  0x53
#define QUESTION_DIS_DP 0xD3
#define EXCLAMATION_DIS 0x06
#define EXCLAMATION_DIS_DP 0x86

/** @brief 宏函数
 *  @param A, B, C, D 数据
 *  @details 将A, B, C, D分别写入display_data的第1, 2, 3, 4个字节
 */
print0x MACRO param1,param2,param3,param4
    ; 宏定义开始
    MOVLW param1
    MOVWF display_data
    MOVLW param2
    MOVWF display_data+1
    MOVLW param3
    MOVWF display_data+2
    MOVLW param4
    MOVWF display_data+3
    ; 译码
    call display_encode
    endm

/**
 * @brief 显示不定义画面一帧
 */
printdraw MACRO param1,param2,param3,param4
    ; 宏定义开始
    MOVLW param1
    MOVWF display_data_decode
    MOVLW param2
    MOVWF display_data_decode+1
    MOVLW param3
    MOVWF display_data_decode+2
    MOVLW param4
    MOVWF display_data_decode+3
    call display_one_frame_loop
endm

/** @brief 显示子程序
 *  @param display_data 4个字节的显示数据
 *  @details 数据结构从高位到低位分别为：数码管1、数码管2、数码管3、数码管4
 *           每个数码管的数据结构为：4位,从0到15分别对应0到F
 */
 
psect display, class=CODE, delta=2
global display_0,display_without_encode,display_one_frame_loop
display_0:
    // 软件译码
    call    display_encode
    // 位选切换 TODO:优化位选切换
    // 如果是4(0b0111),则切换到1
display_without_encode:
    /**
     * @brief 显示数据显示位切换程序
     * @details 位选切换程序,使用BRW查表加goto实现
     * 如果是4(0b0111 = 7),则goto display_1
     * 如果是1(0b1110 = 14),则goto display_2
     * 如果是2(0b1101 = 13),则goto display_3
     * 如果是3(0b1011 = 11),则goto display_4
     */
    //从digit_select加载数据到w
    movf    digit_select, w
    // 取出位选数据
    andlw   0x0F
    // 位选切换
    BRW
    // 位选切换表
    goto    display_1//0
    goto    display_1//1
    goto    display_1//2
    goto    display_1//3
    goto    display_1//4
    goto    display_1//5
    goto    display_1//6
    goto    display_1//7
    goto    display_1//8
    goto    display_1//9
    goto    display_1//10
    goto    display_4//11
    goto    display_1//12
    goto    display_3//13
    goto    display_2//14
    goto    display_1//15
    return
display_1://将位选切换到1
    movlw   0b1110
    movwf   digit_select
    //从display_data_decode中取出数据
    movf    display_data_decode, w
    banksel PORTC
    movwf   PORTC
    movf    digit_select, w
    movwf   PORTA
    return
display_2://将位选切换到2
    movlw   0b1101
    movwf   digit_select
    //从display_data_decode+1中取出数据
    movf    display_data_decode+1, w
    banksel PORTC
    movwf   PORTC
    movf    digit_select, w
    movwf   PORTA
    return
display_3://将位选切换到3
    movlw   0b1011
    movwf   digit_select
    //从display_data_decode+2中取出数据
    movf    display_data_decode+2, w
    banksel PORTC
    movwf   PORTC
    movf    digit_select, w
    movwf   PORTA
    return
display_4://将位选切换到4
    movlw   0b0111
    movwf   digit_select
    //从display_data_decode+3中取出数据
    movf    display_data_decode+3, w
    banksel PORTC
    movwf   PORTC
    movf    digit_select, w
    movwf   PORTA
    return

display_one_frame_loop:
    //初始化index
    MOVLW 0
    MOVWF index_1
//利用index,循环256次
outer_loop:
    call display_without_encode
    MOVLW 0
    MOVWF index
inner_loop:
    DECFSZ index, 1   ; 将 index 减1，如果结果为零则跳过下一个指令
    goto inner_loop   ; 跳转到 inner_loop 标签处继续内层循环
    
    // 内层循环结束后继续外层循环
    DECFSZ index_1, 1      ; 将 y 减1，如果结果为零则跳过下一个指令
    goto outer_loop  ; 跳转到 outer_loop 标签处继续外层循环
    return

/**
 * @breif 译码子程序
 * @param display_data 2个字节的显示数据
 * @details 
 */
display_encode:
    ; 取出第一个字节
    movf    display_data, 0
    call    display_encode_h
    movwf   display_data_decode
    
    ; 取出第二个字节
    movf    display_data + 1, 0
    call    display_encode_h
    movwf   display_data_decode + 1
    
    ; 取出第三个字节
    movf    display_data + 2, 0
    call    display_encode_h
    movwf   display_data_decode + 2
display_encode_4:
    ; 取出第四个字节
    movf    display_data + 3, 0
    call    display_encode_h
    movwf   display_data_decode + 3
    
    return

/**
 * @brief 译码子程序,5位译码
 * @param 从display_data中取出数据一个半字节
 * @details 从display_data中取出数据一个半字节并进行译码，返回数码管显示编码
 */
display_encode_h:
    ; 只保留低5位
    andlw   0x1F
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
    retlw      ZERO_DIS_DP
    retlw      ONE_DIS_DP
    retlw      TWO_DIS_DP
    retlw      THREE_DIS_DP
    retlw      FOUR_DIS_DP
    retlw      FIVE_DIS_DP
    retlw      SIX_DIS_DP
    retlw      SEVEN_DIS_DP
    retlw      EIGHT_DIS_DP
    retlw      NINE_DIS_DP
    retlw      A_DIS_DP
    retlw      B_DIS_DP
    retlw      C_DIS_DP
    retlw      D_DIS_DP
    retlw      E_DIS_DP
    retlw      F_DIS_DP
    return
/**
 * @brief 键盘相关函数区域
 */
psect keyboard, class=CODE, delta=2
global keyboard_scan
/**
 * @brief 键盘扫描函数,扫描一次
 * @param key_data 键盘数据,在每次扫描后更新
 * @details 键盘数据结构为：1个字节，表示0-10个按键的状态,为0表示没有按下，为1表示按下1
 *          端口定义：PORTB0-1为键盘端口,采用全扫描的方式
| 按下的按键 | 第1次扫描(1110) | 第2次扫描(1101) | 第3次扫描(1011) | 第4次扫描(0111) |
| ---------- | --------------- | --------------- | --------------- | --------------- |
| 10         | 0110            | 0101            | 0011            | 0111            |
| 4          | 0110            | 1101            | 1011            | 0110            |
| 9          | 1010            | 1001            | 1011            | 0011            |
| 2          | 1010            | 1101            | 1010            | 0111            |
| 1          | 1100            | 1100            | 1011            | 0111            |
| 8          | 1100            | 1101            | 1001            | 0101            |
| 5          | 1110            | 0101            | 1011            | 0101            |
| 3          | 1110            | 1001            | 1001            | 0111            |
| 7          | 1110            | 1100            | 1010            | 0110            |
| 6          | 1110            | 1101            | 0011            | 0011            |
| 0          | 1110            | 1101            | 1011            | 0111            |
 */
keyboard_scan:
    // 1110扫描
    call scan_1110
    BRW ;根据扫描结果跳转
    return//0000
    return//0001
    return//0010
    return//0011
    return//0100
    return//0101
    goto scan_1101_0110//0110
    return//0111
    return//1000
    return//1001
    goto scan_1101_1010//1010
    return//1011
    goto scan_1101_1100//1100
    return//1101
    goto scan_1101_1110//1110
    return//1111
psect scan_0110_xxxx, class=CODE, delta=2
scan_1101_0110:
    // 1101扫描
    call scan_1101
    BRW ;根据扫描结果跳转
    return//0000
    return//0001
    return//0010
    return//0011
    return//0100
    goto scan_1011_0110_0101//0101
    return//0110
    return//0111
    return//1000
    return//1001
    return//1010
    return//1011
    return//1100
    goto scan_1011_0110_1101//1101
    return//1110
    return//1111
scan_1011_0110_0101:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b0011
    xorlw 0b0011
    // 如果不等于0b0011,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0111
    xorlw 0b0111
    // 如果不等于0b0111,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 10
    movwf key_data
    return
scan_1011_0110_1101:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1011
    xorlw 0b1011
    // 如果不等于0b1011,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0110
    xorlw 0b0110
    // 如果不等于0b0110,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 4
    movwf key_data
    return
psect scan_1010_xxxx, class=CODE, delta=2
scan_1101_1010:
    // 1101扫描
    call scan_1101
    BRW ;根据扫描结果跳转
    return//0000
    return//0001
    return//0010
    return//0011
    return//0100
    return//0101
    return//0110
    return//0111
    return//1000
    goto scan_1011_1010_1001//1001
    return//1010
    return//1011
    return//1100
    goto scan_1011_1010_1101//1101
    return//1110
    return//1111
scan_1011_1010_1001:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1011
    xorlw 0b1011
    // 如果不等于0b1011,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b11
    xorlw 0b11
    // 如果不等于0b11,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 9
    movwf key_data
    return
scan_1011_1010_1101:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1010
    xorlw 0b1010
    // 如果不等于0b1010,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0111
    xorlw 0b0111
    // 如果不等于0b0111,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 2 
    movwf key_data
    return
psect scan_1100_xxxx, class=CODE, delta=2
scan_1101_1100:
    // 1101扫描
    call scan_1101
    BRW ;根据扫描结果跳转
    return//0000
    return//0001
    return//0010
    return//0011
    return//0100
    return//0101
    return//0110
    return//0111
    return//1000
    return//1001
    return//1010
    return//1011
    goto scan_1011_1100_1100//1100
    goto scan_1011_1100_1101//1101
    return//1110
    return//1111
scan_1011_1100_1100:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1011
    xorlw 0b1011
    // 如果不等于0b1011,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0111
    xorlw 0b0111
    // 如果不等于0b0111,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 1
    movwf key_data
    return
scan_1011_1100_1101:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1001
    xorlw 0b1001
    // 如果不等于0b1001,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0111
    xorlw 0b0101
    // 如果不等于0b0101,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 8
    movwf key_data
    return
psect scan_1110_xxxx, class=CODE, delta=2
scan_1101_1110:
    // 1101扫描
    call scan_1101
    BRW ;根据扫描结果跳转
    return//0000
    return//0001
    return//0010
    return//0011
    return//0100
    goto scan_1011_1110_0101//0101
    return//0110
    return//0111
    return//1000
    goto scan_1011_1110_1001//1001
    return//1010
    return//1011
    goto scan_1011_1110_1100//1100
    goto scan_1011_1110_1101//1101
    return//1110
    return//1111
scan_1011_1110_0101:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1011
    xorlw 0b1011
    // 如果不等于0b1011,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0101
    xorlw 0b0101
    // 如果不等于0b0101,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 5
    movwf key_data
    return
scan_1011_1110_1001:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1001
    xorlw 0b1001
    // 如果不等于0b1001,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0111
    xorlw 0b0111
    // 如果不等于0b0111,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 3 //TODO:fix3
    movwf key_data
    return
scan_1011_1110_1100:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1010
    xorlw 0b1010
    // 如果不等于0b1010,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0110
    xorlw 0b0110
    // 如果不等于0b0110,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 7
    movwf key_data
    return
scan_1011_1110_1101:
    // 1011扫描
    call scan_1011
    // 判断W是否为0b1011
    xorlw 0b1011
    // 如果等于0b1011,则goto
    btfsc STATUS, 2
    goto scan_0
    // 1011扫描
    call scan_1011
    // 判断W是否为0b0011
    xorlw 0b0011
    // 如果不等于0b0011,则return
    btfss STATUS, 2
    return
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0011
    xorlw 0b0011
    // 如果不等于0b0011,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 6
    movwf key_data
    return
scan_0:
    // 0111扫描
    call scan_0111
    // 判断W是否为0b0111
    xorlw 0b0111
    // 如果不等于0b0111,则return
    btfss STATUS, 2
    return
    // 更新key_data
    movlw 0
    movwf key_data
    return
psect scan_xxxx, class=CODE, delta=2
/**
 * @brief 1110扫描
 */
scan_1110:
    // 将POATB设置为输入
    BANKSEL TRISB
    MOVLW 0b00001110
    MOVWF TRISB
    movwf PORTB
    // 读取PORTB
    MOVF PORTB, 0
    andlw 0x0F
    return
/**
 * @brief 1101扫描
 */
scan_1101:
    // 将POATB设置为输入
    BANKSEL TRISB
    MOVLW 0b00001101
    MOVWF TRISB
    movwf PORTB
    // 读取PORTB
    MOVF PORTB, 0
    andlw 0x0F
    return

/**
 * @brief 1011扫描
 */
scan_1011:
    // 将POATB设置为输入
    BANKSEL TRISB
    MOVLW 0b00001011
    MOVWF TRISB
    movwf PORTB
    // 读取PORTB
    MOVF PORTB, 0
    andlw 0x0F
    return

scan_0111:
    // 将POATB设置为输入
    BANKSEL TRISB
    MOVLW 0b00000111
    MOVWF TRISB
    movwf PORTB
    // 读取PORTB
    MOVF PORTB, 0
    andlw 0x0F
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
    /** 初始化PORTB和LATB为0 */
    BANKSEL PORTB
    CLRF    PORTB
    BANKSEL LATB
    CLRF    LATB

    /** 将ANSELB设置为数字I/O（默认是模拟） */
    BANKSEL ANSELB
    CLRF    ANSELB

    /** 打开B组弱上拉 */
    BANKSEL WPUB
    MOVLW   0xff
    MOVWF   WPUB
    
    MOVLW 0
    MOVWF index_1
    MOVWF index

    /** 初始化time 0*/
    //T0CON0=0b10001000
    //T0CON1=0b01010110
    BANKSEL T0CON0
    MOVLW   0b00000100 // T0CON0配置
    MOVWF   T0CON0
    BANKSEL T0CON1
    MOVLW   0b01010000 // T0CON1配置
    MOVWF   T0CON1
    //TMR0H=24=25-1
    BANKSEL TMR0H
    MOVLW   24
    MOVWF   TMR0H
    //使能TMR0中断
    banksel PIE0
    bsf PIE0, 5
    banksel INTCON
    bsf INTCON, 6
    ; goto draw_0
draw_back:
    banksel INTCON
    bsf INTCON, 7
    //打开定时器
    banksel T0CON0
    bsf T0CON0, 7
    ;进入主循环
    print0x 0x0,0x1,0x2,0x3
    call display_one_frame_loop
    print0x BLANK_DIS, BLANK_DIS, BLANK_DIS, BLANK_DIS
    // 清空key_data
    clrf key_data
loop:
    //扫描键盘并更新显示数据
    call keyboard_scan
    //显示数据显示按下的键
    // 读入key_data
    movf key_data, 0
    // 写入display_data+3
    movwf display_data+3
    // 译码
    call display_encode_4
    goto loop
psect draw_0, class=CODE, delta=2
global draw_0
draw_0:
    printdraw 0x39,0b00001001,0b00001001,0b00001111
    printdraw 1,1,0,0
    printdraw 0,1,1,0
    printdraw 0,0,1,1
    printdraw 0,0,0,3
    printdraw 0,0,0,6
    printdraw 0,0,0,12
    printdraw 0,0,8,8
    printdraw 0,8,8,0
    printdraw 8,8,0,0
    goto draw_1
psect draw_1, class=CODE, delta=2
global draw_1
draw_1:
    printdraw 24,0,0,0
    printdraw 48,0,0,0
    printdraw 0b00100001,0,0,0
    printdraw 0xff,0,0,0
    printdraw 0,0,0,0xff
    printdraw 0,0,0xff,0
    printdraw 0,0xff,0,0
    goto draw_back
    end