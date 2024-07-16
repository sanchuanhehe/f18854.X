#ifndef DISPLAY_H
#define DISPLAY_H

#include <stdint.h> // uint8_t

/**
 * @brief 显示数据结构体,这个是实际显示的数据结构
 * @details 数据结构从高位到低位分别为：数码管1、数码管2、数码管3、数码管4
 *          每个数码管的数据结构为：8位, 从0到15分别对应0到F
 */
typedef struct {
  uint8_t digit1;       // 数码管1
  uint8_t digit2;       // 数码管2
  uint8_t digit3;       // 数码管3
  uint8_t digit4;       // 数码管4
  uint8_t digit_select; // 4位位选信号
} DisplayData, *PDisplayData;

/**
 * @brief 显示数据,用于译码的缓冲区,4个字符
 *
 */
typedef struct {
  char digit1; // 数码管1
  char digit2; // 数码管2
  char digit3; // 数码管3
  char digit4; // 数码管4
} DisplayBuffer, *PDisplayBuffer;

/**
 * @brief 将字符串译码为数码管显示,并写入显存
 *
 * @param Display 显示数据结构体指针
 * @param digit 显示的字符串
 */
void displaychar(PDisplayData Display, char *digit);

/**
 * @brief 将ANSIC码译为段码
 * @param ch 输入的ANSIC字符
 * @param with_dp 是否带小数点
 * @return 对应的段码
 */
unsigned char encode(char ch, _Bool with_dp);

#define ZERO_DIS 0x3F
#define ONE_DIS 0x06
#define TWO_DIS 0x5B
#define THREE_DIS 0x4F
#define FOUR_DIS 0x66
#define FIVE_DIS 0x6D
#define SIX_DIS 0x7D
#define SEVEN_DIS 0x07
#define EIGHT_DIS 0x7f
#define NINE_DIS 0x6F
#define A_DIS 0x77
#define B_DIS 0x7C
#define C_DIS 0x39
#define D_DIS 0x5E
#define E_DIS 0x79
#define F_DIS 0x71
#define ZERO_DIS_DP 0xBF
#define ONE_DIS_DP 0x86
#define TWO_DIS_DP 0xDB
#define THREE_DIS_DP 0xCF
#define FOUR_DIS_DP 0xE6
#define FIVE_DIS_DP 0xED
#define SIX_DIS_DP 0xFD
#define SEVEN_DIS_DP 0x87
#define EIGHT_DIS_DP 0xFF
#define NINE_DIS_DP 0xEF
#define A_DIS_DP 0xF7
#define B_DIS_DP 0xFC
#define C_DIS_DP 0xB9
#define D_DIS_DP 0xDE
#define E_DIS_DP 0xF9
#define F_DIS_DP 0xF1
#define G_DIS 0x7D
#define G_DIS_DP 0xFD
#define H_DIS 0x76
#define H_DIS_DP 0xF6
#define I_DIS 0x06
#define I_DIS_DP 0x86
#define J_DIS 0x1E
#define J_DIS_DP 0x9E
#define K_DIS 0x76
#define K_DIS_DP 0xF6
#define L_DIS 0x38
#define L_DIS_DP 0xB8
#define M_DIS 0x55
#define M_DIS_DP 0xD5
#define N_DIS 0x37
#define N_DIS_DP 0xB7
#define O_DIS 0x3F
#define O_DIS_DP 0xBF
#define P_DIS 0x73
#define P_DIS_DP 0xF3
#define Q_DIS 0x67
#define Q_DIS_DP 0xE7
#define R_DIS 0x33
#define R_DIS_DP 0xB3
#define S_DIS 0x6D
#define S_DIS_DP 0xED
#define T_DIS 0x78
#define T_DIS_DP 0xF8
#define U_DIS 0x3E
#define U_DIS_DP 0xBE
#define V_DIS 0x3E
#define V_DIS_DP 0xBE
#define W_DIS 0x3E
#define W_DIS_DP 0xBE
#define X_DIS 0x76
#define X_DIS_DP 0xF6
#define Y_DIS 0x6E
#define Y_DIS_DP 0xEE
#define Z_DIS 0x5B
#define Z_DIS_DP 0xDB
#define BLANK_DIS 0x00
#define BLANK_DIS_DP 0x80
#define DASH_DIS 0x40
#define DASH_DIS_DP 0xC0
#define UNDERLINE_DIS 0x08
#define UNDERLINE_DIS_DP 0x88
#define EQUAL_DIS 0x48
#define EQUAL_DIS_DP 0xC8
#define PLUS_DIS 0x70
#define PLUS_DIS_DP 0xF0
#define ASTERISK_DIS 0x37
#define ASTERISK_DIS_DP 0xB7
#define SLASH_DIS 0x5B
#define SLASH_DIS_DP 0xDB
#define BACKSLASH_DIS 0x6E
#define BACKSLASH_DIS_DP 0xEE
#define PERCENT_DIS 0x72
#define PERCENT_DIS_DP 0xF2
#define LESS_DIS 0x71
#define LESS_DIS_DP 0xF1
#define GREATER_DIS 0x76
#define GREATER_DIS_DP 0xF6
#define QUESTION_DIS 0x53
#define QUESTION_DIS_DP 0xD3
#define EXCLAMATION_DIS 0x06
#define EXCLAMATION_DIS_DP 0x86
#define MINUS_DIS 0x40
#define MINUS_DIS_DP 0xC0

#endif