/*
File: STM32F401RE_ADC.c
Author(s): Kavi Dey
Email(s): kdey@hmc.edu
Date: 11/9/23

Source code for ADC functions
*/

#include "STM32L432KC_ADC.h"
#include "STM32L432KC_RCC.h"
#include "stm32l432xx.h"

void initADC(int resolution) {
  // Enable ADC clock
  RCC->AHB2ENR |= RCC_AHB2ENR_ADCEN;
  RCC->CCIPR |= _VAL2FLD(RCC_CCIPR_ADCSEL, 0b11);

  // Disable Deep Power Down
  ADC1->CR &= ~ADC_CR_DEEPPWD;

  // Enable internal voltage regulator
  ADC1->CR |= ADC_CR_ADVREGEN;

  // Wait until the internal voltage regulator is ready (t_ADCVREG_STUP = 20 ns)
  // 5 clock cycles should be more than enough
  volatile int x = 5;
  while (x-- > 0)
    __asm("nop");

  // Set sampling resolution
  ADC1->CFGR |= resolution;

  // Set left bit alignment
  //ADC1->CFGR |= ADC_CFGR_ALIGN;

  // Clear ARDY flag
  ADC1->ISR |= ADC_ISR_ADRDY;

  // Enable ADC
  ADC1->CR |= ADC_CR_ADEN;

  // Wait for ADC to be ready
  while (!(ADC1->ISR & ADC_ISR_ADRDY))
    ;

  // Clear ARDY flag
  ADC1->ISR |= ADC_ISR_ADRDY;
}

void initChannel(int channel1, int channel2, int channel3, int channel4) {
  // We only want to do 4 conversion
  ADC1->SQR1 |= 0b011;
  // Set channel
  ADC1->SQR1 |= channel1 << ADC_SQR1_SQ1_Pos; // first
  ADC1->SQR1 |= channel2 << ADC_SQR1_SQ2_Pos; // second
  ADC1->SQR1 |= channel3 << ADC_SQR1_SQ3_Pos; // third
  ADC1->SQR1 |= channel4 << ADC_SQR1_SQ4_Pos; // fourth
}

uint16_t* readADC() {
  // initialize ADC values
    uint16_t convertedVals[4];

  // Start conversion
  ADC1->CR |= ADC_CR_ADSTART;

  // Wait until conversion is done
  while (!(ADC1->ISR & ADC_ISR_EOC));
  convertedVals[0] = (uint16_t) ADC1->DR;
  while (!(ADC1->ISR & ADC_ISR_EOC));
  convertedVals[1] = (uint16_t) ADC1->DR;
  while (!(ADC1->ISR & ADC_ISR_EOC));
  convertedVals[2] = (uint16_t) ADC1->DR;
  while (!(ADC1->ISR & ADC_ISR_EOC));
  convertedVals[3] = (uint16_t) ADC1->DR;

  // end of regular sequence flag
  while (!(ADC1->ISR & ADC_ISR_EOS));

  // Return the ADC value
  return convertedVals;
}