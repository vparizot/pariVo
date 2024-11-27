/*
//File: STM32L432KC_DAC.c
//Author(s): Victoria Parizot & Audrey Vo
//Email(s): vparizot@g.hmc.edu
//Date: 11/9/24

//Source code for DAC functions
//*/

//#include "STM32L432KC_DAC.h"
//#include "stm32l432xx.h"
//#include "STM32L432KC_RCC.h"

///*
//initDAC 
//8 bit resolution, right aligned
//two output channels: DAC1_OUT1 on PA4, DAC1_OUT2 on PA5
//normal mode
//need to set 
//*/

////uint8_t dacValues[] = {122, 123, 124, 124, 125, 126, 127, 127, 128, 129, 130, 130, 131, 132, 133, 133, 134, 135, 136, 136, 137, 138, 139, 139, 140, 141, 142, 142, 143, 144, 144, 145, 146, 147, 147, 148, 149, 150, 150, 151, 152, 153, 153, 154, 155, 155, 156, 157, 158, 158, 159, 160, 161, 161, 162, 163, 163, 164, 165, 165, 166, 167, 168, 168, 169, 170, 170, 171, 172, 172, 173, 174, 174, 175, 176, 176, 177, 178, 178, 179, 180, 180, 181, 182, 182, 183, 184, 184, 185, 186, 186, 187, 188, 188, 189, 189, 190, 191, 191, 192, 193, 193, 194, 194, 195, 196, 196, 197, 197, 198, 198, 199, 200, 200, 201, 201, 202, 202, 203, 204, 204, 205, 205, 206, 206, 207, 207, 208, 208, 209, 209, 210, 211, 211, 212, 212, 213, 213, 213, 214, 214, 215, 215, 216, 216, 217, 217, 218, 218, 219, 219, 220, 220, 220, 221, 221, 222, 222, 223, 223, 223, 224, 224, 225, 225, 225, 226, 226, 226, 227, 227, 228, 228, 228, 229, 229, 229, 230, 230, 230, 231, 231, 231, 232, 232, 232, 232, 233, 233, 233, 234, 234, 234, 234, 235, 235, 235, 235, 236, 236, 236, 236, 237, 237, 237, 237, 237, 238, 238, 238, 238, 238, 239, 239, 239, 239, 239, 239, 240, 240, 240, 240, 240, 240, 240, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 240, 240, 240, 240, 240, 240, 240, 239, 239, 239, 239, 239, 239, 238, 238, 238, 238, 238, 237, 237, 237, 237, 237, 236, 236, 236, 236, 235, 235, 235, 235, 234, 234, 234, 234, 233, 233, 233, 232, 232, 232, 232, 231, 231, 231, 230, 230, 230, 229, 229, 229, 228, 228, 228, 227, 227, 226, 226, 226, 225, 225, 225, 224, 224, 223, 223, 223, 222, 222, 221, 221, 220, 220, 220, 219, 219, 218, 218, 217, 217, 216, 216, 215, 215, 214, 214, 213, 213, 213, 212, 212, 211, 211, 210, 209, 209, 208, 208, 207, 207, 206, 206, 205, 205, 204, 204, 203, 202, 202, 201, 201, 200, 200, 199, 198, 198, 197, 197, 196, 196, 195, 194, 194, 193, 193, 192, 191, 191, 190, 189, 189, 188, 188, 187, 186, 186, 185, 184, 184, 183, 182, 182, 181, 180, 180, 179, 178, 178, 177, 176, 176, 175, 174, 174, 173, 172, 172, 171, 170, 170, 169, 168, 168, 167, 166, 165, 165, 164, 163, 163, 162, 161, 161, 160, 159, 158, 158, 157, 156, 155, 155, 154, 153, 153, 152, 151, 150, 150, 149, 148, 147, 147, 146, 145, 144, 144, 143, 142, 142, 141, 140, 139, 139, 138, 137, 136, 136, 135, 134, 133, 133, 132, 131, 130, 130, 129, 128, 127, 127, 126, 125, 124, 124, 123, 122, 121, 120, 120, 119, 118, 117, 117, 116, 115, 114, 114, 113, 112, 111, 111, 110, 109, 108, 108, 107, 106, 105, 105, 104, 103, 102, 102, 101, 100, 100, 99, 98, 97, 97, 96, 95, 94, 94, 93, 92, 91, 91, 90, 89, 89, 88, 87, 86, 86, 85, 84, 83, 83, 82, 81, 81, 80, 79, 79, 78, 77, 76, 76, 75, 74, 74, 73, 72, 72, 71, 70, 70, 69, 68, 68, 67, 66, 66, 65, 64, 64, 63, 62, 62, 61, 60, 60, 59, 58, 58, 57, 56, 56, 55, 55, 54, 53, 53, 52, 51, 51, 50, 50, 49, 48, 48, 47, 47, 46, 46, 45, 44, 44, 43, 43, 42, 42, 41, 40, 40, 39, 39, 38, 38, 37, 37, 36, 36, 35, 35, 34, 33, 33, 32, 32, 31, 31, 31, 30, 30, 29, 29, 28, 28, 27, 27, 26, 26, 25, 25, 24, 24, 24, 23, 23, 22, 22, 21, 21, 21, 20, 20, 19, 19, 19, 18, 18, 18, 17, 17, 16, 16, 16, 15, 15, 15, 14, 14, 14};

