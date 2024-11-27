
// TODO
// @ AUDREY, scroll down for ur code


 #include <string.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdint.h>
 #include <stm32l432xx.h>
 #include "stm32l432xx.h"
 //#include "lib/stm32L432KC.h"
 //#include "lib/STM32L432KC.h"
 //#include "lib/STM32L432KC_ADC.h"
 //#include "lib/STM32L432KC_FLASH.h"
 #include "lib/STM32L432KC_GPIO.h"
 #include "lib/STM32L432KC_RCC.h"
 //#include "lib/STM32L432KC_USART.h"
// #include "lib/STM32L432KC_TIM.h"
 //#include "lib/STM32L432KC_I2S.h"
 //#include "lib/STM32L432KC_DAC.h"
 //#include "main.h"


 //////////////////////////////////////////////////
 //// Function Prototypes
 //////////////////////////////////////////////////

 //// Function used by printf to send characters to the laptop
 //int _write(int file, char *ptr, int len) {
 //  int i = 0;
 //  for (i = 0; i < len; i++) {
 //    ITM_SendChar((*ptr++));
 //  }
 //  return len;
 //}
void ms_delay(int ms){
  while (ms-->0){
   
      __asm("nop");

  }
}

uint8_t dacValues[] = {122, 123, 124, 124, 125, 126, 127, 127, 128, 129, 130, 130, 131, 132, 133, 133, 134, 135, 136, 136, 137, 138, 139, 139, 140, 141, 142, 142, 143, 144, 144, 145, 146, 147, 147, 148, 149, 150, 150, 151, 152, 153, 153, 154, 155, 155, 156, 157, 158, 158, 159, 160, 161, 161, 162, 163, 163, 164, 165, 165, 166, 167, 168, 168, 169, 170, 170, 171, 172, 172, 173, 174, 174, 175, 176, 176, 177, 178, 178, 179, 180, 180, 181, 182, 182, 183, 184, 184, 185, 186, 186, 187, 188, 188, 189, 189, 190, 191, 191, 192, 193, 193, 194, 194, 195, 196, 196, 197, 197, 198, 198, 199, 200, 200, 201, 201, 202, 202, 203, 204, 204, 205, 205, 206, 206, 207, 207, 208, 208, 209, 209, 210, 211, 211, 212, 212, 213, 213, 213, 214, 214, 215, 215, 216, 216, 217, 217, 218, 218, 219, 219, 220, 220, 220, 221, 221, 222, 222, 223, 223, 223, 224, 224, 225, 225, 225, 226, 226, 226, 227, 227, 228, 228, 228, 229, 229, 229, 230, 230, 230, 231, 231, 231, 232, 232, 232, 232, 233, 233, 233, 234, 234, 234, 234, 235, 235, 235, 235, 236, 236, 236, 236, 237, 237, 237, 237, 237, 238, 238, 238, 238, 238, 239, 239, 239, 239, 239, 239, 240, 240, 240, 240, 240, 240, 240, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 240, 240, 240, 240, 240, 240, 240, 239, 239, 239, 239, 239, 239, 238, 238, 238, 238, 238, 237, 237, 237, 237, 237, 236, 236, 236, 236, 235, 235, 235, 235, 234, 234, 234, 234, 233, 233, 233, 232, 232, 232, 232, 231, 231, 231, 230, 230, 230, 229, 229, 229, 228, 228, 228, 227, 227, 226, 226, 226, 225, 225, 225, 224, 224, 223, 223, 223, 222, 222, 221, 221, 220, 220, 220, 219, 219, 218, 218, 217, 217, 216, 216, 215, 215, 214, 214, 213, 213, 213, 212, 212, 211, 211, 210, 209, 209, 208, 208, 207, 207, 206, 206, 205, 205, 204, 204, 203, 202, 202, 201, 201, 200, 200, 199, 198, 198, 197, 197, 196, 196, 195, 194, 194, 193, 193, 192, 191, 191, 190, 189, 189, 188, 188, 187, 186, 186, 185, 184, 184, 183, 182, 182, 181, 180, 180, 179, 178, 178, 177, 176, 176, 175, 174, 174, 173, 172, 172, 171, 170, 170, 169, 168, 168, 167, 166, 165, 165, 164, 163, 163, 162, 161, 161, 160, 159, 158, 158, 157, 156, 155, 155, 154, 153, 153, 152, 151, 150, 150, 149, 148, 147, 147, 146, 145, 144, 144, 143, 142, 142, 141, 140, 139, 139, 138, 137, 136, 136, 135, 134, 133, 133, 132, 131, 130, 130, 129, 128, 127, 127, 126, 125, 124, 124, 123, 122, 121, 120, 120, 119, 118, 117, 117, 116, 115, 114, 114, 113, 112, 111, 111, 110, 109, 108, 108, 107, 106, 105, 105, 104, 103, 102, 102, 101, 100, 100, 99, 98, 97, 97, 96, 95, 94, 94, 93, 92, 91, 91, 90, 89, 89, 88, 87, 86, 86, 85, 84, 83, 83, 82, 81, 81, 80, 79, 79, 78, 77, 76, 76, 75, 74, 74, 73, 72, 72, 71, 70, 70, 69, 68, 68, 67, 66, 66, 65, 64, 64, 63, 62, 62, 61, 60, 60, 59, 58, 58, 57, 56, 56, 55, 55, 54, 53, 53, 52, 51, 51, 50, 50, 49, 48, 48, 47, 47, 46, 46, 45, 44, 44, 43, 43, 42, 42, 41, 40, 40, 39, 39, 38, 38, 37, 37, 36, 36, 35, 35, 34, 33, 33, 32, 32, 31, 31, 31, 30, 30, 29, 29, 28, 28, 27, 27, 26, 26, 25, 25, 24, 24, 24, 23, 23, 22, 22, 21, 21, 21, 20, 20, 19, 19, 19, 18, 18, 18, 17, 17, 16, 16, 16, 15, 15, 15, 14, 14, 14};

