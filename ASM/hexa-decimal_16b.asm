;****************************************************
; Z80
; Conversão de um número em hexadecimal de 16 bits
; em decimal.
; Eng. Fabrício de Lima Ribeiro
; 31/07/2026
; Status: OK
;****************************************************

disp_cmd	.equ	00h
disp_char	.equ	01h

;------------------------------------
; Buffers
;------------------------------------
		.org 0F000h
stack   	.equ    $	; Stack top
conver		.ds	5	; Bufffer da conversão

;------------------------------------
; Principal
;------------------------------------
		.org 0000h
		di
		jp inicio


inicio:		.org 0100h
		ld sp,stack
		call ini_disp

		ld hl,0FFFFh
		ld de,conver
		call Hex16ParaDecimal

		ld hl,conver
		ld a,(hl)
		call car_disp

		ld hl,conver+1
		ld a,(hl)
		call car_disp

		ld hl,conver+2
		ld a,(hl)
		call car_disp

		ld hl,conver+3
		ld a,(hl)
		call car_disp

		ld hl,conver+4
		ld a,(hl)
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

;----------------------------------------------------------------------------
; Rotina: Hex16ParaDecimal
; Descrição: Converte um valor de 16 bits em HL para 5 dígitos ASCII
; Entrada: HL = Número de 16 bits (0000h a FFFFh)
;          DE = Endereço do buffer de memória para salvar o texto (5 bytes)
; Destrói: AF, BC, DE, HL
;----------------------------------------------------------------------------
Hex16ParaDecimal:    	
    		ld bc,-10000		; --- Processa o dígito das dezenas de milhar (10000) ---
    		call ProcessaDigito
    
    		ld bc,-1000		; --- Processa o dígito dos milhares (1000) ---
		call ProcessaDigito
        	
		ld bc,-100		; --- Processa o dígito das centenas (100) ---
    		call ProcessaDigito    
    
		ld bc,-10		; --- Processa o dígito das dezenas (10) ---
		call ProcessaDigito
    
    		ld a,l			; --- O que restou em HL são as unidades (0-9) ---
    		add a,'0'         	; Converte o resto final para caractere ASCII
    		ld (de),a        	; Salva no buffer
    		ret

; --- Sub-rotina interna para contar as subtrações de cada potência ---
ProcessaDigito:	ld a,'0'-1     		; Inicializa o caractere ASCII com '0' - 1
Subtrai:	inc a              	; Incrementa o contador ASCII
    		add hl, bc         	; Subtrai a potência somando o valor negativo
    		jp c,Subtrai    	; Se houve carry (HL >= potência), repete a subtração
    
    		; Se chegou aqui, passou do ponto (HL ficou negativo)
    		ld (de),a        	; Salva o dígito ASCII calculado no buffer
		inc de             	; Avança o ponteiro do buffer de texto
    
    		; Restaura o excesso subtraído em HL
    		ld a,c
    		cpl                 	; Inverte BC para somar de volta o valor positivo
    		ld c,a
    		ld a,b
    		cpl
    		ld b,a
    		inc bc             	; BC agora é o valor positivo original
    		add hl,bc         	; Restaura o saldo correto em HL
    		ret

		.end	

