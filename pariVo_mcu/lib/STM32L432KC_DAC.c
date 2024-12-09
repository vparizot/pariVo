
//File: STM32L432KC_DAC.c
//Author(s): Victoria Parizot & Audrey Vo
//Email(s): vparizot@g.hmc.edu
//Date: 11/9/24
//Source code for DAC functions


#include "STM32L432KC_DAC.h"
#include "stm32l432xx.h"
#include "STM32L432KC_RCC.h"

/*
initDAC 
8 bit resolution, right aligned
two output channels: DAC1_OUT1 on PA4, DAC1_OUT2 on PA5
*/
void initDAC() {
  // INITIALIZE DAC1 (LEFT) - initDAC();
   DAC1->CR |= _VAL2FLD(DAC_CR_TEN1, 0b1); // DAC channel1 trigger enable
   DAC1->CR |= _VAL2FLD(DAC_CR_TSEL1, 0b010); // : DAC channel1 trigger selection to TIM7 (pg. 492)
   DAC1->MCR |= _VAL2FLD(DAC_MCR_MODE1, 0b000); // 0b000 is: DAC Channel 2 is connected to external pin with Buffer enabled
   DAC->CR |= _VAL2FLD(DAC_CR_DMAEN1, 0b1); // Enable DMA
   DAC1->CR |= _VAL2FLD(DAC_CR_EN1, 0b1); // DAC channel powered on by setting its corresponding ENx bit in the DAC_CR register. (p. 489)
 
  // INITIALIZE DAC2 (right) - initDAC();
   DAC1->CR |= _VAL2FLD(DAC_CR_TEN2, 0b1); // DAC channel1 trigger enable
   DAC1->CR |= _VAL2FLD(DAC_CR_TSEL2, 0b010); // : DAC channel1 trigger selection to TIM7 (pg. 492)
   DAC1->MCR |= _VAL2FLD(DAC_MCR_MODE2, 0b000); // 0b000 is: DAC Channel 2 is connected to external pin with Buffer enabled
   DAC->CR |= _VAL2FLD(DAC_CR_DMAEN2, 0b1); // Enable DMA
   DAC1->CR |= _VAL2FLD(DAC_CR_EN2, 0b1); // DAC channel powered on by setting its corresponding ENx bit in the DAC_CR register. (p. 489)
 
};
