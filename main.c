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

#include <pic16f18854.h>
#include <xc.h>

// 闪灯实验

void main(void) {
  PORTB = 0x00;
  LATB = 0x00;
  ANSELB = 0x00;
  TRISBbits.TRISB0 = 0;
  RB0PPS = 0x18;       // TMR0=0x18
  T0CON0 = 0b10001000; // T0CON0配置
  T0CON1 = 0b01010110; // T0CON1配置
  TMR0H = 216;
  while (1) {
    // 主循环中可以执行其他任务
  }
  return;
}
