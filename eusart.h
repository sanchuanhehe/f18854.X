# ifndef _EUSART_H
# define _EUSART_H

# include <xc.h>

extern char eusart_receive_buffer;

void init_eusart_func(void);
void eusart_tx_func(char data);
void eusart_rx_func(void);

# endif