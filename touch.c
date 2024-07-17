/**
 * @file touch.c
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

#include "touch.h"
#include <xc.h>

/**
 * @brief 初始化adc
 *
 * @details ADNREF = 0(VSS) , ADPREF<1:0> = 00(VDD),
 * ADCS<2:0> = 000000 (2.0 s),ADPCH<5:0> = 000110 = ANA6 ,000101 = ANA5
 * ,000100 = ANA4 ADPRE=1,ADDPOL=0
 */
void initADC() {
  ADCON0 = 0b11000101;
  ADCON1 = 0b00000000; // TODO:bit5到bit0展示还要再看看
  ADCON2 = 0b11001100;
  ADCON3 = 0b00100000;
  ADCLK = 0x00; // 设置时钟频率
  ADPCH = 0b00000100; // 设置通道
  // 配置预充电控制
  ADPRE = 0x0F; // 设置预充电时间
  ADACQ = 0x1F; // 设置采集时间
}

/**
 * @brief 读取adc
 *
 * @return unsigned int
 */
unsigned int readADC() {
  ADCON0bits.ADGO = 1;
  while (ADCON0bits.ADGO)
    ;
  return ADRESH << 8 | ADRESL;
}