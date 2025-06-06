; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+























































; ----------------------------------------------------------------------------------------------------
                        org     AppFirst                ; Punto de carga de la app
; ----------------------------------------------------------------------------------------------------

AppEntry:                                             ; ? Ejecución comienza aquí
; -------------------------  Constantes  -------------------------------------------------------------
DIMENSION       EQU     9                             ; 3 × 3 = 9 elementos
; -------------------------  Código principal  -------------------------------------------------------

                LD      HL, MATRIZ_A                  ; HL ? A[0]
                LD      DE, MATRIZ_B                  ; DE ? B[0]
                LD      IX, MATRIZ_RESULTADO          ; IX ? R[0]
                LD      B, DIMENSION                  ; B = 9 (contador)

Bucle:
                LD      A, (HL)        ; A = A[i]
                LD      D, A           ; opcional si quieres conservar A[i] en D
                LD      A, (DE)        ; A = B[i]
                LD      C, A           ; C = B[i]
                LD      A, (HL)        ; volver a cargar A[i] (si se sobreescribió)
                CALL    SumaElementos  ; A ? A + C
                LD      (IX), A        ; guardar en resultado

                INC     HL
                INC     DE
                INC     IX
                DJNZ    Bucle


; -------------------------  Bucle fin de programa  --------------------------------------------------
Final:          halt                                  ; Párate aquí para comprobar la RAM
                jp      Final                         ; bucle infinito

; -------------------------  Subrutina  --------------------------------------------------------------
;  Entrada: A = elemento de A,  C = elemento de B
;  Salida : A = A + C   y  (MATRIZ_Z) = A
SumaElementos:
                ADD     A, C
                LD      (MATRIZ_Z), A
                RET
; -------------------------  Datos  ------------------------------------------------------------------
MATRIZ_A:           DB  1,2,3,4,5,6,7,8,9
MATRIZ_B:           DB  9,8,7,6,5,4,3,2,1
MATRIZ_RESULTADO:   DS  DIMENSION                     ; 9 bytes para la salida
MATRIZ_Z:           DB  0                             ; resultado temporal
Dimension:          DB  DIMENSION                     ; el enunciado pide la variable

; ----------------------------------------------------------------------------------------------------
AppLast             equ $-1                           ; Último byte utilizado
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


