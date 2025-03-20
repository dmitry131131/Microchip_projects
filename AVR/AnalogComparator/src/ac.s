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
.eqv TIFR0,  0x38
.eqv ACSR,   0x08
.eqv DIDR0,  0x14

start:
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

RESET:
    ; Configure port B as output and PB0 and PB1 to input
    ldi r16, 0x10
    out DDRB, r16   ; set up all port B
    ldi r16, 0x0
    out PORTB, r16  ; set all port B low level and PB0 abd PB1 HIGH level

    ; Configure TCCR0 register
    ldi r16, 0x2        ; CTC mode (WGM01=1, WGM00=0)
    out TCCR0A, r16
    ldi r16, 0x5        ; division 1024 (CS02=1, CS01=0, CS00=1)
    out TCCR0B, r16
    ; Configure top value
    ldi r16, 0xff       ; load top value
    out OCR0A, r16
    ; Disable interrupt
    ldi r16, 0x0        ; Disable CTC interrupt
    out TIMSK0, r16

    ; ANA_COMP configuration
    ldi r16, 0x0a   ;01001011
    out ACSR, r16

    ; Disable Digital buffer for PB0 and PB1
    ;ldi r16, 0x3
    ;out DIDR0, r16
    
    sei
    ; main waiting loop
main:;<----------|
    rjmp main;---|

; ANA_COMP interrupt handler
ANA_COMP:
    push r16        ; save R16 in stack
    in r16, SREG    ; store SREG in R16
    push r16        ; save SREG in stack

    ; Ban interrupt ANA_COMP
    in r16, ACSR
    andi r16, 0xf7
    out ACSR, r16

    ; Enable timer interrupt
    ldi r16, 0x4        ; Enable CTC interrupt
    out TIMSK0, r16
    ; Set Timer Interrupt flag to 0
    ldi r16, 0x4
    out TIFR0, r16
    ; Set Timer 0 to 0
    ldi r16, 0x0
    out TCNT0, r16 

    sei

    ldi r17, 0x10   ; start blinking LED
    out PORTB, r17
    
; Wait setting r16 to 0x3 by Timer interrupt
waiting_loop:;<-------------
    cpi r17, 0x10;         |
    breq waiting_loop;------

    out PORTB, r17

    cli

    ; ANA_COMP configuration and set of interrupt state
    ldi r16, 0x1a   ;01011011
    out ACSR, r16

    ; Disable timer interrupt
    ldi r16, 0x0        ; Enable CTC interrupt
    out TIMSK0, r16

    pop r16         ; restore SREG 
    out SREG, r16   
    pop r16         ; restore R16 from stack
    reti

TIM0_COMPA:
    ldi r17, 0x0    ; turn off LED
    reti

EXT_INT0:
PCINT0:
TIM0_OVF:
EE_RDY:
TIM0_COMPB:
WATCHDOG:
ADC:
    reti
