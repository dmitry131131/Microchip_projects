; Program blink LED on 4 pin by INT0 interrupt with timer 0 delay
.eqv PINB,   0x16
.eqv DDRB,   0x17
.eqv PORTB,  0x18
.eqv SREG,   0x3f
.eqv MCUCR,  0x35
.eqv GIMSK,  0x3b
.eqv GIFR,   0x3a
.eqv PCMSK,  0x15
.eqv TCCR0A, 0x2f
.eqv TCCR0B, 0x33
.eqv OCR0A,  0x36
.eqv TIMSK0, 0x39
.eqv TCNT0,  0x32
.eqv ACSR,   0x08
.eqv DIDR0,  0x14

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
    ; Configure port B as output and PB0 and PB1 to input
    ldi r16, 0xfc
    out DDRB, r16   ; set up all port B
    ldi r16, 0x0
    out PORTB, r16  ; set all port B low level and PB0 abd PB1 HIGH level

    ldi r17, 0x0

    ; ANA_COMP configuration
    ldi r16, 0x00   ;01001011
    out ACSR, r16

    ; Disable Digital buffer for PB0 and PB1
    ldi r16, 0x3
    out DIDR0, r16
    
    sei
    ; main waiting loop
main:;<----------|
    in r16, ACSR
    andi r16, 0x20
    cpi r16, 0
    breq zero_1

    ldi r16, 0xfc
    out PORTB, r16

    rjmp skip_1
zero_1:
    ldi r16, 0
    out PORTB, r16

skip_1:
    rjmp main;---|

; ANA_COMP interrupt handler
ANA_COMP:
    push r16        ; save R16 in stack
    in r16, SREG    ; store SREG in R16
    push r16        ; save SREG in stack

    cpi r17, 0      ; compare status with 0
    breq zero 

    ldi r17, 0x0   ; set output in 1
    out PORTB, r17
    rjmp skip

zero:
    ldi r17, 0xfc
    out PORTB, r17
skip:

    ; ANA_COMP configuration and set of interrupt state
    ldi r16, 0x1b   ;01011011
    out ACSR, r16

    pop r16         ; restore SREG 
    out SREG, r16   
    pop r16         ; restore R16 from stack
    reti

TIM0_COMPA:
EXT_INT0:
PCINT0:
TIM0_OVF:
EE_RDY:
TIM0_COMPB:
WATCHDOG:
ADC:
    reti
