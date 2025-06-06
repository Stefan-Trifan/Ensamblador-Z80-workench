; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+




































                        org AppFirst

AppEntry                LD BC, 500              ; BC = 01F4  (B = 1, C = 244)
                        LD DE, 100              ; DE = 0064  (D = 0, E = 100)

                        LD A, C                 ; A = 244 (F4)
                        ADD A, E                ; A = 58 hex, 88 decimal
                        LD (resultado), A       ; Guardamos el resultado en memoria

                        HALT
                        JP AppEntry

resultado               defb 0                  ; resultado = A = 58 hex, 88 decimal

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


