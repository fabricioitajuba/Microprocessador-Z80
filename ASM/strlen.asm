;****************************************************
; Z80
; Conta o número de bytes de uma string
; Eng. Fabrício de Lima Ribeiro
; 05/08/2026
; Status: OK
;****************************************************

stack		.equ	$ff00

NULL		.equ	0

disp_cmd	.equ	00h
disp_char	.equ	01h


;------------------------------------
; Principal
;------------------------------------
		.org 0000h
		di
		jp inicio

inicio:		.org 0100h
		ld sp,stack
		call ini_disp

		ld hl,msg1
		call strlen
		add a,'0'
		call car_disp
		
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

; -------------------------------------------------
; strlen - conta o número de bytes de uma string
; HL - Endereço base da string
; A  - retorna o número de bytes da string
; -------------------------------------------------
strlen:		ld b,00h
strlen_loop:	ld a,(hl)
		cp 0
		jp z,strlen_end
		inc b
		inc hl
		jp strlen_loop
strlen_end:	ld a,b
		ret

;------------------------------------
; Área de mensagens
;------------------------------------
msg1:    	.db 	"Z80_TASM",NULL

		.end	

