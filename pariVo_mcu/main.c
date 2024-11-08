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
// Constants
////////////////////////////////////////////////

#define MCK_FREQ 100000
#define chipEnable PA11
#define ANALOG_IN PA3
#define ANALOG_IN_ADC_CHANNEL ADC_PA3

// SPI Communication Pins
#define FPGA_RESET PA11

////////////////////////////////////////////////
// Function Prototypes
////////////////////////////////////////////////

void encrypt(char*, char*, char*);
void checkAnswer(char*, char*, char*);

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
  pinMode(ANALOG_IN, GPIO_ANALOG);


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
  initChannel(ANALOG_IN_ADC_CHANNEL);
  
  // Enable end of conversion interrupt
  NVIC->ISER[0] |= (1 << 18);
  ADC1->IER |= ADC_IER_EOCIE;

  // Start the first conversion
  selectPixel(&sensor_cfg, col_mapping[0], 0);
  ADC1->CR |= ADC_CR_ADSTART;

  // timer to generate interrupt to convert adc (sampling rate)
  // in interrupt, store ADC
  ////////////////////////////////////////////
  ////// CALL SPI TO SEND EQFILTERS TO FPGA
  ////////////////////////////////////////////

    // Artificial chip select signal to allow 8-bit CE-based SPI decoding on the logic analyzers.
    pinMode(chipEnable, GPIO_OUTPUT);
    digitalWrite(chipEnable, 1);


  ////////////////////////////////////////////
  ////// RECIEVE AUDIO FILE
  ////////////////////////////////////////////



  ////////////////////////////////////////////
  ////// CALL DAC FOR AUDIO FILES
  ////////////////////////////////////////////

}

////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////
void ADC1_IRQHandler(void) {
  // Clear the interrupt flag
  ADC1->ISR |= ADC_ISR_EOC;

  if (!frame_done) {
    // Read the ADC value
    pixel_buf_Type *pixel_buf = (curr_buff ? &pixel_buf_a : &pixel_buf_b);
    (*pixel_buf)[y_coord][x_coord] = adcToBrightness(&sensor_cfg, ADC1->DR);

    // Start the next conversion
    x_coord++;
    if (x_coord == HORIZONTAL_RESOLUTION) {
      x_coord = 0;
      y_coord++;
    }
    if (y_coord == VERTICAL_RESOLUTION) {
      y_coord = 0;
      x_coord = 0;
      frame_done = 1;
      return;
    }
    selectPixel(&sensor_cfg, col_mapping[x_coord], y_coord);
    ADC1->CR |= ADC_CR_ADSTART;
  }
}