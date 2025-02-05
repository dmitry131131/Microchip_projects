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

ldi r19, 0x8    ; State register

; Poling pin 3 waiting for LOW on it
LOW_waiting_loop:
    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    breq HIGH_waiting_loop ; if 0 on PB3 turn PB4 on

    ; Set PB3 in HIGH and other in LOW
    ldi r17, 0x8
    out PORTB, r17

    rjmp LOW_waiting_loop

HIGH_waiting_loop:
    ; Set PB3, PB4 in HIGH and other in LOW
    ldi r17, 0x18
    out PORTB, r17

    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    brne next_LOW_waiting_loop ; if 1 on PB3 goto next LOW waiting loop
    rjmp HIGH_waiting_loop

next_LOW_waiting_loop:
    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    breq next_HIGH_waiting_loop ; if 1 on PB3 goto next HIGH waiting loop

    ; Set PB3, PB4 in HIGH and other in LOW
    ldi r17, 0x18
    out PORTB, r17

    rjmp next_LOW_waiting_loop

next_HIGH_waiting_loop:
    ; Set PB3, PB4 in HIGH and other in LOW
    ldi r17, 0x8
    out PORTB, r17

    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    brne LOW_waiting_loop ; if 1 on PB3 goto next LOW waiting loop

    rjmp next_HIGH_waiting_loop