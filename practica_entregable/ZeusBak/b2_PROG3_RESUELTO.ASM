; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "SumarMatrices"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

;---------------------------------------------------------
; Programa 3 – Sumar matrices 3x3 tratadas como vectores
;---------------------------------------------------------
; MATRIZ_A[i] + MATRIZ_B[i] -> MATRIZ_RESULTADO[i]
; Cada iteración llama a la rutina SumaElementos que deposita
; el resultado parcial en la variable temporal MATRIZ_Z
;---------------------------------------------------------

Dimension               equ 9                          ; Número total de elementos (3x3)

AppEntry                LD IX, MATRIZ_A                ; IX apunta al primer elemento de A
                        LD HL, MATRIZ_B                ; HL apunta al primer elemento de B
                        LD DE, MATRIZ_RESULTADO        ; DE apunta a donde guardaremos el resultado
                        LD B, Dimension                ; B = contador de elementos

BucleSuma               CALL SumaElementos             ; Calcula A[i] + B[i]
                        LD A, (MATRIZ_Z)               ; Recuperamos el resultado temporal
                        LD (DE), A                     ; Lo almacenamos en el vector resultado
                        INC IX                         ; Avanzamos al siguiente elemento de A
                        INC HL                         ; Avanzamos al siguiente elemento de B
                        INC DE                         ; Avanzamos al siguiente hueco de RESULTADO
                        DJNZ BucleSuma                 ; Repetimos hasta terminar

Final                   halt                           ; Fin del programa
                        jp Final                       ; Bucle infinito para depuración

;---------------------------------------------------------
; Rutina: SumaElementos
; Entrada: IX = puntero a elemento de MATRIZ_A
;          HL = puntero a elemento de MATRIZ_B
; Salida : MATRIZ_Z contiene la suma
;---------------------------------------------------------
SumaElementos           LD A, (IX)                     ; A = elemento de A
                        LD E, (HL)                     ; E = elemento de B
                        ADD A, E                       ; A = A + B
                        LD (MATRIZ_Z), A               ; Guardamos resultado temporal
                        RET

;--------------------   Datos   --------------------------

MATRIZ_A                defb 1,2,3,4,5,6,7,8,9         ; Valores de ejemplo
MATRIZ_B                defb 9,8,7,6,5,4,3,2,1         ; Valores de ejemplo
MATRIZ_RESULTADO        defs Dimension                 ; Espacio para el resultado
MATRIZ_Z                defb 0                         ; Resultado temporal

; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                        ; The last used byte's address

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

