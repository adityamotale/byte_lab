NASM := nasm
LD   := ld

TARGET := strstr
OBJ    := strstr.o
SRC    := strstr.asm

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) -o $@ $^

$(OBJ): $(SRC)
	$(NASM) -f elf64 $< -o $@

run: $(TARGET)
	@./$(TARGET); \
	status=$$?; \
	echo "Exit code: $$status"

clean:
	rm -f $(TARGET) $(OBJ)