int main(void) {

//////////////////////////////////////////////////////////////////////////////////
         FLASH->ACR &= ~(7 << 0);
	 FLASH->ACR |= (4 << 0);       // Latency => Four wait states

	 RCC->CR &= ~(1 << 24);        // Main PLL Disable
	 while(RCC->CR & (1 << 24));

	 RCC->PLLCFGR &= ~(3 << 0);
	 RCC->PLLCFGR |= (1 << 0);     // MSI clock selected as PLL

	 RCC->PLLCFGR &= ~(1 << 12);   // PLLN = 0 (just resetting)

	 RCC->PLLCFGR &= ~(7 << 4);    // PLLM = 1
	 RCC->PLLCFGR |= (40 << 8);    // PLLN = 40
	 RCC->PLLCFGR &= ~(3 << 25);   // PLLR = 2
	 RCC->PLLCFGR |= (1 << 24);    // Enable PLLR

	 RCC->CR |= (1 << 24);           // Main PLL Enable
	 while(!(RCC->CR & (1 << 25)));  // Wait until PLL is ready

	 RCC->CFGR &= ~(3 << 0);
	 RCC->CFGR |= (3 << 0);          // PLL selected as system clock

	 while(!( RCC->CFGR & (3 << 2)));   // Wait until PLL used as system clock

	 RCC->CFGR &= ~(1 << 7);  // AHB prescaler = 1
	 RCC->CFGR &= ~(1 << 10); // APB low-speed prescaler (APB1) = 1
	 RCC->CFGR &= ~(1 << 13); // APB high-speed prescaler (APB2) = 1

	 // Final Step
	 SystemCoreClockUpdate();  // Update the System Clock
//////////////////////////////////////////////////////////////////////

  
   // Initialize DMA, DAC, Timer
   RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN);
   RCC->AHB2ENR |= (1<<0);
   //gpioEnable(GPIO_PORT_A);
   //gpioEnable(GPIO_PORT_B);
   //gpioEnable(GPIO_PORT_C);

   //pinMode(4, GPIO_ANALOG);


   RCC->AHB1ENR |= (RCC_AHB1ENR_DMA1EN);   // Enable DMA 1
   RCC->APB1ENR1 |= RCC_APB1ENR1_DAC1EN; // DAC ENABLE
   RCC->APB1ENR1 |= (RCC_APB1ENR1_TIM7EN); //enable tim7, AHBxENR or RCC_APBxENRy reg


   // INITIALIZE DMA 
   DMA1_Channel3->CCR &= ~(0xffffffff);
   DMA1_Channel3->CPAR = _VAL2FLD(DMA_CPAR_PA, (uint32_t) &(DAC1->DHR8R1)); //DAC outplacement
   DMA1_Channel3->CMAR = _VAL2FLD(DMA_CMAR_MA, (uint32_t) &dacValues); //|=  _VAL2FLD(DMA_CMAR_MA, (uint32_t) &CHAR_ARRAY)); //TODO
   DMA1_Channel3->CNDTR |= _VAL2FLD(DMA_CNDTR_NDT, 679);// |= _VAL2FLD(DMA_CNDTR_NDT, CHAR_ARRAY_SIZE); // TODO DOUBLE CHECK THIS, Pg. 315;
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PL, 0b10);  // set priority lvl to very high B)
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_DIR, 0b1); // read from memory, 0b1
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MEM2MEM, 0b0);
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_CIRC, 0b1); // enable circular mode
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MINC, 0b1); 
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PINC, 0b1); 
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MSIZE, 0b00); //TODO: set to 8 for now // data size of DMA transfer in memory 0b01 sets to 16 bits
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PSIZE, 0b00); // data size of DMA transfer in peripheral, 
   DMA1_CSELR->CSELR |= _VAL2FLD(DMA_CSELR_C3S, 0b0110);
   DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_EN, 0b1);
   

  // INITIALIZE TIMER 7
  //RCC->APB1ENR1 |= (1 << 5);  // Enable Timer 7
  RCC->APB1ENR1 |= (RCC_APB1ENR1_TIM7EN);
  TIM7->PSC = 99;  // Prescaler = 99
  TIM7->ARR = 35;  // Period =  35
  TIM7->CR2 |= (TIM_CR2_CCDS);
  TIM7->CR2 |= (2 << 4); // Update Event
  TIM7->CR1 |= (1 << 0);  // Counter enable
  //TIM7->DIER |= (TIM_DIER_UDE);

     
   // INITIALIZE DAC - initDAC();
   DAC1->CR |= _VAL2FLD(DAC_CR_TEN1, 0b1); // DAC channel1 trigger enable
   DAC1->CR |= _VAL2FLD(DAC_CR_TSEL1, 0b010); // : DAC channel1 trigger selection to TIM7 (pg. 492)
   
   DAC1->MCR |= _VAL2FLD(DAC_MCR_MODE1, 0b000);
   DAC->CR |= _VAL2FLD(DAC_CR_DMAEN1, 0b1); // Enable DMA

   // traingle wave
  DAC1->CR |= _VAL2FLD(DAC_CR_WAVE1, 0b10);
  DAC1->CR |= _VAL2FLD(DAC_CR_MAMP1, 0b1010);
   
  DAC1->CR |= _VAL2FLD(DAC_CR_EN1, 0b1); // DAC channel powered on by setting its corresponding ENx bit in the DAC_CR register. (p. 489)

    // write to dac channel 1 12-bit register




   uint16_t i = 1;

   while(1) {
      /*
      if (i < 1020) {
        i++;
        ms_delay(1);
      } else {
        i = 0;
      }
      //DAC1->DHR8R1 &= _VAL2FLD(DAC_DHR8R1_DACC1DHR, 0b00000000);

      DAC1->DHR12R1 = i;// |= _VAL2FLD(DAC_DHR8R1_DACC1DHR, ~i);

     */
     


   }
 }

























