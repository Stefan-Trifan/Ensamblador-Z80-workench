; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+

; ------------------------------------------------------------

                        org  AppFirst

; ------------------------------------------------------------

Dimension               equ 9                           ; Guarda la dimension de la matriz
MATRIZ_A                defb 1,2,3,4,5,6,7,8,9          ; Declaramos los elementos de la matriz de 9 elementos
MATRIZ_B                defb 2,4,6,8,10,12,14,16,18     ;
MATRIZ_RESULTADO        defb 0,0,0,0,0,0,0,0,0          ; Declaramos matriz vacia de 9 elementos
MATRIZ_Z                defb 0                          ; Resultado temporal

; ------------------------------------------------------------

; Configuramos los punteros
AppEntry:
        LD IX, MATRIZ_A         ; IX apunta a la direccion de memoria de comienzo de MATRIZ_A
        LD IY, MATRIZ_B         ; IY apunta a la direccion de memoria de comienzo de MATRIZ_B
        LD HL, MATRIZ_RESULTADO ; HL apunta a la direccion de memoria de comienzo de MATRIZ_RESULTADO
        LD B,  Dimension        ; Guardamos en B la dimension

BucleSuma:
        CALL SumaElementos      ; Calculamos la suma de las 2 matrices y vamos dejando el resultado en MATRIZ_Z
        LD   A, (MATRIZ_Z)      ; A = resultado
        LD  (HL), A             ; Gurardamos el resultado en el lugar apuntado por HL
        INC  IX                 ; Pasamos al siguiente elemento de MATRIZ_A
        INC  IY                 ; Pasamos al siguiente elemento de MATRIZ_B
        INC  HL                 ; Pasamos al siguiente elemento de MATRIZ_RESULTADO
        DJNZ BucleSuma          ; Repetimos el bucle y restamos una unidad a B

SumaElementos:
        LD  A, (IX)             ; A = Contenido apuntado por IX
        ADD A, (IY)             ; A += Contenido apuntado por IY
        LD (MATRIZ_Z), A        ; Guardamos en el array temporal el resultado
        RET                     ; Volvemos al bucle

Fin:
        HALT
        JP Fin

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


