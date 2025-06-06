; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "SumaVector"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)























































                        org AppFirst

; ----------------------------------------------------------------------------------------------------------------------------------------------

arr_original            defb 1,2,3,4,5                          ; Declaracion array original
arr_copia               defs 5                                  ; Copiamos los valores del array de arriba
arr_mas_dos             defs 5                                  ; Aqui guardaremos los valores +2
longitud_arr            defb 5                                  ; Numero total de elementos

; ----------------------------------------------------------------------------------------------------------------------------------------------

AppEntry:
        LD IX, arr_original                     ; Apuntamos IX a la direccion de inicio de arr_original
        LD B, arr_copia - arr_original          ; Guardamos en B la diferencia entre las direcciones de arr_copia y arr_original
                                                                ; Equivale a la longitud del Array

bucle_copia:
        LD A, (IX)                              ; Cargamos en el acumulador el valor apuntaro por IX
        LD (IX + arr_copia - arr_original), A   ;
        ADD 2                                   ; Sumamos 2 al valor que está en A
        LD (IX + arr_mas_dos - arr_original), A ;
        INC IX                                  ; Movemos el puntero al siguiente elemento del array
        DJNZ bucle_copia                        ; Decrementa B y repite el bucle

; ----------------------------------------------------------------------------------------------------------------------------------------------

Final                   HALT                                    ; Final del programa
                        jp Final
AppLast                 equ *-1















































































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


