NASM := nasm
LD   := ld

TARGET := memcmp_avx2
OBJ    := memcmp_avx2.o
SRC    := memcmp_avx2.asm

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
