;***********************************************
;Sistema Operacional para o SDM_Z80
;Fabrício de Lima Ribeiro
;20/10/2003
;***********************************************

stack		.equ	$ffff

disp_cmd	.equ	00h
disp_char	.equ	01h

;------------------------------------
; Buffers
;------------------------------------
		.org	$fff0
centena:	.ds	1
dezena:		.ds	1
unidade:	.ds	1


;------------------------------------
; Principal
;------------------------------------
		.org 0000h
		di
		jp inicio


inicio:		.org 0100h
		ld sp,stack
		call ini_disp

		ld hl,centena
		ld a,31h
		ld (hl),a

		ld hl,dezena
		ld a,32h
		ld (hl),a

		ld hl,unidade
		ld a,33h
		ld (hl),a

		ld hl,0000h
		ld a,00h

		ld hl,centena
		ld a,(hl)
		call car_disp

		ld hl,dezena
		ld a,(hl)
		call car_disp

		ld hl,unidade
		ld a,(hl)
		call car_disp

loop:		jp loop

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

		.end	

