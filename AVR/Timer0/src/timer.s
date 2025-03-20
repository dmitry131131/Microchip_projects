; Program blink LED on 4 pin bt timer 0
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
    ; Configure PORT B as output
    ldi r16, 0xff
    out DDRB, r16
    ldi r16, 0x0    ; set low level
    out PORTB, r16

    ; Set state register
    ldi r17, 0x0

    ; Configure TCCR0 register
    ldi r16, 0x2        ; CTC mode (WGM01=1, WGM00=0)
    out TCCR0A, r16
    ldi r16, 0x5        ; division 1024 (CS02=1, CS01=0, CS00=1)
    out TCCR0B, r16
    ; Configure top value
    ldi r16, 0xff       ; load top value
    out OCR0A, r16
    ; Enable interrupt
    ldi r16, 0x4        ; Enable CTC interrupt
    out TIMSK0, r16

    sei

main:
    rjmp main

TIM0_COMPA:
    push r16        ; save R16 in stack
    in r16, SREG    ; store SREG in R16
    push r16        ; save SREG in stack

    ldi r16, 0xff   ; Change r17 value not(r17)
    eor r17, r16    ; XOR
    out PORTB, r17
    
    pop r16         ; restore SREG 
    out SREG, r16   
    pop r16         ; restore R16 from stack
    reti

EXT_INT0:
PCINT0:
TIM0_OVF:
EE_RDY:
ANA_COMP:
TIM0_COMPB:
WATCHDOG:
ADC:
    reti
