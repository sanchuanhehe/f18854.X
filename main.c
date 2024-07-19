/*
 * File:   main.c
 * Author: hehey
 *
 * Created on July 16, 2024, 11:52 AM
 */

// PIC16F18854 Configuration Bit Settings

// 'C' source line config statements

// CONFIG1
#pragma config FEXTOSC =                                                       \
    OFF // External Oscillator mode selection bits (Oscillator not enabled)
#pragma config RSTOSC =                                                        \
    HFINT1 // Power-up default value for COSC bits (HFINTOSC (1MHz))
#pragma config CLKOUTEN = OFF // Clock Out Enable bit (CLKOUT function is
                              // disabled; i/o or oscillator function on OSC2)
#pragma config CSWEN =                                                         \
    ON // Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
#pragma config FCMEN =                                                         \
    OFF // Fail-Safe Clock Monitor Enable bit (FSCM timer disabled)

// CONFIG2
#pragma config MCLRE =                                                         \
    ON // Master Clear Enable bit (MCLR pin is Master Clear function)
#pragma config PWRTE = OFF   // Power-up Timer Enable bit (PWRT disabled)
#pragma config LPBOREN = OFF // Low-Power BOR enable bit (ULPBOR disabled)
#pragma config BOREN = ON    // Brown-out reset enable bits (Brown-out Reset
                             // Enabled, SBOREN bit is ignored)
#pragma config BORV =                                                          \
    LO // Brown-out Reset Voltage Selection (Brown-out Reset Voltage (VBOR) set
       // to 1.9V on LF, and 2.45V on F Devices)
#pragma config ZCD = OFF // Zero-cross detect disable (Zero-cross detect circuit
                         // is disabled at POR.)
#pragma config PPS1WAY =                                                       \
    OFF // Peripheral Pin Select one-way control (The PPSLOCK bit can be set and
        // cleared repeatedly by software)
#pragma config STVREN = ON // Stack Overflow/Underflow Reset Enable bit (Stack
                           // Overflow or Underflow will cause a reset)

// CONFIG3
#pragma config WDTCPS = WDTCPS_31 // WDT Period Select bits (Divider ratio
                                  // 1:65536; software control of WDTPS)
#pragma config WDTE = SWDTEN      // WDT operating mode (WDT enabled/disabled by
                                  // SWDTEN bit in WDTCON0)
#pragma config WDTCWS =                                                        \
    WDTCWS_7 // WDT Window Select bits (window always open (100%); software
             // control; keyed access not required)
#pragma config WDTCCS = SC // WDT input clock selector (Software Control)

// CONFIG4
#pragma config WRT = WRT_upper // UserNVM self-write protection bits (0x0000 to
                               // 0x01FF write protected)
#pragma config SCANE = not_available // Scanner Enable bit (Scanner module is
                                     // not available for use)
#pragma config LVP =                                                           \
    ON // Low Voltage Programming Enable bit (Low Voltage programming enabled.
       // MCLR/Vpp pin function is MCLR.)

// CONFIG5
#pragma config CP = OFF // UserNVM Program memory code protection bit (Program
                        // Memory code protection disabled)
#pragma config CPD =                                                           \
    OFF // DataNVM code protection bit (Data EEPROM code protection disabled)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include "display.h"
#include "eusart.h"
#include "game.h"
#include "touch.h"
#include <stdint.h>
#include <xc.h>

#define _XTAL_FREQ 1000000UL // 时钟频率是 1 MHz

DisplayData display = {ZERO_DIS, ZERO_DIS, ZERO_DIS, ZERO_DIS, 0b1110};
PDisplayData pDisplayData = &display;
DisplayBuffer displayBuffer = {'0', '0', '0', '0'};
PDisplayBuffer pDisplayBuffer = &displayBuffer;
BulletGame bulletGame = {0, 0, 0, 0};
BulletGamePtr pBulletGame = &bulletGame;
uint8_t COUNT16 = 0;
uint8_t carriage_return = '\r';
void __interrupt() ISR() {
  if (TMR0IF) {
    TMR0IF = 0;
    // 切换位选信号和数码管显示
    if (display.digit_select == 0b1110) {
      display.digit_select = 0b1101;
      PORTA = display.digit_select;
      PORTC = 0;
      PORTC = display.digit2;
    } else if (display.digit_select == 0b1101) {
      display.digit_select = 0b1011;
      PORTA = display.digit_select;
      PORTC = 0;
      PORTC = display.digit3;
    } else if (display.digit_select == 0b1011) {
      display.digit_select = 0b0111;
      PORTA = display.digit_select;
      PORTC = 0;
      PORTC = display.digit4;
    } else if (display.digit_select == 0b0111) {
      display.digit_select = 0b1110;
      PORTA = display.digit_select;
      PORTC = 0;
      PORTC = display.digit1;
    } else {
      display.digit_select = 0b1110;
      PORTA = display.digit_select;
      PORTC = 0;
      PORTC = display.digit1;
    }
  } else if (PIR3bits.RCIF) {
    // PIR3bits.RCIF = 0;
    eusart_rx_func();
    // // TODO:这里添加串口接收中断处理,操作
    if (eusart_receive_buffer == '1') {
      pBulletGame->man_position = (pBulletGame->man_position++) % 5;
      eusart_receive_buffer = 0;
    } else if (eusart_receive_buffer == '2') {
      pBulletGame->man_position = (pBulletGame->man_position--) % 5;
      eusart_receive_buffer = 0;
    }
    eusart_receive_buffer = 0;
    displaygame(pDisplayData, pBulletGame);
    eusart_tx_func(&(display.digit1));
    eusart_tx_func(&(display.digit2));
    eusart_tx_func(&(display.digit3));
    eusart_tx_func(&(display.digit4));
    while (!TX1STAbits.TRMT)
      ;
    // write data
    TXREG = '\r';
  }
}

