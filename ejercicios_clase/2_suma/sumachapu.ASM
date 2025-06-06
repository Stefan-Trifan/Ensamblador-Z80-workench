; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "SumaVector"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+































                        org AppFirst

AppEntry                LD IX, arr_mis_num      ; IX es un puntero. Lo apuntamos al inicio de arr_mis_num
                        LD A, (long_vector)     ; Cargamos en el acumulador la longitud del vector
                        LD B, A                 ; Cargamos la longitud a B para usarlo como contador

bucle_suma              LD A, (IX)              ; Cargamos en A la direccion a la que apunta IX (1)
                        LD DE, (resultado)      ; Cargamos en DE el resultado
                        ADD A, E                ; Suma E
                        LD (resultado), A       ; Guardamos en la variable resultado
                        INC IX                  ; Incrementamos el puntero para pasar a la siguiente direccion de mi array
                        DJNZ bucle_suma

Final                   HALT
                        jp Final

AppLast                 equ *-1

arr_mis_num             defb 1, 3, 2, 8, 4      ; Vector con 5 numeros

resultado               defb 0                  ; Aqui guardamos la suma
                        defb 0

long_vector             defb 5                  ; Los elementos que tiene arr_mis_num







































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


