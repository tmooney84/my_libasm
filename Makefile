# === Makefile for x86-64 Assembly Library ===

ASM     = nasm
CC      = gcc
ASMFLAGS = -f elf64 -g -F dwarf
CFLAGS  = -Wall -Wextra -g
TARGET  = executor

# Assembly and C source files
ASM_SRC = my_libasm.asm
ASM_OBJ = $(ASM_SRC:.asm=.o)
C_SRC   = test_my_libasm.c
C_OBJ   = $(C_SRC:.c=.o)

# Default target
all: $(TARGET)

# Link everything
$(TARGET): $(ASM_OBJ) $(C_OBJ)
	$(CC) $(CFLAGS) -o $@ $^

# Assemble assembly code
$(ASM_OBJ): $(ASM_SRC)
	$(ASM) $(ASMFLAGS) -o $@ $<

# Compile C test file
$(C_OBJ): $(C_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

# Clean up
clean:
	rm -f $(ASM_OBJ) $(C_OBJ) $(TARGET)
