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
    brne skip_1 ; if 0 on PB3 turn PB4 on

    rcall sleep
    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    breq HIGH_waiting_loop ; if 0 on PB3 turn PB4 on
    skip_1:

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
    breq skip_2 ; if 1 on PB3 goto next LOW waiting loop

    rcall sleep
    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    brne next_LOW_waiting_loop ; if 1 on PB3 goto next LOW waiting loop
    skip_2:

    rjmp HIGH_waiting_loop

next_LOW_waiting_loop:
    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    brne skip_3 ; if 1 on PB3 goto next HIGH waiting loop

    rcall sleep
    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    breq next_HIGH_waiting_loop ; if 1 on PB3 goto next HIGH waiting loop
    skip_3:

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
    breq skip_4 ; if 1 on PB3 goto next LOW waiting loop

    rcall sleep
    in r20, PINB           ; take value from PINB
    andi r20, 0x8          ; mask r20 with 0x8 
    cpi r20, 0x0           ; compare r20 with 0
    brne LOW_waiting_loop ; if 1 on PB3 goto next LOW waiting loop
    skip_4:

    rjmp next_HIGH_waiting_loop

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
