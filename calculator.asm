// 6502 Assembly Language Program - for Apple II
; Simple calculator for 8-bit numbers (0-9) 
; Performs addition, subtraction, multiplication, and division


        .org $800     ; Load address for execution

; --- Constants
GETCHR  = $FD0C       ; ROM routine: get character from keyboard
COUT    = $FDED       ; ROM routine: output character
CR      = $0D

; --- Main routine
START:
        JSR PRINT_MSG1  ; Prompt for first number
        JSR GETNUM
        STA NUM1

        JSR PRINT_MSG2  ; Prompt for second number
        JSR GETNUM
        STA NUM2

; --- Addition
        LDA NUM1
        CLC
        ADC NUM2
        STA RESULT_ADD

; --- Subtraction
        LDA NUM1
        SEC
        SBC NUM2
        STA RESULT_SUB

; --- Multiplication
        LDA #0
        STA RESULT_MUL
        LDX NUM2
        BEQ MUL_DONE
MUL_LOOP:
        CLC
        ADC NUM1
        DEX
        BNE MUL_LOOP
MUL_DONE:
        STA RESULT_MUL

; --- Division (integer)
        LDA NUM1
        LDX #0
DIV_LOOP:
        CMP NUM2
        BCC DIV_DONE
        SEC
        SBC NUM2
        INX
        JMP DIV_LOOP
DIV_DONE:
        STX RESULT_DIV

; --- Print results
        JSR NEWLINE

        LDA #'A'       ; Addition
        JSR COUT
        LDA RESULT_ADD
        JSR PRINT_HEX

        JSR NEWLINE
        LDA #'S'       ; Subtraction
        JSR COUT
        LDA RESULT_SUB
        JSR PRINT_HEX

        JSR NEWLINE
        LDA #'M'       ; Multiplication
        JSR COUT
        LDA RESULT_MUL
        JSR PRINT_HEX

        JSR NEWLINE
        LDA #'D'       ; Division
        JSR COUT
        LDA RESULT_DIV
        JSR PRINT_HEX

        JSR NEWLINE

        RTS

; --- Subroutines ---

GETNUM:                 ; Get one digit from keyboard
        JSR GETCHR
        SEC
        SBC #'0'        ; Convert ASCII to numeric (0–9)
        RTS

PRINT_HEX:              ; Print single digit (0–15) as ASCII
        CLC
        ADC #'0'
        CMP #'9'+1
        BCC PRINT_OK
        ADC #6          ; Convert A–F
PRINT_OK:
        JSR COUT
        RTS

PRINT_MSG1:
        LDX #0
MSG1_LOOP:
        LDA MSG1,X
        BEQ MSG1_DONE
        JSR COUT
        INX
        BNE MSG1_LOOP
MSG1_DONE:
        RTS

PRINT_MSG2:
        LDX #0
MSG2_LOOP:
        LDA MSG2,X
        BEQ MSG2_DONE
        JSR COUT
        INX
        BNE MSG2_LOOP
MSG2_DONE:
        RTS

NEWLINE:
        LDA #CR
        JSR COUT
        RTS

; --- Variables
NUM1        .byte 0
NUM2        .byte 0
RESULT_ADD  .byte 0
RESULT_SUB  .byte 0
RESULT_MUL  .byte 0
RESULT_DIV  .byte 0

; --- Strings
MSG1:   .byte "Enter 1st number (0-9): ",0
MSG2:   .byte "Enter 2nd number (0-9): ",0