void onButtonPress4() {
  // 按钮按下的行为
  // static uint8_t i = 0;
  // i++;
  // displayformatted(pDisplayData, "%d", 4);
}

void onButtonRelease4() {
  // 按钮抬起的行为
  // move_bullet(pBulletGame, 1);
  pBulletGame->bullet_position = (pBulletGame->bullet_position++) % 5;
  // pBulletGame->man_position = (pBulletGame->man_position++) % 5;
  displaygame(pDisplayData, pBulletGame);
  eusart_tx_func(&(display.digit1));
  eusart_tx_func(&(display.digit2));
  eusart_tx_func(&(display.digit3));
  eusart_tx_func(&(display.digit4));
  while (!TX1STAbits.TRMT)
    ;
  // write data
  TXREG = '\r';
}
void onButtonPress5() {
  // 按钮按下的行为
  // static uint8_t i = 0;
  // i++;
  // displayformatted(pDisplayData, "%02d", 5);
}

void onButtonRelease5() {
  // 按钮抬起的行为
  // displayformatted(pDisplayData, "%02d", 1);
}
void onButtonPress6() {
  // 按钮按下的行为
  // static uint8_t i = 0;
  // i++;
  // displayformatted(pDisplayData, "%03d", 6);
}

void onButtonRelease6() {
  // 按钮抬起的行为
  // move_bullet(pBulletGame, -1);
  pBulletGame->bullet_position = (pBulletGame->bullet_position--) % 5;
  // pBulletGame->man_position = (pBulletGame->man_position--) % 5;
  displaygame(pDisplayData, pBulletGame);
  eusart_tx_func(&(display.digit1));
  eusart_tx_func(&(display.digit2));
  eusart_tx_func(&(display.digit3));
  eusart_tx_func(&(display.digit4));
  while (!TX1STAbits.TRMT)
    ;
  // write data
  TXREG = '\r';
}
void main(void) {
  // 初始化IO口
  PORTB = 0x00;
  LATB = 0x00; // 设置LATB寄存器的值为0x00
  ANSELB = 0x00;
  PORTC = 0x00;
  LATC = 0x00;
  ANSELC = 0x00;
  PORTA = 0x00;
  LATA = 0x00;
  ANSELA = 0x0f; // 设置ANSELA寄存器的值为0x0f,使得RA4-RA7为模拟输入
  TRISA = 0xf0;
  TRISB = 0x00;
  TRISC = 0x00;
  //   TRISBbits.TRISB0 = 0;
  //   RB0PPS = 0x18;       // TMR0=0x18
  T0CON0 = 0b10000100; // T0CON0配置
  T0CON1 = 0b01010000; // T0CON1配置
  TMR0H = 24;
  // 启用PIE0寄存器中的TMR0IE中断使能位
  PIE0bits.TMR0IE = 1;
  // 启用INTCON寄存器中的PEIE位
  INTCONbits.PEIE = 1;
  // TODO:这里添加开机动画

  // displaychar(pDisplayData, "0000");
  init_game(pBulletGame);

  init_ADC();

  init_eusart_func();
  Button button4;
  Button button5;
  Button button6;
  initButton(&button4, ANA4, 320, readADC_with_Port, onButtonPress4,
             onButtonRelease4);
  initButton(&button5, ANA5, 320, readADC_with_Port, onButtonPress5,
             onButtonRelease5);
  initButton(&button6, ANA6, 340, readADC_with_Port, onButtonPress6,
             onButtonRelease6);
  // 启用INTCON寄存器中的GIE位
  INTCONbits.GIE = 1;
  while (1) {
    updateButtonState(&button4);
    updateButtonState(&button5);
    updateButtonState(&button6);
    COUNT16++;
    if (COUNT16 == 200) {
      COUNT16 = 0;
      update_game(pBulletGame);
      displaygame(pDisplayData, pBulletGame);
    }
  }
  return;
}
