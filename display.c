/**
 * @file display.c
 * @author 王一赫 (wyihe5220@gmail.com)
 * @brief
 * @version 0.1
 * @date 2024-07-16
 *
 * @copyright copyright (c) 2024
 *   Licensed to the Apache Software Foundation (ASF) under one
 *   or more contributor license agreements.  See the NOTICE file
 *   distributed with this work for additional information
 *   regarding copyright ownership.  The ASF licenses this file
 *   to you under the Apache License, Version 2.0 (the
 *   "License"); you may not use this file except in compliance
 *   with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing,
 *   software distributed under the License is distributed on an
 *   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *   KIND, either express or implied.  See the License for the
 *   specific language governing permissions and limitations
 *   under the License.
 *
 */

#include "display.h"
#include <stdarg.h>
#include <stdbool.h>
#include <string.h>
#include <xc.h>


/**
 * @brief 将字符串译码为数码管显示,并写入显存
 *
 * @param Display 显示数据结构体指针
 * @param digit 显示的字符串
 */
void displaychar(PDisplayData Display, char *digit) {
  _Bool with_dp = false;
  size_t j = 0;
  uint8_t *digits[4] = {&(Display->digit1), &(Display->digit2),
                        &(Display->digit3), &(Display->digit4)};

  for (size_t i = 0; digit[i] != '\0' && j < 4; i++) {
    if (digit[i + 1] == '.') {
      with_dp = true;
    } else {
      *digits[j++] = encode(digit[i - with_dp], with_dp);
      with_dp = false;
    }
  }

  // 如果输入字符串不足4位，剩余的位设置为0
  while (j < 4) {
    *digits[j++] = 0;
  }
}
/**
 * @brief 将ANSIC码译为段码
 * @param ch 输入的ANSIC字符
 * @param with_dp 是否带小数点
 * @return 对应的段码
 */
unsigned char encode(char ch, _Bool with_dp) {
  switch (ch) {
  case '0':
    return with_dp ? ZERO_DIS_DP : ZERO_DIS;
  case '1':
    return with_dp ? ONE_DIS_DP : ONE_DIS;
  case '2':
    return with_dp ? TWO_DIS_DP : TWO_DIS;
  case '3':
    return with_dp ? THREE_DIS_DP : THREE_DIS;
  case '4':
    return with_dp ? FOUR_DIS_DP : FOUR_DIS;
  case '5':
    return with_dp ? FIVE_DIS_DP : FIVE_DIS;
  case '6':
    return with_dp ? SIX_DIS_DP : SIX_DIS;
  case '7':
    return with_dp ? SEVEN_DIS_DP : SEVEN_DIS;
  case '8':
    return with_dp ? EIGHT_DIS_DP : EIGHT_DIS;
  case '9':
    return with_dp ? NINE_DIS_DP : NINE_DIS;
  case 'A':
  case 'a':
    return with_dp ? A_DIS_DP : A_DIS;
  case 'B':
  case 'b':
    return with_dp ? B_DIS_DP : B_DIS;
  case 'C':
  case 'c':
    return with_dp ? C_DIS_DP : C_DIS;
  case 'D':
  case 'd':
    return with_dp ? D_DIS_DP : D_DIS;
  case 'E':
  case 'e':
    return with_dp ? E_DIS_DP : E_DIS;
  case 'F':
  case 'f':
    return with_dp ? F_DIS_DP : F_DIS;
  case 'G':
  case 'g':
    return with_dp ? G_DIS_DP : G_DIS;
  case 'H':
  case 'h':
    return with_dp ? H_DIS_DP : H_DIS;
  case 'I':
  case 'i':
    return with_dp ? I_DIS_DP : I_DIS;
  case 'J':
  case 'j':
    return with_dp ? J_DIS_DP : J_DIS;
  case 'K':
  case 'k':
    return with_dp ? K_DIS_DP : K_DIS;
  case 'L':
  case 'l':
    return with_dp ? L_DIS_DP : L_DIS;
  case 'M':
  case 'm':
    return with_dp ? M_DIS_DP : M_DIS;
  case 'N':
  case 'n':
    return with_dp ? N_DIS_DP : N_DIS;
  case 'O':
  case 'o':
    return with_dp ? O_DIS_DP : O_DIS;
  case 'P':
  case 'p':
    return with_dp ? P_DIS : P_DIS;
  case 'Q':
  case 'q':
    return with_dp ? Q_DIS : Q_DIS;
  case 'R':
  case 'r':
    return with_dp ? R_DIS : R_DIS;
  case 'S':
  case 's':
    return with_dp ? S_DIS : S_DIS;
  case 'T':
  case 't':
    return with_dp ? T_DIS : T_DIS;
  case 'U':
  case 'u':
    return with_dp ? U_DIS : U_DIS;
  case 'V':
  case 'v':
    return with_dp ? V_DIS : V_DIS;
  case 'W':
  case 'w':
    return with_dp ? W_DIS : W_DIS;
  case 'X':
  case 'x':
    return with_dp ? X_DIS : X_DIS;
  case 'Y':
  case 'y':
    return with_dp ? Y_DIS : Y_DIS;
  case 'Z':
  case 'z':
    return with_dp ? Z_DIS : Z_DIS;
  case '-':
    return with_dp ? MINUS_DIS : MINUS_DIS;
  case '_':
    return with_dp ? UNDERLINE_DIS : UNDERLINE_DIS;
  case '=':
    return with_dp ? EQUAL_DIS : EQUAL_DIS;
  case '+':
    return with_dp ? PLUS_DIS : PLUS_DIS;
  case '*':
    return with_dp ? ASTERISK_DIS : ASTERISK_DIS;
  case '/':
    return with_dp ? SLASH_DIS : SLASH_DIS;
  case '\\':
    return with_dp ? BACKSLASH_DIS : BACKSLASH_DIS;
  case '%':
    return with_dp ? PERCENT_DIS : PERCENT_DIS;
  case '<':
    return with_dp ? LESS_DIS : LESS_DIS;
  case '>':
    return with_dp ? GREATER_DIS : GREATER_DIS;
  case ' ':
    return with_dp ? BLANK_DIS : BLANK_DIS;
  default:
    return 0x00; // 未知字符返回0
  }
}

