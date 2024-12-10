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
#include "lib/STM32L432KC_TIM.h"
#include "lib/STM32L432KC_SPI.h"
#include "lib/STM32L432KC_DAC.h"
#include "main.h"

// test SINE wave for DMA & DAC testing
static const uint8_t audio[] = {126, 136, 146, 156, 166, 175, 185, 194, 202, 210, 217, 224, 230, 235, 240, 244, 247, 249, 251, 251, 251, 250, 248, 246, 242, 238, 233, 227, 221, 214, 206, 198, 189, 180, 171, 161, 151, 141, 131, 121, 111, 101, 91, 81, 72, 63, 54, 46, 38, 31, 25, 19, 14, 10, 6, 4, 2, 1, 1, 1, 3, 5, 8, 12, 17, 22, 28, 35, 42, 50, 58, 67, 77, 86, 96, 106, 116}; // 77 samples

////////////////////////////////////////////////
 //// Debugging Function Prototypes
 //////////////////////////////////////////////////
// Function used by printf to send characters to the laptop
int _write(int file, char *ptr, int len) {
  int i = 0;
  for (i = 0; i < len; i++) {
    ITM_SendChar((*ptr++));
  }
  return len;
}

void ms_delay(int ms){
  while (ms-->0){
      __asm("nop");

  }
}
 char leftAudioneg;
 char leftAudio;

////////////////////////////////////////////////
// Main
////////////////////////////////////////////////


