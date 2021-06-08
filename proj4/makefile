FILE  = main
FILE2 = validate
FILE3 = split
FILE4 = jump
FILE5 = square

all: $(FILE)

$(FILE): $(FILE).asm $(FILE2).asm $(FILE3).asm $(FILE4).asm $(FILE5).c
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	nasm -f elf64 -l $(FILE2).lst $(FILE2).asm
	nasm -f elf64 -l $(FILE3).lst $(FILE3).asm
	nasm -f elf64 -l $(FILE4).lst $(FILE4).asm
	gcc -c	$(FILE5).c -o $(FILE5).o
	gcc -m64 -o $(FILE) $(FILE2).o $(FILE3).o $(FILE4).o $(FILE5).o $(FILE).o -lm

two: $(FILE2).asm
	nasm -f elf64 -l $(FILE2).lst $(FILE2).asm
	gcc -m64 -o $(FILE2) $(FILE2).o

three: $(FILE3).asm
	nasm -f elf64 -l $(FILE3).lst $(FILE3).asm
	gcc -m64 -o $(FILE3) $(FILE3).o

four: $(FILE4).asm
	nasm -f elf64 -l $(FILE4).lst $(FILE4).asm
	gcc -m64 -o $(FILE4) $(FILE4).o

five: $(FILE5).c
	gcc -c	$(FILE5).c -o $(FILE5).o

run: $(FILE)
	./$(FILE)

gdb: $(FILE)
	gdb $(FILE)

clean: 
	rm *.o *.lst