//void initDAC() {
////  Channel 1 Initilization
//  // enable DAC1
//   RCC->APB1ENR1 |= RCC_APB1ENR1_DAC1EN; // RCC ENABLE

//  //Control Register
//   //DAC->CR |= _VAL2FLD(DAC_CR_WAVE1, 0b01); //  DAC channel1 Noise wave generation enabled (pg. 507)
   
//   DAC->CR |= _VAL2FLD(DAC_CR_TEN1, 0b1); // DAC channel1 trigger enable
   
//   DAC->CR |= _VAL2FLD(DAC_CR_TSEL1, 0b010); // : DAC channel1 trigger selection to TIM7 (pg. 492)
  
//   DAC->CR |= _VAL2FLD(DAC_CR_EN1, 0b1); // DAC channel powered on by setting its corresponding ENx bit in the DAC_CR register. (p. 489)
   
//   DAC->CR |= _VAL2FLD(DAC_CR_DMAEN1, 0b1); // Enable DMA

//  /*
//    17.7.1 DAC control register (DAC_CR)
//    DAC->CR |= _VAL2FLD(DAC_CR_WAVE2, 0b01); //  DAC channel2 Noise wave generation enabled (pg. 506)
//    DAC->CR |= _VAL2FLD(DAC_CR_TEN2, 0b0); //
//    DAC->CR |= _VAL2FLD(DAC_CR_EN2, 0b1); // EN2, 1: DAC channel2 enabled
   
    
//    // 17.7.2 DAC software trigger register (DAC_SWTRGR)
//    // Do I need to set software triggers?

//    // STEP 2: Set 12-bit right alignment: 
//    // data for DAC channel1 to be loaded into the DAC_DHR12RD [11:0] bits (stored into the DHR1[11:0] bits)
//    // data for DAC channel2 to be loaded into the DAC_DHR12RD [27:16] bits (stored into the DHR2[11:0] bits)
//    // The DHR1 and DHR2 registers are then loaded into the DAC_DOR1 and DOR2 registers
//    // Data stored in the DAC_DHRx register are automatically transferred to the DAC_DORx register after one APB1 clock cycle,
    
//    // 17.7.9 Dual DAC 12-bit right-aligned data holding register (DAC_DHR12RD)

//    // 17.7.12 DAC channel1 data output register (DAC_DOR1)
//    // 17.7.13 DAC channel2 data output register (DAC_DOR2)

//    STEP 3: SET MODEx[2:0] in DAC_MCR register to 010 for Normal Mode, Disabled buffer, Connected to external pin (pg. 497)
//      IF I USE THE BUFFER, THEN CALLIBRATION CLD BE APPLIED (pg. 498)

//    DAC-->MCR |= _VAL2FLD(DAC_MCR_MODE2, 0b010);
//    DAC-->MCR |= _VAL2FLD(DAC_MCR_MODE1, 0b010);
//    //STEP 4: Dual DAC channel conversion (if available) (pg. 499 - 508)

