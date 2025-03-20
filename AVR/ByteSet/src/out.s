; Program sets all port B pins into 1
.eqv DDRB, 0x17
.eqv PORTB, 0x18
; Set port B to output
ldi r16, 0xff
out DDRB, r16

; set r16 value to PORTB
next:
    out PORTB, r16
    rjmp next
