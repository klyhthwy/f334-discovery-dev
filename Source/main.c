/**
 * @file main.c
 *
 * @author kelly.hathaway
 * @date Initial: Feb 24, 2018
 * @version 1
 * @date Released: Not Released
 * @details
 */


#include <stdint.h>
#include "stm32f3348_discovery.h"


int main(void)
{
    BSP_LED_Init(LED_BLUE);
    BSP_LED_On(LED_BLUE);
    for(;;)
    {
    }
}
