;Name: Abel Asfaw

;This subroutine prompts the user to enter an integer (jump value) that 
;is between 2 and the square root of the length of the current message, 
;inclusive. Now imagine that we are going to write the current message 
;in a table form, using the same number of rows as the jump value. 
;The character order in the original message would be the order of the 
;first column, followed by the second column, etc.

%define stdin  0
%define stdout 1

                extern  square
                extern  printf
                extern  scanf

                section .data
new_line:       db      0x0A, 0
len_nl:	        equ     $-new_line

format:         db      "%d", 0

jump_val_msg:   db      "Enter jump interval between 2 and %d -> ", 0

invalid_jump:   db      "Invalid jump value.", 0x0A, 0
len_ij:         equ     $-invalid_jump

less_than:      db      "Jump value must be between 2 and %d, inclusive.", 0x0A,  0
len_lt:         equ     $-less_than

curr_msg:       db      "Current message: %s", 0
len_cm:         equ     $-curr_msg

jump_encrypt:   db      "Jump encryption: ", 0
len_je:         equ     $-jump_encrypt

                section .bss
jump_buff:      resb    4
char_buff:      resb    1
        
        section .text
        global  jump
jump:
        xor     rdi, rdi
        xor     rax, rax
        xor     r14, r14    ;stores the current square root length

        mov     rdi, r13    ;move length of current string into rdi
        call    square      ;find the square root of the length
        mov     r14, rax    ;move the return value into r14

        ;"Enter jump interval between 2 and %d: "
        mov     rdi, jump_val_msg
        mov     rsi, r14
        mov     rax, 0
        call    printf

        mov     rdi, format
        mov     rsi, jump_buff
        mov     rax, 0
        call    scanf

        xor     r15, r15
        mov     r15b, [jump_buff]

validate_jump_value:
        ;invalid if jump value is less than 2
        cmp     r15, 2
        jl      invalid

        ;invalid if jump value is greater than square root of string length
        cmp     r15, r14
        jg      invalid

        jmp     valid

invalid:
        ;print out "Invalid jump value"
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, invalid_jump
        mov     rdx, len_ij
        syscall

        ;print out current square root length of string
        mov     rdi, less_than
        mov     rsi, r14
        mov     rax, 0
        call    printf

        jmp     jump

valid:
        ;print the current message
        mov     rdi, curr_msg
        mov     rsi, r12
        mov     rax, 0
        call    printf

        ;"Jump encrypt: "
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, jump_encrypt
        mov     rdx, len_je 
        syscall

        xor     rbx, rbx
        xor     r10, r10
        mov     r10, -1

;this is basically equivalent to C/C++ statements like:
;for (i = 0; ...) {
;   for (j = i; ...) {
;    
;   }
;}
;where i is r10 and j is rbx
outer_loop:
        ;reset the inner loop
        xor     r14, r14
        mov     r14, r12    ;r14 points to the beginning of the string
        xor     rbx, rbx    ;rbx = 0
        
        inc     r10         ;increment 'i'
        mov     rbx, r10    ;'j' = 'i'

inner_loop:
        cmp     r10, r15    ;compare r10 to the square root of the string (r15)
        jge     done        ;done if greater than or equal to it

        cmp     rbx, r13    ;compare rbx to the length of the string
        jge     outer_loop  ;reset if greater than or equal to it

        mov     al, [r14 + rbx]
        add     rbx, r15    ;increment rbx by the jump value

        cmp     al, 0x0A    ;avoid printing a new line character
        je      inner_loop  ;before printing everything else

        mov     [char_buff], al

        ;print character
        mov     rax, stdout 
        mov     rdi, stdout
        mov     rsi, char_buff
        mov     rdx, 1
        syscall

        jmp     inner_loop

done:
        ;print a new line
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, new_line
        mov     rdx, len_nl
        syscall
           
        ret
