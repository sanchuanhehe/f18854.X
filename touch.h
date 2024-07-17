/**
 * @file touch.h
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
 * @details
 */
#ifndef TOUCH_H
#define TOUCH_H
#include <stdint.h> // uint16_t

/**
 * @brief 初始化adc
 *
 */
void init_ADC();

/**
 * @brief 读取adc
 *
 * @return unsigned int
 */
uint16_t readADC();

/**
 * @brief 将adres转换成电压(单位:V),后10位为小数,前6位为整数
 *
 */
#define ADC2VOLTAGE(adc) ((adc) * 5)

/**
 * @brief 将电压分割为整数部分和小数部分
 *
 * @param uint16_t voltage 电压
 * @param uint8_t integerPart 整数部分
 * @param uint32_t decimalPart 小数部分
 */
void splitVoltage(uint16_t voltage, uint8_t *integerPart,
                  uint32_t *decimalPart);
#endif // TOUCH_H