////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
// BELOW THIS LINE IS AUDREY SPI CODE    BELOW THIS LINE IS AUDREY SPI CODE
// BELOW THIS LINE IS AUDREY SPI CODE    BELOW THIS LINE IS AUDREY SPI CODE
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

/**
    Main: Contains main function for AES SPI communication with FPGA.
    Sends the plaintext and key over SPI to the FPGA and then receives back
    the cyphertext. The cyphertext is then compared against the solution
    listed in Appendix A of the AES FIPS 197 standard.
    @file lab7.c
    @author Audrey Vo
    @version 1.0 11/19/2024
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
#include "lib/STM32L432KC_TIM.h"
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

// int main(void) {
//    // Configure flash and PLL at 80 MHz
//   //configureFlash();
//   //configureClock();

//   // Enable interrupts
//   RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
//   __enable_irq();

//   // Set up analog input
//   pinMode(ANALOG_IN1, GPIO_ANALOG);
//   pinMode(ANALOG_IN2, GPIO_ANALOG);
//   pinMode(ANALOG_IN3, GPIO_ANALOG);
//   pinMode(ANALOG_IN4, GPIO_ANALOG);

//   // Load and done pins
//   pinMode(PA9, GPIO_OUTPUT);  // LOAD
//   pinMode(PA6, GPIO_INPUT);   // DONE

//   // Artificial chip select signal to allow 8-bit CE-based SPI decoding on the logic analyzers.
  
//   //digitalWrite(SPI_CE, 1);

//   /// Setup GPIO ///
//   // Enable Clock for GPIO Ports A, B, and C
//   gpioEnable(GPIO_PORT_A);
//   gpioEnable(GPIO_PORT_B);
//   gpioEnable(GPIO_PORT_C);


//   // Enable GPIOA clock
//   RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN);

//   // Set up SPI
//   initSPI(1,0,0);

//   // Enable timer 2 for delay function
//   RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN; //enable tim2

//   // Initialize timer
//   initTIM(printTIM); // 1ms


//   ////////////////////////////////////////////
//   ////// CALL ADC for EQ Fiters  
//   ////////////////////////////////////////////
//   // Setup ADC
//   initADC(ADC_8BIT_RESOLUTION);
//   initChannel(ANALOG_IN_ADC_CHANNEL1, ANALOG_IN_ADC_CHANNEL2, ANALOG_IN_ADC_CHANNEL3, ANALOG_IN_ADC_CHANNEL4);
  


//   // timer to generate interrupt to convert adc (sampling rate)
//   // in interrupt, store ADC
//   ////////////////////////////////////////////
//   ////// CALL SPI TO SEND EQFILTERS TO FPGA
//   ////////////////////////////////////////////

//     // Artificial chip select signal to allow 8-bit CE-based SPI decoding on the logic analyzers.
//     pinMode(SPI_CE, GPIO_OUTPUT);
//     digitalWrite(SPI_CE, 1);
//     uint16_t convertedVals[5] = {0, 0, 0, 0, 0};
//     int i;

// /*
//       // Write LOAD high
//   digitalWrite(PA9, 1);
  
//   convertedVals[0] = (uint16_t) 0x0012;
//   convertedVals[1] = (uint16_t) 0x0034;
//   convertedVals[2] = (uint16_t) 0x0056;
//   convertedVals[3] = (uint16_t) 0x0078;
//   convertedVals[4] = (uint16_t) 0x0099;
//   // Send the key
//   for(i = 0; i < 5; i++) {
//     digitalWrite(SPI_CE, 1); // Arificial CE high
//     spiSendReceive((char)convertedVals[i]);
//     digitalWrite(SPI_CE, 0); // Arificial CE low
//   }
  
//   while(SPI1->SR & SPI_SR_BSY); // Confirm all SPI transactions are completed
//   digitalWrite(PA9, 0); // Write LOAD low

// */
//   while(1) {
  
