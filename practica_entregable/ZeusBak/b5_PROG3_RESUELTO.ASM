; ------------------------------------------------------------------
;  Programa 3 � Sumar matrices (vector de 9 elementos)
;  Estilo id�ntico a los ejemplos de clase
; ------------------------------------------------------------------

AppFilename             equ "SumarMatrices"             ; Nombre del archivo
AppFirst                equ $8000                       ; C�digo en RAM no contendida

                        zeusemulate "48K","ULA+"        ; Spectrum�48�K y ULA+

; ------------------------------------------------------------------
;  Datos
; ------------------------------------------------------------------
Dimension               equ 9                           ; N� de elementos por vector

MATRIZ_A                defb 1,2,3,4,5,6,7,8,9          ; Ejemplo (fila-major)
MATRIZ_B                defb 9,8,7,6,5,4,3,2,1          ; Ejemplo inverso
MATRIZ_RESULTADO        defs Dimension                  ; Espacio para la suma
MATRIZ_Z                defb 0                          ; Resultado de cada suma

; ------------------------------------------------------------------
;  C�digo
; ------------------------------------------------------------------
                        org AppFirst                    ; Punto de ensamblado

AppEntry                LD IX, MATRIZ_A
                        LD IY, MATRIZ_B
                        CALL SumaElementos

                        LD A, (MATRIZ_Z)     ; Deber�a contener 1+9 = 10
                        LD (MATRIZ_RESULTADO), A

                        HALT
                        JP $

; ------------------------------------------------------------------
;  Sub-rutina: SumaElementos
;  Entrada : IX ? A[i], IY ? B[i]
;  Salida  : MATRIZ_Z = A[i] + B[i]
; ------------------------------------------------------------------
SumaElementos           LD  A, (IX)                     ; A = A[i]
                        ADD A, (IY)                     ; A = A + B[i]
                        LD  (MATRIZ_Z), A               ; Guarda en variable intermedia
                        RET                             ; Regresa al llamante

; ------------------------------------------------------------------
;  Informaci�n para el emulador / ficheros de salida
; ------------------------------------------------------------------
AppLast                 equ *-1                         ; �ltima direcci�n usada

                        profile AppFirst,AppLast-AppFirst+1 ; Profiling

Zeus_PC                 equ AppEntry                    ; PC inicial
Zeus_SP                 equ $FF40                       ; Stack seguro en RAM alta

                        output_szx AppFilename+".szx",$0000,AppEntry
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry

