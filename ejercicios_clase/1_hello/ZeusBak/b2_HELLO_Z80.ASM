; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "MyHelloWorld"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+







































                        org AppFirst

AppEntry                LD BC, (mi_x)                    ; B = 0, C = 4
                        LD DE, (mi_y)                    ; D = 0, E = 2
                        LD A, C                         ; A = C = 4
                        ADD A, E                        ; A += E
                        LD (resultado), A

                        halt
                        jp AppEntry
AppLast                 equ *-1
                        profile AppFirst,AppLast-AppFirst+1

mi_x                    defb 4
                        defb 0

mi_y                    defb 2
                        defb 0

resultado               defb 0
                        defb 0







































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


