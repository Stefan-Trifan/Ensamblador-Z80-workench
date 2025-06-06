; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+







; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

LongitudVector          equ 10                          ; Longitud de la serie
FiboSerie               defb 1,1,0,0,0,0,0,0,0,0        ; Vector para la serie

AppEntry                LD B, LongitudVector - 2        ;
                        LD IX, FiboSerie + 2

BucleFibonacci          LD A, 0                         ; Me aseguro que el acumulador esta a 0
                        LD A, (IX-1)                    ; Cargo FiboSerie - 1
                        ADD A, (IX-2)                   ; Sumo Fiboserie-2
                        LD (IX), A                      ; Guardo en Fiboserie
                        DJNZ BucleFibonacci

Final                   halt                            ; Replace these lines with your code
                        jp Final                        ;











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