int main(void) {
  // Configure flash and PLL at 80 MHz
  configureFlash();
  configureClock();
  
  //// Enable interrupts
  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
  __enable_irq();

  // ENABLE PERIPHERALS: DMA1, DMA2, DAC1, TIM7
  RCC->AHB1ENR |= (RCC_AHB1ENR_DMA1EN);   // Enable DMA 1
  RCC->APB1ENR1 |= RCC_APB1ENR1_DAC1EN; // Enable DAC1
  RCC->AHB1ENR |= (RCC_AHB1ENR_DMA2EN);   // Enable DMA 2
  RCC->APB1ENR1 |= (RCC_APB1ENR1_TIM7EN); // Enable TIM7

  /// Setup GPIO, Enable Clock for GPIO Ports A, B, and C
  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);
  gpioEnable(GPIO_PORT_C);

  // Set up analog input
  pinMode(ANALOG_IN1, GPIO_ANALOG);
  pinMode(ANALOG_IN2, GPIO_ANALOG);
  pinMode(ANALOG_IN3, GPIO_ANALOG);
  pinMode(ANALOG_IN4, GPIO_ANALOG);

  // Load and done pins
  pinMode(PA9, GPIO_OUTPUT);  // LOAD
  pinMode(PA6, GPIO_INPUT);   // DONE

  // Artificial chip select signal to allow 8-bit CE-based SPI decoding on the logic analyzers.
  digitalWrite(SPI_CE, 1);

  // Enable GPIOA clock
  RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN);

  // Set up SPI
  initSPI(0b1,0,0);

  // Init DMA for Audio #1 (left)
   DMA1_Channel3->CCR &= ~(0xffffffff); // reset values
   DMA1_Channel3->CPAR = (uint32_t) &(DAC1->DHR8R1); //Place DMA into DAC Outplacement 
   DMA1_Channel3->CMAR = (uint32_t) &leftAudio; // set source address to character array buffer in memory.
   DMA1_Channel3->CNDTR = sizeof(leftAudio); // Set DMA data transfer length (# of samples).
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PL, 0b10);  // set priority lvl to very high B)
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_DIR, 0b1); // read from memory, 0b1
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_CIRC, 0b1); // enable circular mode
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MINC, 0b1); // memory increment mode enabled
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MSIZE, 0b00); //Memory size set to 8 bits, data size of DMA transfer in memory 
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PSIZE, 0b00); // peripheral size = 8 bits, Defines the data size of each DMA transfer to the identified peripheral. Set to 8, 0b00
   DMA1_CSELR->CSELR |= _VAL2FLD(DMA_CSELR_C3S, 0b0110); // set dma channel 3 to DAC1_channel1
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_EN, 0b1); 

  // Init DMA for Audio #2 (right)
   DMA2_Channel5->CCR &= ~(0xffffffff); // reset values
   DMA2_Channel5->CPAR = (uint32_t) &(DAC1->DHR8R2); //Place DMA into DAC Outplacement 
   DMA2_Channel5->CMAR = (uint32_t) &leftAudio; // set source address to character array buffer in memory.
   DMA2_Channel5->CNDTR = sizeof(leftAudio); // Set DMA data transfer length (# of samples).
   DMA2_Channel5->CCR |= _VAL2FLD(DMA_CCR_PL, 0b01);  // set priority lvl to very high B)
   DMA2_Channel5->CCR |= _VAL2FLD(DMA_CCR_DIR, 0b1); // read from memory, 0b1
   DMA2_Channel5->CCR |= _VAL2FLD(DMA_CCR_CIRC, 0b1); // enable circular mode
   DMA2_Channel5->CCR |= _VAL2FLD(DMA_CCR_MINC, 0b1); // memory increment mode enabled
   DMA2_Channel5->CCR |= _VAL2FLD(DMA_CCR_MSIZE, 0b00); //Memory size set to 8 bits, data size of DMA transfer in memory 
   DMA2_Channel5->CCR |= _VAL2FLD(DMA_CCR_PSIZE, 0b00); // peripheral size = 8 bits, Defines the data size of each DMA transfer to the identified peripheral. Set to 8, 0b00
   DMA2_CSELR->CSELR |= _VAL2FLD(DMA_CSELR_C5S, 0b0011); // set dma channel 3 to DAC1_channel1
   DMA2_Channel5->CCR |= _VAL2FLD(DMA_CCR_EN, 0b1); 

   // Enable timer 2 for delay function
   RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN; //enable tim2

   // Initialize timers
   initTIM(printTIM); // 1ms

   // init timer 7 for trigger of DAC
   inittim7();

   // initialize DAC1 & DAC2
   initDAC();

  ////////////////////////////////////////////
  ////// CALL ADC for EQ Fiters  
  ////////////////////////////////////////////
  // Setup ADC
  initADC(ADC_8BIT_RESOLUTION);
  initChannel(ANALOG_IN_ADC_CHANNEL1, ANALOG_IN_ADC_CHANNEL2, ANALOG_IN_ADC_CHANNEL3, ANALOG_IN_ADC_CHANNEL4);

  ////////////////////////////////////////////
  ////// CALL SPI TO SEND EQFILTERS TO FPGA
  ////////////////////////////////////////////

    // Artificial chip select signal to allow 8-bit CE-based SPI decoding on the logic analyzers.
    pinMode(SPI_CE, GPIO_OUTPUT);
    digitalWrite(SPI_CE, 1);
    uint16_t convertedVals[5] = {0, 0, 0, 0, 0};
    int i;

  int counter = 0;
  while(1) {

  readADC(convertedVals); 

  
  printf("left: %d \n", leftAudio);
  

  // Write LOAD high
  digitalWrite(PA9, 1);

  for(i = 0; i < 4; i++) {
    spiSendReceive((char)convertedVals[i]);
  }
  while(SPI1->SR & SPI_SR_BSY); // Confirm all SPI transactions are completed
  digitalWrite(PA9, 0); // Write LOAD low
  

 // Wait for DONE signal to be asserted by FPGA signifying that the data is ready to be read out.
  while(!digitalRead(PA6));
  leftAudioneg = spiSendReceive(0); 
  leftAudio = leftAudioneg + 128; // shift to get signed to unsigned (DAC cannot send negative voltages)
}
}

 




  