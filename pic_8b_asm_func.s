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
/** @brief 显示数据,display子函数的参数 
 *  @details 数据结构从高位到低位分别为：数码管1、数码管2、数码管3、数码管4
 *           每个数码管的数据结构为：4位,从0到15分别对应0到F
 */
display_data: ds 2
/**
 * @brief 译码后的数据
 */

/** @brief 中断服务程序向量 */
psect intentry
intentry:
    retfie

/** @brief 主代码段 */
psect main, class=CODE, delta=2

global _main

/** @brief 显示子程序
 *  @param display_data 2个字节的显示数据
 *  @details 数据结构从高位到低位分别为：数码管1、数码管2、数码管3、数码管4
 *           每个数码管的数据结构为：4位,从0到15分别对应0到F
 */
psect display, class=CODE, delta=2
display:
    // 软件译码
    movf    display_data, W
    call    display_1
    return

/** @def RP0
 *  @brief 寄存器页0
 */
#define RP0 5
/** @def RP1
 *  @brief 寄存器页1
 */
#define RP1 6
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

/**
 * @brief 主函数
 *
 * 该函数初始化微控制器，设置I/O端口，并进入主循环以控制连接到RB0的LED。
 */
_main:


    end

