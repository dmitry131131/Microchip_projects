ldi r16, 0xff
out 0x17, r16

ldi r16, 0x00

next:
    out 0x18, r16
    rjmp next
