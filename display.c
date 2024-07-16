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
#include <stdbool.h>
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
  uint8_t *digits[4] = {&(Display->digit4), &(Display->digit3),
                        &(Display->digit2), &(Display->digit1)};

  for (size_t i = 0; digit[i] != '\0' && j < 4; i++) {
    if (digit[i] == '.') {
      with_dp = true;
    } else {
      *digits[j++] = encode(digit[i], with_dp);
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
  default:
    return 0x00; // 未知字符返回0
  }
}