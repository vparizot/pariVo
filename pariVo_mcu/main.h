#ifndef MAIN_H
#define MAIN_H

#include "lib/STM32L432KC.h"

// constants 
#define MCK_FREQ 100000
//#define chipEnable PA11
#define ANALOG_IN1 PA0
#define ANALOG_IN2 PA1
#define ANALOG_IN3 PA2
#define ANALOG_IN4 PA3

#define ANALOG_IN_ADC_CHANNEL1 ADC_PA0
#define ANALOG_IN_ADC_CHANNEL2 ADC_PA1
#define ANALOG_IN_ADC_CHANNEL3 ADC_PA2
#define ANALOG_IN_ADC_CHANNEL4 ADC_PA3

#define printTIM TIM2



// SPI Communication Pins
//#define FPGA_RESET PA11

#endif