; Simple CP/M Z80 "Hello, World!"
; Assemble using a Z80 assembler (like M80 or Z80ASM)
; status: não funcionou

        ORG     100H    ; CP/M transient program area (TPA) entry point

BEGIN:  LD      DE, MSG ; Point DE to message string
        LD      C, 9    ; BDOS function 9: print string
        CALL    5       ; Call CP/M BDOS entry point
        RET             ; Return to CP/M console

MSG:    DEFB    'Hello, CP/M World!', 0DH, 0AH, '$'

        END

