; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+

; ----------------------------------------------------------------------------------------------------






























































                        org AppFirst

; ----------------------------------------------------------------------------------------------------

; Definicion de variables
texto_original          defb "BEATI HISPANI QUIBUS BIBERE VIVERE EST"
texto_cifrado           defs 38                 ; Contiene los mismos caracteres que TextoOrifinal
texto_descifrado        defs 38                 ; Ídem.
long_texto              defb 38

mes_a                   defb 4                  ; Mes de nacimiento persona A
mes_b                   defb 8                  ; Mes de nacimiento persona A
roman_key               defb 0

; ---------------------------------------------------------------------------------------------------------

; Calculamos la clave RomanKey
AppEntry:
        LD A, (mes_a)           ;
        LD D, A                 ;                               Movemos a D el mes_a
        LD A, (mes_b)           ;
        ADD A, D
        SRL A                   ;                               Divide entre 2 lo que hay en el acumulador
        LD (roman_key), A       ;                               Guardamos la clave de cifrado en su variable

; Paso de parámetros por la pila para cifrar
        LD HL, texto_original   ; *HL = &texto_original
        PUSH HL                 ;                               Envíamos texto_original al stack
        LD DE, texto_cifrado    ; *DE = &texto_cifrado
        PUSH DE                 ;                               Envíamos el texto_cifrado al stack
        LD A, (long_texto)      ; A = long_texto
        PUSH AF                 ;                               Envíamos la longitud del texto al stack
        LD A, (roman_key)       ; A = roman_key
        PUSH AF                 ;                               Enviamos la clave de cifrado al stack
        LD A, 'C'               ; A = 'C'
        PUSH AF                 ;                               Enviamos el tipo de operacion al stack
        CALL CifradoRomano      ;                               Llamamos a la rutina

; Paso de parámetros por la pila para descifrar
        LD HL, texto_cifrado   ; *HL = &texto_cifrado
        PUSH HL                 ;                               Envíamos texto_original al stack
        LD DE, texto_descifrado    ; *DE = &texto_descifrado
        PUSH DE                 ;                               Envíamos el texto_cifrado al stack
        LD A, (long_texto)      ; A = long_texto
        PUSH AF                 ;                               Envíamos la longitud del texto al stack
        LD A, (roman_key)       ; A = roman_key
        PUSH AF                 ;                               Enviamos la clave de cifrado al stack
        LD A, 'C'               ; A = 'C'
        PUSH AF                 ;                               Enviamos el tipo de operacion al stack
        CALL CifradoRomano      ;                               Llamamos a la rutina

; Rutina CifradoRomano
CifradoRomano:
        POP AF                  ; A = 'C'                       Recuperamos el codigo de operacion ('C')
        CP 'C'                  ; if(A = 'C') Z = 1 ? Z = 0     Comprobamos si el codigo es Cifrado 'C' o Descifrado 'D'
        JP Z, hacer_cifrado     ;                               Si z = 1, ciframos
        CP 'D'
        JP Z, hacer_descifrado  ;                               Si Z = 0, desciframos
        LD A, 0                 ;                               Si la letra no coincide devolvemos 0 en A
        RET

hacer_cifrado:
        POP AF                  ;                               Recuperamos en A la clave de cifrado
        LD C, A                 ; C = roman_key                 Guradamos la clave en C
        POP AF                  ;                               Recuperos el numero de caracteres
        LD B, A                 ; B = long_texto
        POP DE                  ; *DE = &texto_cifrado
        POP HL                  ; *HL = &texto_original
bucle_cifrado:
        LD A, (HL)
        ADD C
        LD (DE), A              ; *DE = A                               Cargamos la letra cifrada en su posicion texto_cifrado
        INC HL                  ; p_texto_original++
        INC DE                  ; p_texto_cifrado++
        DJNZ bucle_cifrado      ; B--                                   Repetimos el bucle
        LD A, 1
        RET

hacer_descifrado:
        POP AF                  ;                               Recuperamos en A la clave de cifrado
        LD C, A                 ; C = roman_key                 Guradamos la clave en C
        POP AF                  ;                               Recuperos el numero de caracteres
        LD B, A                 ; B = long_texto
        POP DE                  ; *DE = &texto_cifrado
        POP HL                  ; *HL = &texto_original
bucle_descifrado:
        LD A, (HL)              ; A = caracter_actual           Cargamos en A el caracter actual
        SUB C                   ; A = A - C                     Hacemos para calcular el caracter actual descifrado
        LD (DE), A              ; *DE = A                       Cargamos la letra descifrada en texto_descifrado
        INC HL                  ; p_texto_cifrado++
        INC DE                  ; p_texto_descifrado++
        DJNZ bucle_descifrado   ; B--                           Repetimos el bucle
        LD A, 1
        RET

; ----------------------------------------------------------------------------------------------------

Final                   halt
                        jp Final
AppLast                 equ *-1






















































; ----------------------------------------------------------------------------------------------------

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1     ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                            ; Tell the emulator where to start
Zeus_SP                 equ $FF40                               ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry    ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader
