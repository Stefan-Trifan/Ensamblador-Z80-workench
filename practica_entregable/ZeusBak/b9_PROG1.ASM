; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+



























































; ----------------------------------------------------------------------------------------------------

                        org AppFirst

; ----------------------------------------------------------------------------------------------------

; Definicion de variables
texto_original          defb "THAIS HABET NIGROS NIVEOS LAECANIA DENTES"
texto_cifrado           defs 43                 ; Contiene los mismos caracteres que TextoOrifinal
texto_descifrado        defs 43                 ; Ídem.
long_texto              defb 43

mes_a                   defb 4                  ; Mes de nacimiento persona A
mes_b                   defb 6                  ; Mes de nacimiento persona A
roman_key               defb 0

; ----------------------------------------------------------------------------------------------------

; Calculamos la clave RomanKey
AppEntry:
        LD A, (mes_a)           ;
        LD D, A                 ;                               Movemos a D el mes_a
        LD A, (mes_b)           ;
        ADD A, D
        SRL A                   ;                               Divide entre 2 lo que hay en el acumulador
        LD (roman_key), A       ;                               Guardamos la clave de cifrado en su variable

; Preparamos las variables antes de empezar el bucle
        LD HL, texto_original   ; *HL = &texto_original         Guardamos en HL la direccion de memoria donde empieza texto_original
        LD DE, texto_cifrado    ; *DE = &texto_cifrado          Guardamos en DE la direccion de memoria donde empieza texto_cifrado
        LD A, (long_texto)
        LD B, A                 ; B = long_texto                Lo usaremos como iterador en el bucle

; Ciframos caracter a caracter con la clave. Guardamos el texto cifrado en texto_cifrado
bucle_cifrado:
        LD A, (HL)
        LD C, A                 ; Cargamos en D el caracter actual. Primero tiene que pasar por A
        LD A, (roman_key)       ; Cargamos en A la clave de cifrado
        ADD C                   ; Sumamos roman_key + caracter actual dentro de A
        LD (DE), A              ; Cargamos la letra cifrada en texto_cifrado
        INC HL                  ; p_texto_original++
        INC DE                  ; p_texto_cifrado++
        DJNZ bucle_cifrado      ; Repetimos el bucle, B--

; Preparamos las variables antes de empezar el bucle de descifrado
        LD HL, texto_cifrado    ; *HL = &texto_cifrado         Guardamos en HL la direccion de memoria donde empieza texto_cifrado
        LD DE, texto_descifrado ; *DE = &texto_descifrado      Guardamos en DE la direccion de memoria donde empieza texto_descifrado
        LD A, (long_texto)
        LD B, A                 ; B = long_texto                Lo usaremos como iterador en el bucle

; Desciframos caracter a caracter con la clave. Guardamos el texto cifrado en texto_descifrado
bucle_descifrado:
        LD A, (roman_key)
        LD C, A
        LD A, (HL)
        SUB C

        LD (DE), A              ; Cargamos la letra descifrada en texto_descifrado
        INC HL                  ; p_texto_cifrado++
        INC DE                  ; p_texto_descifrado++
        DJNZ bucle_descifrado      ; Repetimos el bucle, B--


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


