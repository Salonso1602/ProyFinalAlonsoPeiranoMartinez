;
; ProyMicroAlonsoPeiranoMartinez.asm
;
; Created: 23/11/2021 20:10:57
; Author : gatom
;
.include "./m328pdef.inc"

.ORG 0x0000
	jmp start
.ORG 0x001C 
	jmp		_tmr0_setup
.ORG 0x002A
	jmp randomBit_int

;-------------------------------------------------------------
start:
	;habilito el interrupt constante del adc para usar los bits mas afectados por ruido como generador pseudorandom.
	ldi r16, 0b01000000
	sts ADMUX, r16
	ldi r16, 0b11101111
	sts ADCSRA, r16

	;config para display
    ldi		r16,	0b00111101	
	out		DDRB,	r16			;4 LEDs del shield son salidas
	out		PORTB,	r16			;apago los LEDs
	ldi		r16,	0b00000000	
	out		DDRC,	r16			;3 botones del shield son entradas
	ldi		r16,	0b10010000
	out		DDRD,	r16			;configuro PD.4 y PD.7 como salidas
	cbi		PORTD,	7			;PD.7 a 0, es el reloj serial, inicializo a 0
	cbi		PORTD,	4			;PD.4 a 0, es el reloj del latch, inicializo a 0

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
;-----------------------------------------------------------------
_tmr0_setup:			
		in		r21, SREG
		rjmp	displayUpdate			
_tmr0_int:
_tmr0_out:
		clr		r25					;cuento cuántas veces entré en la rutina.
		out		SREG, r21
	    reti						;retorno de la rutina de interrupción del Timer0
;-------------------------------------------------------------------------------------
displayUpdate:
		updatePrimerDig:
		ldi	r17,0b00010000
		mov	r16,r30
		cbr r16,7
		cbr r16,6
		cbr r16,5
		cbr r16,4
		rjmp sacanum
updatePrimerDigOut:

		updateSegundoDig:
		inc	r25
		ldi	r17,0b00100000
		mov	r16,r30
		cbr r16,0
		cbr r16,1
		cbr r16,2
		cbr r16,3
		lsr r16
		lsr r16
		lsr r16
		lsr r16

		rjmp sacanum
updateSegundoDigOut:

		updateTercerDig:
		inc	r25
		ldi	r17,0b01000000
		mov	r16,r31
		cbr r16,7
		cbr r16,6
		cbr r16,5
		cbr r16,4

		rjmp sacanum
		updateTercerDigOut:

		updateCuartoDig:
		inc	r30
		ldi	r17,0b10000000
		mov	r16,r31
		cbr r16,0
		cbr r16,1
		cbr r16,2
		cbr r16,3
		lsr r16
		lsr r16
		lsr r16
		lsr r16

		rjmp sacanum
		updateCuartoDigOut:
		rjmp	_tmr0_int
		
;-------------------------------------------------------------------------------------
; La rutina sacanum, envía lo que hay en r16 y r17 al display de 7 segmentos
; r16 - contiene los LEDs a prender/apagar 0 - prende, 1 - apaga
; r17 - contiene el dígito: r17 = 1000xxxx 0100xxxx 0010xxxx 0001xxxx del dígito menos al más significativo.
sacanum: 
	rjmp	translateBinaryr16
traducido:
	rjmp	dato_serie
	primerDatoOut:
	mov		r16, r17
	rjmp	dato_serie
	segundoDatoOut:
	sbi		PORTD, 4		;PD.4 a 1, es LCH el reloj del latch
	cbi		PORTD, 4		;PD.4 a 0,

	cpi		r25,0
	breq	updatePrimerDigOut
	cpi		r25,1
	breq	updateSegundoDigOut
	cpi		r25,2
	breq	updateTercerDigOut
	rjmp    updateCuartoDigOut

dato_serie:
	ldi		r18, 0x08		;lo utilizo para contar 8 (8 bits)
loop_dato1:
	cbi		PORTD, 7		;SCLK = 0 reloj en 0
	lsr		r16				;roto a la derecha r16 y el bit 0 se pone en el C
	brcs	loop_dato2		;salta si C=1
	cbi		PORTB, 0		;SD = 0 escribo un 0 
	rjmp	loop_dato3
loop_dato2:
	sbi		PORTB, 0		;SD = 1 escribo un 1
loop_dato3:
	sbi		PORTD, 7		;SCLK = 1 reloj en 1
	dec		r18
	brne	loop_dato1		;cuando r17 llega a 0 corta y vuelve
chkrDatoOut:
	cpi r23,0
	brne	chkr2
	inc	r23
	rjmp	primerDatoOut
chkr2:
	clr r23
	rjmp	segundoDatoOut

translateBinaryR16:

	cpi r16,1
	breq unoDisplay
	cpi r16,2
	breq dosDisplay
	cpi r16,3
	breq tresDisplay
	cpi r16,4
	breq cuatroDisplay
	cpi r16,5
	breq cincoDisplay
	cpi r16,6
	breq seisDisplay
	cpi r16,7
	breq sieteDisplay
	cpi r16,8
	breq ochoDisplay
	cpi r16,9
	breq nueveDisplay
	cpi r16,10
	breq aDisplay
	cpi r16,11
	breq bDisplay
	cpi r16,12
	breq cDisplay
	cpi r16,13
	breq dDisplay
	cpi r16,14
	breq eDisplay
	cpi r16,15
	breq fDisplay

	ldi	r16,0b00000011
			rjmp traducido


		unoDisplay:
			ldi	r16,0b10011111
			rjmp traducido
		dosDisplay:
			ldi	r16,0b00100101
			rjmp traducido
		tresDisplay:
			ldi	r16,0b00001101
			rjmp traducido
		cuatroDisplay:
			ldi	r16,0b10011001
			rjmp traducido
		cincoDisplay:
			ldi	r16,0b01001001
			rjmp traducido
		seisDisplay:
			ldi	r16,0b01000001
			rjmp traducido
		sieteDisplay:
			ldi	r16,0b00011111
			rjmp traducido
		ochoDisplay:
			ldi	r16,0b00000001
			rjmp traducido
		nueveDisplay:
			ldi	r16,0b00011001
			rjmp traducido
		aDisplay:
			ldi r16,0b00010001
			rjmp traducido
		bDisplay:
			ldi r16,0b11000001
			rjmp traducido
		cDisplay:
			ldi r16,0b01100011
			rjmp traducido
		dDisplay:
			ldi r16,0b10000101
			rjmp traducido
		eDisplay:
			ldi r16,0b01100001
			rjmp traducido
		fDisplay:
			ldi r16,0b01110001
			rjmp traducido

cargarEnRam:

	mov	r16,r18
	mov r30,r16
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

sumaEnDisplay:
	cbr r23,8
	cbr r23,4
	cbr r23,2
	cbr r23,1

	add r30,r23
	adc r31,r24

