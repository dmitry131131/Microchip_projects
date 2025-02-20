#define F_CPU 1000000UL

#include "utils.h"

// ANA_COMP
void Enable_ANA_Comp() {
    ACSR |= (1 << ACIE);
}

void Disable_ANA_Comp() {
    ACSR &= ~(1 << ACIE); 
}

void Clean_ANA_Comp_Flag() {
    ACSR |= (1 << ACI);
}

//Timer 0
void Enable_Timer_Interrupt() {
    TIMSK0 |= (1 << OCIE0A);
}

void Disable_Timer_Interrupt() {
    TIMSK0 &= ~(1 << OCIE0A);
}

void Clean_Timer_Flag() {
    TIFR0 |= (1 << OCF0A);
}

void Cleanup_Timer() {
    TCNT0 = 0x0;
}

// LED
void LED_On() {
    PORTB |= (1 << PB4);
}

void LED_Off() {
    PORTB &= ~(1 << PB4);
}