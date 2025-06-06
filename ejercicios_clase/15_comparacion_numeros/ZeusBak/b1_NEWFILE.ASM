; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+








































; Si hay carri es mauor


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
nums                    defb 1,0,3,8,8,6,1,9
menor                   defb 0
mayor                   defb 0

AppEntry                LD HL, nums
                        LD A, (HL)
                        LD (menor), A
                        LD (mayor), A
                        LD B, 7

llaveabrirfor           LD A, (menor)
                        CP A, (HL)
                        JP Z llavecerrarfor
                        CALL NC EsMenor                   ; if (nums[i] < menor)

                        LD A, (mayor)
                        cp A, (HL)
                        JP Z llavecerrarfor
                        CALL C  EsMayor                   ; if (nums[i] > menor)

llavecerrarfor          INC HL
                        DJNZ llaveabrirfor

Final                   halt
                        jp Final

EsMenor                 LD A, (HL)
                        LD (menor), A
                        RET

EsMayor                 LD A, (HL)
                        LD (mayor), A
                        RET


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


