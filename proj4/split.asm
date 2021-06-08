;Name: Abel Asfaw
;ID: FV79057

;This subroutine gets user input for an integer split value and validates 
;that it is between 0 and the total number of characters in the current 
;message. If invalid, it display an error message. If valid, it displays the 
;encrypted version of the current message by going to the character 
;in the string at the split value, splitting the string at that location 
;and putting the second part of that string at the front.

%define stdin  0
%define stdout 1

                extern  scanf
                extern  printf

                section .data
new_line:       db      0x0A, 0
len_nl:	        equ     $-new_line

split_val_msg:  db      "Enter split value -> ", 0
len_svm:        equ     $-split_val_msg

invalid_split:  db      "Invalid split value.", 0x0A, 0
len_is:         equ     $-invalid_split

greater_than:   db      "Split value has to be greater than 0.", 0x0A,  0
len_gt:         equ     $-greater_than

less_than:      db      "Split value has to be less than message length. Current message length is %d.", 0x0A,  0
len_lt:         equ     $-less_than

curr_msg:       db      "Current message: %s", 0
len_cm:         equ     $-curr_msg

split_encrypt:  db      "Split encryption: ", 0
len_se:         equ     $-split_encrypt

format:         db      "%d", 0

            section .bss
split_buff: resb    4

        section .text
        global  split
split:
        ;"Enter split value: "
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, split_val_msg
        mov     rdx, len_svm 
        syscall
        
        ;read in input and store in split_buff
        mov     rdi, format
        mov     rsi, split_buff
        mov     rax, 0
        call    scanf

        xor     r15, r15
        mov     r15b, [split_buff]

validate_split_value:
        ;invalid if split value is less than 1
        cmp     r15, 1
        jl      invalid_greater

        ;invalid if split value is greater than or equal to string length
        cmp     r15, r13
        jge     invalid_less

        jmp     valid

invalid_greater:
        ;print "Invalid split value."
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, invalid_split
        mov     rdx, len_is 
        syscall

        ;tell user that split value has to be greater than 1
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, greater_than
        mov     rdx, len_gt
        syscall

        jmp     split

invalid_less:
        ;prints out invalid split value
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, invalid_split
        mov     rdx, len_is 
        syscall

        ;print out current length of string
        mov     rdi, less_than
        mov     rsi, r13
        mov     rax, 0
        call    printf

        jmp     split
        
valid:                
        xor     r14, r14
        mov     r14, r12    ;r12 holds address of the current string

        xor     rbx, rbx    ;rbx is our counter for how many characters
                            ;are in our string past our split index
        ;split string
        add     r14, r15    ;r15 holds the split value
                            ;r14 now points to the character we want to split at

count_loop:
        ;counts how many characters exist past the split index
        mov     al, [r14 + rbx]

        cmp     al, 0x0A
        je      print

        add     rbx, 1
        jmp     count_loop

print:
        ;print the current message
        mov     rdi, curr_msg
        mov     rsi, r12
        mov     rax, 0
        call    printf

        ;print "Split encrypt:"
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, split_encrypt
        mov     rdx, len_se 
        syscall

        ;prints the characters past the split index
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, r14
        mov     rdx, rbx
        syscall

        ;prints the characters before the split index
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, r12
        mov     rdx, r15
        syscall

        ;print a new line
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, new_line
        mov     rdx, len_nl
        syscall

        ret