;Name: Abel Asfaw

;This is a menu-driven program to encrypt text messages.

%define VALID  1
%define stdin  0
%define stdout 1
%define exit   60

                extern  validate
                extern  split
                extern  jump

                section .data
format:         db      "%d", 0

new_line:       db      0x0A, 0
len_nl:	        equ     $-new_line

menu_msg:       db      "Encryption menu option:", 0x0A, 0
len_m:          equ     $-menu_msg

;menu option_buff messages
display_msg:    db      "d - display current message", 0x0A, 0
len_d:          equ     $-display_msg

read_msg:       db      "r - read new message", 0x0A, 0
len_r:          equ     $-read_msg

split_msg:      db      "s - split encrypt", 0x0A, 0
len_s:          equ     $-split_msg

jump_msg:       db      "j - jump encrypt", 0x0A, 0
len_j:          equ     $-jump_msg

quit_msg:       db      "q - quit program", 0x0A, 0
len_q:          equ     $-quit_msg

;input request/input response messages
option_msg:     db      "Enter option letter -> ", 0
len_om:         equ     $-option_msg

new_msg:        db      "Enter new message -> ", 0
len_nm:         equ     $-new_msg

default_str:    db      "This is the original message.", 0x0A, 0
len_ds:         equ     $-default_str

curr_msg:       db      "Current message: ", 0
len_cm:         equ     $-curr_msg

goodbye:        db      "Goodbye!", 0x0A, 0
len_gb:         equ     $-goodbye

invalid_option: db      "Invalid option, please try again", 0x0A, 0
len_io:         equ     $-invalid_option

                section .bss
string_buff:    resq    256
option_buff:    resq    2

        section .text
        global  main
main:           
        xor     r12, r12    ;r12 stores the current string
        xor     r13, r13    ;r13 stores the length of the current string

        mov     r12, default_str
        mov     r13, len_ds
        sub     r13, 2      ;prevents from counting '\n' and 0 (null) as part of length

loop:
        ;print a new line
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, new_line
        mov     rdx, len_nl
        syscall

        call    menu

        ;print out request for input
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, option_msg
        mov     rdx, len_om
        syscall

        ;read user input for menu options
        mov     rax, stdin
        mov     rdi, stdin
        mov     rsi, option_buff
        mov     rdx, 2
        syscall
    
        mov     al, [option_buff]

        cmp     al, 'd'
        je      display_message

        cmp     al, 'r'
        je      read_message

        cmp     al, 's'
        je      split_message

        cmp     al, 'j'
        je      jump_message

        cmp     al, 'q'
        je      quit

        jmp     invalid_menu_option

menu:
        ;Encryption menu option:
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, menu_msg
        mov     rdx, len_m	
        syscall

        ;d - display current message
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, display_msg
        mov     rdx, len_d
        syscall

        ;r - read new message
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, read_msg
        mov     rdx, len_r
        syscall

        ;s - split encrypt
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, split_msg
        mov     rdx, len_s
        syscall

        ;j - jump encrypt
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, jump_msg
        mov     rdx, len_j
        syscall

        ;q - quit program
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, quit_msg
        mov     rdx, len_q
        syscall

        ret

invalid_menu_option:
        ;print "Invalid option, please try again"
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, invalid_option
        mov     rdx, len_io
        syscall 

        jmp     loop

display_message:
        ;print "Current message:"
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, curr_msg
        mov     rdx, len_cm	
        syscall

        ;print out current message
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, r12
        mov     rdx, r13	
        syscall

        ;print a new line
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, new_line
        mov     rdx, len_nl
        syscall
        
        jmp     loop

read_message:
        ;print "Enter a new message"
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, new_msg
        mov     rdx, len_nm
        syscall

        ;store user input
        mov     rax, stdin
        mov     rdi, stdin
        mov     rsi, string_buff
        mov     rdx, 256
        syscall
        
        xor     rdi, rdi
        mov     rdi, string_buff

        call    validate    ;validate user input

        jmp     loop

split_message:
        call    split

        jmp     loop

jump_message:
        call    jump

        jmp     loop

quit:
        ;print "Goodbye!"
        mov     rax, stdout
        mov     rdi, stdout
        mov     rsi, goodbye
        mov     rdx, len_gb
        syscall

        ;exit
        mov         rax, exit
        xor         rdi, rdi
        syscall
