;****************************************************
; Z80
; Imprime uma string
; Eng. Fabrício de Lima Ribeiro
; 06/08/2026
; Status: OK
;****************************************************

stack		.equ	$ff00

NULL		.equ	0

disp_cmd	.equ	$00
disp_char	.equ	$01

;------------------------------------
; Principal
;------------------------------------
		.org $0000
		di
		jp inicio

inicio:		.org $0100
		ld sp,stack
		call ini_disp

		ld hl,msg1
		call strprint
		
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

;------------------------------------
; Envia uma string para o display
; HL - endereço base da string
;------------------------------------
strprint:	ld a,(hl)
		cp 0
		jp z,strprint_end
		call car_disp
		inc hl
		jp strprint
strprint_end:	ret

;------------------------------------
; Área de mensagens
;------------------------------------
msg1:    	.db 	"Z80_TASM",NULL

		.end	

