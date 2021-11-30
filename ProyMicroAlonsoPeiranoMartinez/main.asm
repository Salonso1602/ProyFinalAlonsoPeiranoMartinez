;
; ProyMicroAlonsoPeiranoMartinez.asm
;
; Created: 23/11/2021 20:10:57
; Author : gatom
;
.include "./m328pdef.inc"

.ORG 0x0000
	jmp start
.ORG 0x002A
	jmp randomBit_int

;-------------------------------------------------------------
start:
	;habilito el interrupt constante del adc para usar los bits mas afectados por ruido como generador pseudorandom.
	ldi r16, 0b01000000
	sts ADMUX, r16
	ldi r16, 0b11101111
	sts ADCSRA, r16

	clr r16 ;lo dejo limpio para usar en el interrupt del adc.
	ldi r17, 0b00000000 ;aca se van a ir generando los words random

	.DSEG
	secuencia: .byte 512
	.CSEG

	ldi	r28, low(secuencia)
	ldi r29, high(secuencia)

	sei
;-------------------------------------------------------------

; Replace with your application code
main:
    nop
	nop
	nop
	nop
    rjmp main

randomBit_int: ;se genera numero random en r17

	in r20, SREG ;guardo las flags por las dudas.
	clr r16
	lds r16, ADCL ;cargo los 8 bits menos sinigficativos
	
	sbrc r16,0
	inc r17
	lsl r17	;muevo los bits a la izquierda

	out SREG, r20
	reti

cargarEnRam:

	mov	r16,r17
	st	Y, r16
	;inc Y


