; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+




































; resumen: Carga en C = 1 si es par, c = 0 si es impar

                        org AppFirst

; ------------------------------------------------------------------------------------------------

AppEntry    LD D, 8             ; Número a analizar
            LD A, D             ; Lo pasamos al acumulador
            AND 1               ; A = 1 si impar, A = 0 si par
            JP Z, EsPar         ; Si es par, salta a EsPar
            JP EsImpar          ; Si no, salta a EsImpar

EsPar       LD C, 1             ; Par ? C = 1
            JP Final

EsImpar     LD C, 0             ; Impar ? C = 0
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


