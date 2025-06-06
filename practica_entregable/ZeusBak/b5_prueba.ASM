; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+






















; ------------------------------------------------------------
;  CÓDIGO
; ------------------------------------------------------------
                        org  AppFirst                   ; Comienzo de la aplicación

Dimension               equ 9                           ; 9 elementos (3 × 3)

; ——— Punto de entrada ———
AppEntry:
        LD   IX, MATRIZ_A               ; IX ? elemento actual de A
        LD   IY, MATRIZ_B               ; IY ? elemento actual de B
        LD   HL, MATRIZ_RESULTADO       ; HL ? destino del resultado
        LD   B, Dimension               ; B = contador restante (9)

BucleSuma:
        CALL SumaElementos              ; Calcula A[i] + B[i] ? MATRIZ_Z
        LD   A, (MATRIZ_Z)              ; A = resultado
        LD   (HL), A                    ; Guarda en matriz-resultado
        INC  IX                         ; Siguiente A[i]
        INC  IY                         ; Siguiente B[i]
        INC  HL                         ; Siguiente posición de salida
        DJNZ BucleSuma                  ; Repite hasta que B = 0

Fin                     HALT                            ; Detenemos la CPU para inspección
                        JP   Fin                        ; Bucle infinito

; ——— Subrutina: suma un elemento ———
SumaElementos:
        LD   A, (IX)                    ; A = elemento de A
        ADD  A, (IY)                    ; A = A + B
        LD   (MATRIZ_Z), A              ; Guarda resultado temporal
        RET                             ; Vuelve al bucle principal

; ------------------------------------------------------------
;  DATOS
; ------------------------------------------------------------
MATRIZ_A                defb 1,2,3,4,5,6,7,8,9          ; Ejemplo de datos
MATRIZ_B                defb 2,4,6,8,10,12,14,16,18          ; Ejemplo de datos
MATRIZ_RESULTADO        defs Dimension                  ; 9 bytes para la salida
MATRIZ_Z                defb 0                          ; Resultado temporal

; ------------------------------------------------------------
;  FIN DE CÓDIGO / GENERACIÓN DE FICHEROS
; ------------------------------------------------------------




















































; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

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


