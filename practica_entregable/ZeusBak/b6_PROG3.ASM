; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+























































DIMENSION       EQU     9              ; constante

; ====================  Datos de prueba  =====================
MATRIZ_A:       DB      1,2,3,4,5,6,7,8,9
MATRIZ_B:       DB      9,8,7,6,5,4,3,2,1
MATRIZ_RESULTADO: DS    DIMENSION      ; reserva 9 bytes (salida)

Dimension:      DB      DIMENSION      ; mismo valor pero como byte de RAM
MATRIZ_Z:       DB      0              ; resultado temporal de la subrutina
; ============================================================

; ------------------------------------------------------------
;               Código principal
; ------------------------------------------------------------
START:
                LD      HL, MATRIZ_A           ; HL ? A[0]
                LD      DE, MATRIZ_B           ; DE ? B[0]
                LD      IX, MATRIZ_RESULTADO   ; IX ? R[0]
                LD      B, DIMENSION           ; B = 9  (contador)

BUCLE:
                LD      A, (HL)                ; A = A[i]
                LD      C, (DE)                ; C = B[i]
                CALL    SumaElementos          ; suma ? A y MATRIZ_Z
                LD      (IX), A                ; R[i] = resultado

                INC     HL                     ; avanzar punteros
                INC     DE
                INC     IX
                DJNZ    BUCLE                  ; mientras B-- ? 0

; --------------  Fin (bucle infinito)  ----------------------
FIN:            JP      FIN

; ------------------------------------------------------------
; Subrutina: SumaElementos
;  Entrada : A = elemento de A,  C = elemento de B
;  Salida  : A = A + C  (también se guarda en MATRIZ_Z)
; ------------------------------------------------------------
SumaElementos:
                ADD     A, C                   ; A = A + C
                LD      (MATRIZ_Z), A          ; guarda copia
                RET
; ------------------------------------------------------------
                END     START




















































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