void itoa(int value, char *str, int base) {
  char *rc;
  char *ptr;
  char *low;

  // Set 'ptr' to the end of the string
  ptr = str;

  // Set 'low' to the end of the string
  low = ptr;

  // Check for negative value and if so, set 'value' to its absolute value
  if (value < 0 && base == 10) {
    *ptr++ = '-';
    value = -value;
  }

  // Process individual digits
  do {
    *ptr++ = "0123456789abcdef"[value % base];
    value /= base;
  } while (value);

  // Terminate the string
  *ptr-- = '\0';

  // Reverse the digits
  rc = low;
  while (rc < ptr) {
    char tmp = *rc;
    *rc++ = *ptr;
    *ptr-- = tmp;
  }
}

/**
 * @brief 格式化字符串并显示到数码管
 * @param Display 显示数据结构体指针
 * @param format 格式化字符串
 * @param ... 可变参数
 */
/**
 * @brief 格式化字符串并显示到数码管
 * @param Display 显示数据结构体指针
 * @param format 格式化字符串
 * @param ... 可变参数
 */
void displayformatted(PDisplayData Display, const char *format, ...) {
  char buffer[8]; // 最大格式化字符串长度为8
  char *pbuffer = buffer;
  const char *pformat = format;
  va_list args;
  va_start(args, format);

  while (*pformat != '\0' && (pbuffer - buffer) < sizeof(buffer) - 1) {
    if (*pformat == '%') {
      ++pformat;
      uint8_t pad_width = 0;
      if (*pformat == '0') {
        ++pformat;
        if (*pformat >= '1' && *pformat <= '9') {
          pad_width = (uint8_t)(*pformat - '0');
          ++pformat;
        }
      }
      if (*pformat == 'd') {
        int val = va_arg(args, int);
        char num_str[12];
        itoa(val, num_str, 10);
        uint8_t num_len = (uint8_t)strlen(num_str);
        int8_t padding = (int8_t)pad_width - (int8_t)num_len;
        if (padding > 0) {
          while (padding-- > 0 && (pbuffer - buffer) < sizeof(buffer) - 1) {
            *pbuffer++ = '0';
          }
        }
        if (num_len + (pbuffer - buffer) < sizeof(buffer) - 1) {
          strcpy(pbuffer, num_str);
          pbuffer += num_len;
        } else {
          break; // 超出缓冲区长度，停止复制
        }
      }
      // 添加更多格式处理如 %x, %f 等等
    } else {
      *pbuffer++ = *pformat;
    }
    ++pformat;
  }
  *pbuffer = '\0';

  va_end(args);

  displaychar(Display, buffer);
}