; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+




































; resumen: Carga en C = 1 si es par, c = 0 si es impar

                        org AppFirst

; ------------------------------------------------------------------------------------------------

AppEntry                LD D, 7                 ; Cargamos en D el numero que vamos a utilizar
                        LD A, D                 ; Cargamos en A el valor de D
                        AND 1                   ; Comparamos el bit menos significativo de A con 1
                                                ; Si es impar, A = 1, si es par A = 0
                        JP Z, EsPar             ; Salta a EsPar si el rasultado anterior fue 0

EsPar                   LD C, 1                 ; Carga 1 en C si es par
                        JP Final

; ------------------------------------------------------------------------------------------------

Final                   halt
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


