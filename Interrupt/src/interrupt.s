; Program turn on LED on pin 4 after interrupt INT0
.eqv PINB,  0x16
.eqv DDRB,  0x17
.eqv PORTB, 0x18
.eqv SREG,  0x3f
.eqv MCUCR, 0x35
.eqv GIMSK, 0x3b
.eqv GIFR,  0x3a
.eqv PCMSK, 0x15

rjmp RESET      ; Reset Handler
rjmp EXT_INT0   ; IRQ0 Handler
rjmp PCINT0     ; PCINT0 Handler
rjmp TIM0_OVF   ; Timer0 Overflow Handler
rjmp EE_RDY     ; EEPROM Ready Handler
rjmp ANA_COMP   ; Analog Comparator Handler
rjmp TIM0_COMPA ; Timer0 CompareA Handler
rjmp TIM0_COMPB ; Timer0 CompareB Handler
rjmp WATCHDOG   ; Watchdog Interrupt Handler
rjmp ADC        ; ADC Conversion Handler

start:
RESET:
    ; INT0 configuration
    ; To configure INT0 change MCUCR and set pin INT0 to output
    ; Set 10 to ISC01 abd ISC00 (MCUCR)
    in r16, MCUCR   ; get value from MCUCR
    ori r16, 0x2    ; add 10 to ISC01 and ISC00
    out MCUCR, r16  ; put new MCUCR value 
    ; Set 1 to GIMSK to INT0
    ldi r16, 0x40
    out GIMSK, r16  ; put new GIMSK value
    
    ; Configure port B as output and PB0 and PB1 to input
    ldi r16, 0xfc
    out DDRB, r16   ; set up all port B
    ldi r16, 0x3
    out PORTB, r16  ; set all port B low level and PB0 abd PB1 HIGH level

    ldi r17, 0x00   ; status register
    ; turn interrupts on
    sei 

main:
    rjmp main

; INT0 interrupt handler
EXT_INT0:
    push r16        ; save R16 in stack
    in r16, SREG    ; store SREG in R16
    push r16        ; save SREG in stack

    cpi r17, 0x3
    breq _IF_ZERO_
    ldi r17, 0x3    ; If 1 set output to 0
    out PORTB, r17
    rjmp skip       ; jump to end of function

_IF_ZERO_:          ; If 0 set output to 1 except PB1(INT0)
    ldi r17, 0xff
    out PORTB, r17
skip:

    rcall long_sleep
    ldi r16, 0x40   ; set INTF0 to 0 (set 1 to INTF0)
    out GIFR, r16

    pop r16         ; restore SREG 
    out SREG, r16   
    pop r16         ; restore R16 from stack
    reti

; Micro sleep
; Loop of 256 increments
sleep:
    push r21
    ldi r21, 0x0
sleep_loop:
    inc r21
    push r21
    pop r21
    push r21
    pop r21
    push r21
    pop r21
    cpi r21, 0xff
    brne sleep_loop

    pop r21
    ret

; Long sleep
long_sleep:
    push r22
    ldi r22, 0x0
long_sleep_loop:
    inc r22
    rcall sleep

    cpi r22, 0x2f
    brne long_sleep_loop

    pop r22
    ret

PCINT0:
TIM0_OVF:
EE_RDY:
ANA_COMP:
TIM0_COMPA:
TIM0_COMPB:
WATCHDOG:
ADC:
    reti
