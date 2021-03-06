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
	call delay ;le da tiempo al random int de generar un numero significativamente distinto del anterior
	call cargarEnRam
	nop
    rjmp main

randomBit_int: ;se genera numero random en r17

	in r20, SREG ;guardo las flags por las dudas.
	lds r16, ADCL ;cargo los 8 bits menos sinigficativos
	
	sbrc r16,0
	inc r17
	lsl r17	;muevo los bits a la izquierda

	lds r16, ADCH ;cargo adch para que se pueda actualizar el adc, no lo uso.

	out SREG, r20
	reti

cargarEnRam:

	mov	r16,r18
	st	Y+, r16

	ret

codificarHemming:
	mov r18,r17
	clr r22

	Chckr1:
		sbrc r18,3
		inc r22
		sbrc r18,5
		inc r22
		sbrc r18,7
		inc r22
		cpi r22,0
		breq clrbit1
		cpi r22,2
		breq clrbit1
		sbr r18,1
		clr r22
		rjmp Chckr2

		clrbit1:
		cbr r18,1
		clr r22
		rjmp Chckr2

	Chckr2:
		sbrc r18,3
		inc r22
		sbrc r18,6
		inc r22
		sbrc r18,7
		inc r22
		cpi r22,0
		breq clrbit2
		cpi r22,2
		breq clrbit2
		sbr r18,2
		clr r22
		rjmp Chckr4

		clrbit2:
		cbr r18,2
		clr r22
		rjmp Chckr4

	Chckr4:
		sbrc r18,5
		inc r22
		sbrc r18,6
		inc r22
		sbrc r18,7
		inc r22
		cpi r22,0
		breq clrbit4
		cpi r22,2
		breq clrbit4
		sbr r18,4
		cbr r18,7
ret

		clrbit4:
		cbr r18,4
		cbr r18,7
ret

delay:
	inc r20
	brne delay
	delay2:
		inc r21
		brne delay2
	clr r21
	clr r20
	ret

decohamming1:
		sbrc	r18,1
		inc		r22
		sbrc	r18,3
		inc		r22
		sbrc	r18,5
		inc		r22
		sbrc	r18,7
		inc		r22
		cpi		r22,1
		breq	fila1
		cpi		r22,3
		breq	fila1
		clr		r22

decohamming2:
		sbrc	r18,2
		inc		r22
		sbrc	r18,3
		inc		r22
		sbrc	r18,6
		inc		r22
		sbrc	r18,7
		cpi		r22,1
		breq	fila2
		cpi		r22,3
		breq	fila2
		clr		r22

decohamming3:
		sbrc	r18,4
		inc		r22
		sbrc	r18,5
		inc		r22
		sbrc	r18,6
		inc		r22
		sbrc	r18,7
		cpi		r22,1
		breq	fila3
		cpi		r22,3
		breq	fila3
		clr		r22

fila1:
		sbr		r23,1
		rjmp	decohamming2

fila2:
		sbr		r23,2
		rjmp	decohamming3

fila3:
		sbr		r23,3
		rjmp	arreglar

arreglar:
		sbrc	r23,1
		inc		r24
		inc		r25
		inc		r26
		sbrc	r23,2
		inc		r25
		inc		r27
		inc		r24
		sbrc	r23,3
		inc		r25
		inc		r26
		inc		r27
		cpi		r25,3
		breq	corregir7
		cpi		r24,2
		breq	corregir3
		cpi		r26,2
		breq	corregir5
		cpi		r27,2
		breq	corregir6

corregir3:
		sbi		r31,0b00001000
		eor		r18,r31
		clr		r31

corregir5:
		sbi		r31,0b00100000
		eor		r18,r31
		clr		r31

corregir6:
		sbi		r31,0b01000000
		eor		r18,r31
		clr		r31

corregir7:
		sbi		r31,0b10000000
		eor		r18,r31
		clr		r31




