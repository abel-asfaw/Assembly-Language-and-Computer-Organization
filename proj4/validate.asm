;Name: Abel Asfaw

;This subroutine validates the message to make sure that it starts with 
;a capital letter and ends with either a period ('.'), question mark ('?') 
;or exclamation point ('!'). If the input is invalid, it rejects it with 
;an error message to the user. Otherwise, it replaces the original message.

%define stdin  0
%define stdout 1

            section .data
inval_msg:  db      "Invalid message, keeping current", 0x0A, 0
len_im:     equ     $-inval_msg

        section .text
        global  validate
validate:
        xor     rcx, rcx    ;rcx keeps track of the length of the string

first_character:
        ;check if first character is a capital letter
        mov     al, [rdi + rcx]
        cmp     al, 'A'
        jl      invalid

        cmp     al, 'Z'
        jg      invalid

last_character:
        ;traverse to the end of the string
        mov     al, [rdi + rcx]

        cmp     al, 0x0A
        je      evaluate

        add     rcx, 1
        jmp     last_character

evaluate:
        sub     rcx, 1      ;once at the end of the string, point
                            ;to the last character instead of '\n'
        mov     al, [rdi + rcx]

        add     rcx, 1      ;now rcx is equal to the length of the string
                            ;can now be used to print current string/its length
        cmp     al, '.'
        je      valid

        cmp     al, '!'
        je      valid

        cmp     al, '?'
        je      valid

invalid:
        ;"Invalid message, keeping current"
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, inval_msg
        mov     rdx, len_im
        syscall

        ret

valid:
        ;updates current message if input is valid
        xor     r12, r12
        xor     r13, r13

        mov     r12, rdi    ;current message updated
        mov     r13, rcx    ;length updated

        ret
