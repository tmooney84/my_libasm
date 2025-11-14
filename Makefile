# ===== SETTINGS =====
CC      = gcc
ASM     = nasm
#CFLAGS  = -Wall -Wextra -Werror
#CFLAGS  = -Wall -Wextra -Werror -g -no-pie
CFLAGS  = -Wall -Wextra -g -no-pie

#CFLAGS  = -Wall -Wextra 

ASMFLAGS = -f elf64 -g -F dwarf

#ASMFLAGS = -f elf64
LDFLAGS = -lcriterion

# ===== FILES =====
ASM_SRC = my_libasm.asm
ASM_OBJ = $(ASM_SRC:.asm=.o)

TEST_SRC = libasm_test.c
TEST_OBJ = $(TEST_SRC:.c=.o)

TARGET = tests

# ===== RULES =====
all: $(TARGET)

$(ASM_OBJ): $(ASM_SRC)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(TEST_OBJ): $(TEST_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(ASM_OBJ) $(TEST_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(ASM_OBJ) $(TEST_OBJ)

fclean: clean
	rm -f $(TARGET)

re: fclean all
