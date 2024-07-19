#ifndef _EUSART_H
#define _EUSART_H

#include <stdint.h>
#include <xc.h>

extern uint8_t eusart_receive_buffer;
/**
 * @brief   初始化串口
 *
 */
void init_eusart_func(void);
/**
 * @brief  串口发送函数
 *
 * @param data uint8_t * 发送的数据指针
 */
void eusart_tx_func(uint8_t *data);

/**
 * @brief  串口接收函数
 *
 * @details 串口接收函数,存数据到eusart_receive_buffer
 */
void eusart_rx_func(void);

#endif // _EUSART_H