//   readADC(convertedVals);
//   printf("1st channel: %d \n", convertedVals[0]);
//   printf("2nd channel: %d \n", convertedVals[1]);
//   printf("3rd channel: %d \n", convertedVals[2]);
//   printf("4th channel: %d \n", convertedVals[3]);

//   delay_millis(printTIM, 100);

//   // Write LOAD high
//   digitalWrite(PA9, 1);

//     // Send the key
//   for(i = 0; i < 4; i++) {
//     digitalWrite(SPI_CE, 1); // Arificial CE high
//     spiSendReceive((char)convertedVals[i]);
//     digitalWrite(SPI_CE, 0); // Arificial CE low
//   }
  
//   while(SPI1->SR & SPI_SR_BSY); // Confirm all SPI transactions are completed
//   digitalWrite(PA9, 0); // Write LOAD low


//   }
  

//   ////////////////////////////////////////////
//   ////// RECIEVE AUDIO FILE
//   ////////////////////////////////////////////



//   ////////////////////////////////////////////
//   ////// CALL DAC FOR AUDIO FILES
//   ////////////////////////////////////////////

// }

int main(void) {
 
  // Enable interrupts
  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
  __enable_irq();

  // Set up analog input
  pinMode(ANALOG_IN1, GPIO_ANALOG);
  pinMode(ANALOG_IN2, GPIO_ANALOG);
  pinMode(ANALOG_IN3, GPIO_ANALOG);
  pinMode(ANALOG_IN4, GPIO_ANALOG);

  // Load and done pins
  pinMode(PA9, GPIO_OUTPUT);  // LOAD
  pinMode(PA6, GPIO_INPUT);   // DONE

  // Enable Clock for GPIO Ports A, B, and C
  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);
  gpioEnable(GPIO_PORT_C);

  // Enable GPIOA clock
  RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN);

  // Set up I2S
  initI2S;

  // Enable timer 2 for delay function
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN; //enable tim2

  // Initialize timer
  initTIM(printTIM); // 1ms

  while(1) {
  
  // read in audio data
  readADC(convertedVals);
  printf("1st channel: %d \n", convertedVals[0]);
  printf("2nd channel: %d \n", convertedVals[1]);
  printf("3rd channel: %d \n", convertedVals[2]);
  printf("4th channel: %d \n", convertedVals[3]);

  delay_millis(printTIM, 100);

  // Write LOAD high
  digitalWrite(PA9, 1);

  // Send the key
  for(i = 0; i < 4; i++) {
    digitalWrite(SPI_CE, 1); // Arificial CE high
    spiSendReceive((char)convertedVals[i]);
    digitalWrite(SPI_CE, 0); // Arificial CE low
  }
  

  }
  

  ////////////////////////////////////////////
  ////// RECIEVE AUDIO FILE
  ////////////////////////////////////////////
  


  ////////////////////////////////////////////
  ////// CALL DAC FOR AUDIO FILES
  ////////////////////////////////////////////

}