//    */
//}

//// DAC_CH1 goes to DMA1_Channel3

//void initDMA() {
//	RCC->AHB1ENR |= (RCC_AHB1ENR_DMA1EN);   // Enable DMA 1

//        DMA1_Channel3->CCR &= ~(0xffffffff);

//        // 1. set peripheral addr in DMA_CPARx reg
//        DMA1_Channel3->CPAR = _VAL2FLD(DMA_CPAR_PA, (uint32_t) &(DAC1->DHR8R1)); //DAC outplasement

//        // 2. Set mem addr in DMA_CMARx register
//        DMA1_Channel3->CMAR = _VAL2FLD(DMA_CMAR_MA, (uint32_t) &dacValues); //|=  _VAL2FLD(DMA_CMAR_MA, (uint32_t) &CHAR_ARRAY)); //TODO


//        // 3. Config total number of data to transfer in DMA_CNDTRx reg
//        DMA1_Channel3->CNDTR |= _VAL2FLD(DMA_CNDTR_NDT, 1000);// |= _VAL2FLD(DMA_CNDTR_NDT, CHAR_ARRAY_SIZE); // TODO DOUBLE CHECK THIS, Pg. 315;

//        // 4. config in DMA_CRRx reg:
//        // 4a. channel priority
//        DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PL, 0b10);  // set priority lvl to very high B)

//        // 4b. data transfer direction (DIR = 1)
//        DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_DIR, 0b1); // read from memory, 0b1
       
//        // 4c. circular mode
//            // CLEAR MEM2MEM bit of DMA_CCRx reg
//            DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MEM2MEM, 0b0);
//            DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_CIRC, 0b1); // enable circular mode

//        // 4d. peripheral and memory incremented mode
//        DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MINC, 0b1); 

//        DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PINC, 0b1); 

//        // 4e. peripheral and memory data size
//        DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_MSIZE, 0b00); //TODO: set to 8 for now // data size of DMA transfer in memory 0b01 sets to 16 bits
//        DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_PSIZE, 0b00); // data size of DMA transfer in peripheral, 

//        // 5. activate channel by setting EN bit in DMA_CCRx reg
//        DMA1_CSELR->CSELR |= _VAL2FLD(DMA_CSELR_C3S, 0b0110);
//        DMA1_Channel3->CCR |= _VAL2FLD(DMA_CCR_EN, 0b1);

//        // TODO: trigger DMA by timer  
//}



//void initDMATIM(TIM_TypeDef * TIMx){
  
//  // Set prescaler to give 1 ms time base
//  uint32_t psc_div = (uint32_t) ((SystemCoreClock/1e3));

//  // Set prescaler division factor
//  TIMx->PSC = (psc_div - 1);
//  // Generate an update event to update prescaler value
//  TIMx->EGR |= 1;
//  // Enable counter
//  //TIMx->CR1 |= 1; // Set CEN = 1  
//  TIMx->CR2 |= (TIM_CR2_CCDS); 
//  TIMx->DIER |= (TIM_DIER_UDE); 
//  TIMx->CR1 |= (TIM_CR1_CEN); 
//}

      
///*
//	DMA1_Channel3->CPAR = (uint32_t) &(DAC1->DHR8R1); // Peripheral address that where we put data into

//	DMA1_Channel3->CMAR = (uint32_t) &adcValues;  // Memory address that where we read data from

//	DMA1_Channel3->CNDTR = 65460;  // How many data are there ?

//	DMA1_Channel3->CCR |= (3 << 12);  // high priority


//	DMA1_Channel3->CCR |= (1 << 7);  // Memory increment mode

//	DMA1_Channel3->CCR &= ~(3 << 8);  // Peripheral size = 8 bits

//	// DMA1_Channel3->CCR |= (1 << 5);  // Circular mode

//	DMA1_Channel3->CCR &= ~(3 << 10); // Memory size = 8 bits

//	DMA1_CSELR->CSELR |= (6 << 8);  // Channel 3 => DAC1_Channel1

//	DMA1_Channel3->CCR |= (1 << 0); // Enable channel
//*/






