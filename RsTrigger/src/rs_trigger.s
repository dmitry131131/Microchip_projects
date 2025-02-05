; Program checks state on pin 3 and if it LOW 
; turn on pin 4
.eqv PINB,  0x16
.eqv DDRB,  0x17
.eqv PORTB, 0x18

start:
; Set up pins
; PB0, PB1, PB2, PB3, PB4 - output
; PB5 - input
ldi r16, 0xf7
out DDRB, r16

; Set PB3 in HIGH and other in LOW
ldi r17, 0x8
out PORTB, r17

; Poling pin 3 waiting for LOW on it
loop:
    in r20, PINB    ; take value from PINB
    andi r20, 0x8   ; mask r18 with 0x8 
    cpi r20, 0x0    ; compare r18 with 0
    breq turn_on    ; if 0 on PB3 turn PB4 on

    ; Set PB3 in HIGH and other in LOW
    ldi r17, 0x8
    out PORTB, r17

    rjmp loop
turn_on:
    ; Set PB3, PB4 in HIGH and other in LOW
    ldi r17, 0x18
    out PORTB, r17

    rjmp loop
