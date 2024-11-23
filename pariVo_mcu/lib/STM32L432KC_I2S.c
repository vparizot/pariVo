// STM32L432KC_I2S.c
// Source code for SPI functions

#include "STM32L432KC.h"
#include "STM32L432KC_I2S.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_RCC.h"

/* Enables the I2S capabilities of the SAI peripheral 
 * lsb- justified, 24-bit
 * Refer to the datasheet for more low-level details. */ 
// USE SAI_A
void initI2S() {
/*
|            DS = 32-bits         |
|    16-bit L    |    16-bit R    | <-- Frame
|     slot 0     |     slot 1     |
*/
// Disable audio block to configure registers
SAI1->ACR1 &= ~SAI_CR1_SAIEN;

// SET DMA (pg. 1394) to perform read/write from.to SAI_xDR register
// 1. Config SAI and FIFO threshold vlvs to specify when DMA request will be launched
// 2. Config SAI DMA Channel
// 3. Enable DMA - Set DMAEN bit in SAI_xCR1 Register
// 4. Enable SAI interface

// CONFIGURE SAI_ACR1
// 2ish. Do I Set OUTDRIV?
// 3. Turn off Mono Mode (set MONO to 0)
SAI1_Block_A->CR1 |= _VAL2FLD(SAI_ACR_MONO, 0b0); // set to stereo

// 4. CKSTR: Set Clock Strobing Edge, set to 1 s.t. signals recieved by SAI are sampled on SCK rising edge
SAI1->ACR1 |= _VAL2FLD(SAI_xACR1_CKSTR, 0b1);

// 5. PRTCFG: Set to 00 for free protocol (allows us to use i2s) (set while audio block disabled)
SAI1->ACR1 |= _VAL2FLD(SAI_xACR1_PRTCFG, 0b00);

// 6. LSBFIRST: Set to 1 to transfer with LSB first
SAI1->ACR1 |= _VAL2FLD(SAI_xACR1_LSBFIRST, 0b1);

// 7. DS[2:0] set Data size to 111 for 32bits
SAI1->ACR1 |= _VAL2FLD(SAI_xACR1_DS, 0b111);

// 8. MODE: set to 11 for Slave Reciever (config while SAIx audio block off)
SAI1->ACR1 |= _VAL2FLD(SAI_xACR1_MODE, 0b11); // set to slave Reciever

// 9. DMAEN DMA Enable, set to 1 to enable DMA (MUST BE AFTER MODE BITS SET TO RECIEVER)
SAI1->ACR1 |= _VAL2FLD(SAI_xACR1_DMAEN, 0b1); // enable DMA


// CONFIGURE SAI_ACR2
// 1. COMP: Set to 00: no companding algorithm
SAI->ACR2 |= _VAL2FLD(SAI_xACR2_COMP, 0b00);

// 2. FTH: FIFO Threshold - set threshold (pg. 1372)
// SAI->ACR2 |= _VAL2FLD(SAI_ACR1_FTH, 0b00); // TO DO: WHAT SHLD I SET THIS TOOOOO????

// CONFIGURE SAI_AFRCR
// 1. FSOFF: FRAME SYNCHRONIZATION OFFSET
// SAI->AFRCR |= _VAL2FLD(SAI_AFRCR_FSOFF, 0b);

// 2. FSPOL: FRAME SYNC POLARITY, set to 1 (rising edge)
SAI->AFRCR |= _VAL2FLD(SAI_xAFRCR_FSPOL, 0b1);

// 3. FSDEF: Frame Sync Definition: set to 1 for I2S
SAI->AFRCR |= _VAL2FLD(SAI_xAFRCR_FSDEF, 0b1);

// 4. FSALL: Frame sync active level length: specify length in number of bit clock 
SAI->AFRCR |= _VAL2FLD(SAI_xAFRCR_FSALL, 0b1); // set to 16, (SCK) + 1 (FSALL[6:0] + 1) 

// 5. FRL: Frame Length = FRL + 1, set to 16-bit (i think)
SAI->AFRCR |= _VAL2FLD(SAI_xAFRCR_FRL, 0b1111); 

// CONFIGURE SAI_ASLOTR
// 1. SLOTEN[15:0] aligns with slot enable for 16 slots, 0 - inactive, 1 - active
SAI->ASLOTR |= _VAL2FLD(SAI_xASLOTR_SLOTEN, 0b0000000000000011);

// 2. NBSLOT[3:0] number of slots in audio frame - Set to 0b10 = 2 (i think)
SAI->ASLOTR |= _VAL2FLD(SAI_xASLOTR_NBSLOT, 0b10);

// 3. SLOTSZ - slot size - (pg. 1377) set to 0b01 (16-bit)
SAI->ASLOTR |= _VAL2FLD(SAI_xASLOTR_SLOTSZ, 0b01);

// 4. FBOFF - first bit offset, set to 0b1000 = 8 to get 24 bits

// CONFIGURE SAI_ASR
// 1. FREQ - FIFO Request - 1: FIFO request to read or write the SAI_xDR
// CONFIGUE SAI_ADR (aka data)
// 1. DATA[31:0] a read empties FIFO, a write loads FIFO

// ENABLE AUDIO BLOCK
// 9. SAIEN: Audio Block Enable (pg.1366) - Set to 0 then 1 to enable audio block (config when audio block disables)
SAI->ACR1 |= _VAL2FLD(SAI_xACR1_SAIEN, 0b1); // enable audio block

}