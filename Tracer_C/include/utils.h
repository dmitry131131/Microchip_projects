// File with common functions and macro for project
#pragma once

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

// ANA_COMP
void Enable_ANA_Comp();
void Disable_ANA_Comp();
void Clean_ANA_Comp_Flag();

// Timer 0
void Enable_Timer_Interrupt();
void Disable_Timer_Interrupt();
void Clean_Timer_Flag();
void Cleanup_Timer();

// LED
void LED_On();
void LED_Off();