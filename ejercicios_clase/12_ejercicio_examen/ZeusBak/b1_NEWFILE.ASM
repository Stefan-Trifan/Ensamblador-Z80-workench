; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+

































; EJERCICIO 5 (3 Puntos)
; a) (1 punto) Escribir las siguientes lineas de codigo:

;       Cargar en el registro B el contenido de la posicion de memoria 8020h
        LD B, ($8020)

;       Sumar a B el condenido de la posicion de memoria 8030H
        ADD B, ($8030)

;       Incrementar el contenido de la direccion de memoria 8030H
;       Comparar el contenido del registro B con el de la direccion de memoria 8040H
;       Saltar a la direccion 8050H si los 2 valores son iguales





; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                LD BC, ($8020)
                        LD A, ($8030)
                        ADD B
                        LD B, A
                        INC A
                        LD ($8030), A
                        LD A, ($8040)
                        CP B
                        JP Z $8050

Para                    halt                            ; Replace these lines with your code
                        jp Para                     ;


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


