; ------------------------------------------------------------------
;  Programa 3 – Sumar matrices (vector de 9 elementos)
;  Estilo idéntico a los ejemplos de clase
; ------------------------------------------------------------------

AppFilename             equ "SumarMatrices"             ; Nombre del archivo
AppFirst                equ $8000                       ; Código en RAM no contendida

                        zeusemulate "48K","ULA+"        ; Spectrum 48 K y ULA+

; ------------------------------------------------------------------
;  Datos
; ------------------------------------------------------------------
Dimension               equ 9                           ; Nº de elementos por vector

MATRIZ_A                defb 1,2,3,4,3,6,7,8,9          ; Ejemplo (fila-major)
MATRIZ_B                defb 9,8,7,6,5,4,3,2,1          ; Ejemplo inverso
MATRIZ_RESULTADO        defs Dimension                  ; Espacio para la suma
MATRIZ_Z                defb 0                          ; Resultado de cada suma

; ------------------------------------------------------------------
;  Código
; ------------------------------------------------------------------
                        org AppFirst                    ; Punto de ensamblado

AppEntry:
                        LD IX, MATRIZ_A                 ; IX ? A[0]
                        LD IY, MATRIZ_B                 ; IY ? B[0]
                        LD HL, MATRIZ_RESULTADO         ; HL ? R[0]
                        LD B, Dimension                 ; B = 9  (contador)

BucleSuma:
                        CALL SumaElementos              ; Calcula A[i]+B[i] ? MATRIZ_Z
                        LD  A, (MATRIZ_Z)               ; A = resultado
                        LD  (HL), A                     ; R[i] = resultado

                        ; Avanzamos al siguiente elemento
                        INC IX                          ; IX ? A[i+1]
                        INC IY                          ; IY ? B[i+1]
                        INC HL                          ; HL ? R[i+1]

                        DJNZ BucleSuma                  ; Mientras B ? 0

FinPrograma:
                        HALT                            ; Fin — pausa el Z80
                        JP FinPrograma                  ; Bucle infinito

; ------------------------------------------------------------------
;  Sub-rutina: SumaElementos
;  Entrada : IX ? A[i], IY ? B[i]
;  Salida  : MATRIZ_Z = A[i] + B[i]
; ------------------------------------------------------------------
SumaElementos:
                        LD  A, (IX)                     ; A = A[i]
                        ADD A, (IY)                     ; A = A + B[i]
                        LD  (MATRIZ_Z), A               ; Guarda en variable intermedia
                        RET                             ; Regresa al llamante

; ------------------------------------------------------------------
;  Información para el emulador / ficheros de salida
; ------------------------------------------------------------------
AppLast                 equ *-1                         ; Última dirección usada

                        profile AppFirst,AppLast-AppFirst+1 ; Profiling

Zeus_PC                 equ AppEntry                    ; PC inicial
Zeus_SP                 equ $FF40                       ; Stack seguro en RAM alta

                        output_szx AppFilename+".szx",$0000,AppEntry
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry

