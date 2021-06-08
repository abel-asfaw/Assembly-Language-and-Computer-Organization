; Name: Abel Asfaw
; ID: FV79057

; This is a program that asks the user for a 15 character string.
; After the user enters the string, the program will display the
; string, undedited, then will display an edited version of it.
; The code goes to the 9th character in the string and splits the 
; string at that location. It then puts the second half of that string
; at the front.

            section     .data
request:    db          "Enter a 15 character string -> ", 0x0A ;0x0A is newline in ascii
len_r:      equ         $-request

unedited:   db          "Here is your string unedited:", 0x0A
len_uned:   equ         $-unedited

edited:     db          "Here is your string edited:", 0x0A
len_ed:     equ         $-edited

            section     .bss
str_buff    resb        16  ; this is where the user's string is stored

            section     .text
            global      main

main:
            ; prints out input request
            mov         rax, 1
            mov         rdi, 1
            mov         rsi, request
            mov         rdx, len_r 
            syscall

            ; reads in input and stores in str_buff
            mov         rax, 0
            mov         rdi, 0
            mov         rsi, str_buff
            mov         rdx, 16 
            syscall

            ; prints "Here is your string unedited:"
            mov         rax, 1
            mov         rdi, 1
            mov         rsi, unedited
            mov         rdx, len_uned
            syscall

            ; prints out the unedited string
            mov         rax, 1
            mov         rdi, 1
            mov         rsi, str_buff
            mov         rdx, 16
            syscall
   
            ; splits string
            mov         r8, str_buff    ; r8 points to the mem. address of-
                                        ; the first char of str_buff.
            xor         r9, r9
            mov         r9, [r8]    ; stores the first 8 characters of-
                                    ; str_buff in r9.
            mov         r10, str_buff   ; r10 points to the mem. address of-
                                        ; the first char of str_buff.
            add         r10, 8  ; r10 now points to the mem. address-
                                ; of 9th character of str_buff.
            xor         r11, r11
            mov         r11, [r10]  ; stores all the characters past the-
                                    ; 9th (and including the 9th) in r11.

            ; creates the edited string            
            mov         [r8], r11   ; overwrites the first 8 characters of-
                                    ; str_buff with the last 8 characters.
            add         r8, 7   ; r8 points to the 8th character (\n)-
                                ; so it can be overwritten.
            mov         [r8], r9    ; overwrites the latter half of-
                                    ; str_buff with the first 8 characters-
                                    ; of the original string.
            
            ; prints "Here is your string edited:"
            mov         rax, 1
            mov         rdi, 1
            mov         rsi, edited
            mov         rdx, len_ed
            syscall

            ; prints out the edited string
            mov         rax, 1
            mov         rdi, 1
            mov         rsi, str_buff
            mov         rdx, 16
            syscall

exit:
            mov         rax, 60
            xor         rdi, rdi
            syscall

