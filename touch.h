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
 * @brief 000110 = ANA6 000101 = ANA5 000100 = ANA4
 *
 */
#define ANA4 0b000100
#define ANA5 0b000101
#define ANA6 0b000110

typedef void (*ButtonCallback)(void); // 定义回调函数类型

typedef uint16_t (*ReadADCFunction)(uint8_t); // 定义读取ADC值的函数类型

typedef struct {
  uint8_t port; // ADC通道
  uint16_t adcValue;
  uint16_t threshold;
  uint8_t isPressed;
  ReadADCFunction readADC; // 读取ADC值的函数指针
  ButtonCallback onPress;
  ButtonCallback onRelease;
} Button;

/**
 * @brief 电压结构体
 *
 * @param integerPart 整数部分
 * @param decimalPart 小数部分
 */
typedef struct {
  uint8_t integerPart;
  uint32_t decimalPart;
} Voltage;

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
 * @brief 读取adc,并指定端口
 *
 * @return unsigned int
 */
uint16_t readADC_with_Port(uint8_t port);

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
void splitVoltage(uint16_t adcValue, Voltage *voltageStruct);

/**
 * @brief 初始化按键
 *
 * @param button
 * @param port
 * @param threshold
 * @param readADC
 * @param onPress
 * @param onRelease
 */
void initButton(Button *button, uint8_t port, uint16_t threshold,
                ReadADCFunction readADC, ButtonCallback onPress,
                ButtonCallback onRelease);

/**
 * @brief 更新按键状态
 *
 * @param button 按键结构体指针
 */
void updateButtonState(Button *button);

#endif // TOUCH_H