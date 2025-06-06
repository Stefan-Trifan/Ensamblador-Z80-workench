AppFilename             equ "SumaMatrices"             ; Nombre del archivo

AppFirst                equ $8000                      ; Memoria inicial
                        zeusemulate "48K","ULA+"       ; Emulador 48K ULA+

                        org AppFirst                   ; Comienzo del c�digo

cadena          defb "holasita"
invertida       defs 8

AppEntry:
    LD B, 4           ; Tama�o de la cadena
    LD HL, cadena     ; HL apunta a la cadena original

cargar:
    LD A, (HL)
    PUSH AF           ; Guardamos el car�cter en la pila
    INC HL
    DJNZ cargar

    LD B, 4
    LD HL, invertida  ; HL apunta al lugar donde guardaremos la cadena invertida

descargar:
    POP AF
    LD (HL), A        ; Guardamos el car�cter sacado
    INC HL
    DJNZ descargar

    HALT




; -------------------- Fin del c�digo -----------------------

AppLast                 equ *-1                        ; �ltima direcci�n usada

                        profile AppFirst, AppLast-AppFirst+1

Zeus_PC                 equ AppEntry                   ; Punto de entrada
Zeus_SP                 equ $FF40                      ; Puntero de pila

                        output_szx AppFilename+".szx",$0000,AppEntry
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry

