/*
File: STM32L432KC_DAC.c
Author(s): Victoria Parizot & Audrey Vo
Email(s): vparizot@g.hmc.edu
Date: 11/9/24

Source code for DAC functions
*/

// #include "STM32L432KC_DAC.h"
// #include "stm32l432xx.h"

/*
initDAC 
12 bit resolution, right aligned
two output channels: DAC1_OUT1 on PA4, DAC1_OUT2 on PA5
normal mode
need to set 
*/

//void initDAC(int resolution) {
    
//    Channel 1 Initilization
//    RCC->APB1ENR1 |= RCC_APB1ENR1_DACC1EN; // RCC ENABLE
//    DAC-->CR |= _VAL2FLD(DAC_CR_WAVE1, 0b01); //  DAC channel1 Noise wave generation enabled (pg. 507)
//    DAC-->CR |= _VAL2FLD(DAC_CR_TEN1, 0b1); // DAC channel1 trigger enable
//    DAC-->CR |= _VAL2FLD(DAC_CR_TSEL1, 0b010); // : DAC channel1 trigger selection to TIM7 (pg. 492)
//    DAC-->CR |= _VAL2FLD(DAC_CR_EN1, 0b1); // DAC channel powered on by setting its corresponding ENx bit in the DAC_CR register. (p. 489)
//    DAC-->CR |= _VAL2FLD(DAC_CR_DMAEN1, 0b1); // Enable DMA


    // 17.7.1 DAC control register (DAC_CR)
    // DAC-->CR |= _VAL2FLD(DAC_CR_WAVE2, 0b01); //  DAC channel2 Noise wave generation enabled (pg. 506)
    // DAC-->CR |= _VAL2FLD(DAC_CR_TEN2, 0b0); //
    // DAC-->CR |= _VAL2FLD(DAC_CR_EN2, 0b1); // EN2, 1: DAC channel2 enabled
   
    
    // 17.7.2 DAC software trigger register (DAC_SWTRGR)
    // Do I need to set software triggers?

    // STEP 2: Set 12-bit right alignment: 
    // data for DAC channel1 to be loaded into the DAC_DHR12RD [11:0] bits (stored into the DHR1[11:0] bits)
    // data for DAC channel2 to be loaded into the DAC_DHR12RD [27:16] bits (stored into the DHR2[11:0] bits)
    // The DHR1 and DHR2 registers are then loaded into the DAC_DOR1 and DOR2 registers
    // Data stored in the DAC_DHRx register are automatically transferred to the DAC_DORx register after one APB1 clock cycle,
    
    // 17.7.9 Dual DAC 12-bit right-aligned data holding register (DAC_DHR12RD)

    // 17.7.12 DAC channel1 data output register (DAC_DOR1)
    // 17.7.13 DAC channel2 data output register (DAC_DOR2)

    //STEP 3: SET MODEx[2:0] in DAC_MCR register to 010 for Normal Mode, Disabled buffer, Connected to external pin (pg. 497)
        // IF I USE THE BUFFER, THEN CALLIBRATION CLD BE APPLIED (pg. 498)

    //DAC-->MCR |= _VAL2FLD(DAC_MCR_MODE2, 0b010);
    //DAC-->MCR |= _VAL2FLD(DAC_MCR_MODE1, 0b010);
    //STEP 4: Dual DAC channel conversion (if available) (pg. 499 - 508)
//}


//void initDMA() {

//	RCC->AHB1ENR |= (RCC_APB1ENR_DMA1EN);   // Enable DMA 1

//	DMA1_Channel3->CPAR = (uint32_t) &(DAC1->DHR8R1); // Peripheral address that where we put data into

//	DMA1_Channel3->CMAR = (uint32_t) &adcValues;  // Memory address that where we read data from

//	DMA1_Channel3->CNDTR = 65460;  // How many data are there ?

//	DMA1_Channel3->CCR |= (1 << 4);  // Read from memory

//	DMA1_Channel3->CCR |= (1 << 7);  // Memory increment mode

//	DMA1_Channel3->CCR &= ~(3 << 8);  // Peripheral size = 8 bits

//	DMA1_Channel3->CCR |= (1 << 5);  // Circular mode

//	DMA1_Channel3->CCR &= ~(3 << 10); // Memory size = 8 bits

//	DMA1_CSELR->CSELR |= (6 << 8);  // Channel 3 => DAC1_Channel1

//	DMA1_Channel3->CCR |= (1 << 0); // Enable channel

//}
// void initChannel(int channel) {
  
// }

// uint16_t readADC() {
 
// }





