/*********************************************************************
*                    SEGGER Microcontroller GmbH                     *
*                        The Embedded Experts                        *
**********************************************************************

-------------------------- END-OF-HEADER -----------------------------

/**
    Main: Contains main function for AES SPI communication with FPGA.
    Sends the plaintext and key over SPI to the FPGA and then receives back
    the cyphertext. The cyphertext is then compared against the solution
    listed in Appendix A of the AES FIPS 197 standard.
    @file lab7.c
    @author Josh Brake
    @version 1.0 7/13/2021
*/
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stm32l432xx.h>
#include "lib/stm32L432KC.h"
#include "lib/STM32L432KC.h"
#include "lib/STM32L432KC_ADC.h"
#include "lib/STM32L432KC_FLASH.h"
#include "lib/STM32L432KC_GPIO.h"
#include "lib/STM32L432KC_RCC.h"
#include "lib/STM32L432KC_USART.h"
#include "main.h"


////////////////////////////////////////////////
// Function Prototypes
////////////////////////////////////////////////

void encrypt(char*, char*, char*);
void checkAnswer(char*, char*, char*);

// Function used by printf to send characters to the laptop
int _write(int file, char *ptr, int len) {
  int i = 0;
  for (i = 0; i < len; i++) {
    ITM_SendChar((*ptr++));
  }
  return len;
}

////////////////////////////////////////////////
// Main
////////////////////////////////////////////////

int main(void) {
   // Configure flash and PLL at 80 MHz
  configureFlash();
  configureClock();

  // Enable interrupts
  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
  __enable_irq();

  // Set up analog input
  pinMode(ANALOG_IN1, GPIO_ANALOG);
  pinMode(ANALOG_IN2, GPIO_ANALOG);
  pinMode(ANALOG_IN3, GPIO_ANALOG);
  pinMode(ANALOG_IN4, GPIO_ANALOG);


  /// Setup GPIO ///
  // Enable Clock for GPIO Ports A, B, and C
  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);
  gpioEnable(GPIO_PORT_C);


  // Enable GPIOA clock
  RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN);

  // Set up SPI
  initSPI(1,0,0);


  ////////////////////////////////////////////
  ////// CALL ADC for EQ Fiters  
  ////////////////////////////////////////////
  // Setup ADC
  initADC(ADC_12BIT_RESOLUTION);
  initChannel(ANALOG_IN_ADC_CHANNEL1, ANALOG_IN_ADC_CHANNEL2, ANALOG_IN_ADC_CHANNEL3, ANALOG_IN_ADC_CHANNEL4);
  


  // timer to generate interrupt to convert adc (sampling rate)
  // in interrupt, store ADC
  ////////////////////////////////////////////
  ////// CALL SPI TO SEND EQFILTERS TO FPGA
  ////////////////////////////////////////////

    // Artificial chip select signal to allow 8-bit CE-based SPI decoding on the logic analyzers.
    pinMode(chipEnable, GPIO_OUTPUT);
    digitalWrite(chipEnable, 1);
    uint16_t convertedVals[4];

  while(1) {

  convertedVals = readADC();
  printf("1st channel: %d", convertedVals[0]);
  printf("2nd channel: %d", convertedVals[1]);
  printf("3rd channel: %d", convertedVals[2]);
  printf("4th channel: %d", convertedVals[3]);
  }


  ////////////////////////////////////////////
  ////// RECIEVE AUDIO FILE
  ////////////////////////////////////////////



  ////////////////////////////////////////////
  ////// CALL DAC FOR AUDIO FILES
  ////////////////////////////////////////////

}

