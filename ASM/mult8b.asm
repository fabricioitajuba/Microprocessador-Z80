;***********************************************
;Sistema Operacional para o SDM_Z80
;Fabrício de Lima Ribeiro
;20/10/2003
;***********************************************

disp_cmd	.equ	00h
disp_char	.equ	01h

;------------------------------------
; Buffers
;------------------------------------
		.org 0F000h
stack   	.equ    $	; Stack top

;------------------------------------
; Principal
;------------------------------------
		.org 0000h
		di
		jp inicio


		.org 0100h
inicio:		ld sp,stack
		call ini_disp

		;HL=D*E
		ld d,0ffh
		ld e,0ffh
		call Multiply
		ld a,h
		call outhex
		ld a,l
		call outhex

loopx:		jp loopx

		HALT

;------------------------------------
; Inicializa o display
;------------------------------------
ini_disp:	push af
		ld a,38h
		call com_disp
		ld a,06h
		call com_disp
		ld a,0eh
		call com_disp
		ld a,01h
		call com_disp
		pop af
		ret

;------------------------------------
; Envia comando para o display
;------------------------------------
com_disp:	out (disp_cmd),a
		call atraso_1
		ret

;------------------------------------
; Envia dado para o display
;------------------------------------
car_disp:	out (disp_char),a
		call atraso_1
		ret

;------------------------------------
; Gera um delay para o display
;------------------------------------
atraso_1:	push af
		ld a,02h
dec_1:		dec a
		jp nz,dec_1
		pop af
		ret

;--------------------------------------
;Rotina OUTHEX
;Mostra no display o byte no acumulador
;A = Byte
;DE = Endereço na memória do display
;--------------------------------------
outhex:         push af
		push bc
		ld b,a
		rrca
		rrca
		rrca
		rrca
		and $0f
		add a,$30
		cp $3a
		jp m,outhex_1
		add a,$07
outhex_1:       call car_disp
		ld a,b
		and $0f
		add a,$30
		cp $3a
		jp m,outhex_2
		add a,$07
outhex_2:       call car_disp
		pop bc
		pop af
		ret

;---------------------------------------
;Multiplicação
; this routine performs the operation HL=D*E
;---------------------------------------
Multiply:	ld hl,0		; HL is used to accumulate the result
		ld a,d		; checking one of the factors; returning if it is zero
		or a
		ret z
		ld b,d		; one factor is in B
		ld d,h		; clearing D (H is zero), so DE holds the other factor
MulLoop:	add hl,de	; adding DE to HL exactly B times
		dec b
		jp nz,MulLoop
		ret	

		.END	

