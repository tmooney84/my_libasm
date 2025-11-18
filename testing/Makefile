ASM     = nasm
CC      = gcc
#ASMFLAGS = -f elf64 -g -F dwarf
ASMFLAGS = -f elf64
#CFLAGS  = -Wall -Wextra -Werror -g -no-pie
CFLAGS  = -Wall -Wextra -Werror
TARGET  = executor

ASM_SRC = my_libasm.asm
ASM_OBJ = $(ASM_SRC:.asm=.o)
C_SRC   = tester.c
C_OBJ   = $(C_SRC:.c=.o)

all: $(TARGET)

$(TARGET): $(C_OBJ) $(ASM_OBJ)
	$(CC) $(CFLAGS) -o $@ $(C_OBJ) $(ASM_OBJ)

$(ASM_OBJ): $(ASM_SRC)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(C_OBJ): $(C_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(ASM_OBJ) $(C_OBJ) $(TARGET)
