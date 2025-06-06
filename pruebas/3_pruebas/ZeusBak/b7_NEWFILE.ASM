AppFilename             equ "SumaMatrices"             ; Nombre del archivo

AppFirst                equ $8000                      ; Memoria inicial
                        zeusemulate "48K","ULA+"       ; Emulador 48K ULA+

                        org AppFirst                   ; Comienzo del código

; -------------------- Variables -----------------------
MATRIZ_A                defb 1,2,3,4,5,6,7,8,9          ; Primer vector (matriz 3x3)
MATRIZ_B                defb 9,8,7,6,5,4,3,2,1          ; Segundo vector (matriz 3x3)
MATRIZ_RESULTADO        defs 9                         ; Resultado de la suma
resultado_parcial       defb 0                         ; Zona donde SumaElementos deja el resultado
Dimension               defb 9                         ; Número de elementos de cada vector (matriz 3x3)

; -------------------- Código principal -----------------------

AppEntry                LD IX, MATRIZ_A                ; IX apunta al comienzo de MATRIZ_A
                        LD IY, MATRIZ_B                ; IY apunta al comienzo de MATRIZ_B
                        LD HL, MATRIZ_RESULTADO        ; HL apunta donde escribiremos el resultado

                        LD A, (Dimension)              ; Cargamos en A el número de elementos
                        LD B, A                        ; Usamos B como contador

BucleSuma               LD A, (IX)                     ; A = elemento de MATRIZ_A
                        PUSH AF                        ; Guardamos en la pila

                        LD A, (IY)                     ; A = elemento de MATRIZ_B
                        PUSH AF                        ; Guardamos en la pila

                        CALL SumaElementos             ; Llamamos a la rutina que suma y guarda en resultado_parcial

                        POP AF                         ; Recuperamos (limpiamos) los datos de la pila
                        POP AF

                        LD A, (resultado_parcial)      ; A = resultado parcial
                        LD (HL), A                     ; Lo almacenamos en MATRIZ_RESULTADO

                        INC IX                         ; Pasamos al siguiente elemento de MATRIZ_A
                        INC IY                         ; Pasamos al siguiente elemento de MATRIZ_B
                        INC HL                         ; Pasamos al siguiente en MATRIZ_RESULTADO

                        DJNZ BucleSuma                 ; Repetimos mientras B != 0

Fin                     halt                           ; Fin del programa
                        jp Fin                         ; Bucle infinito al final

; -------------------- Rutina SumaElementos -----------------------

SumaElementos:
                        POP DE                         ; Recuperamos el segundo valor (MATRIZ_B)
                        POP AF                         ; Recuperamos el primer valor (MATRIZ_A)
                        ADD A, D                       ; Sumamos ambos
                        LD (resultado_parcial), A      ; Guardamos el resultado en variable temporal
                        RET                            ; Volvemos al punto de llamada

; -------------------- Fin del código -----------------------

AppLast                 equ *-1                        ; Última dirección usada

                        profile AppFirst, AppLast-AppFirst+1

Zeus_PC                 equ AppEntry                   ; Punto de entrada
Zeus_SP                 equ $FF40                      ; Puntero de pila

                        output_szx AppFilename+".szx",$0000,AppEntry
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry

