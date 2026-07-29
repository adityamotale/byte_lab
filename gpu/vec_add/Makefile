NVCC := nvcc

SRC := vec_add.cu
TARGET := vec_add

CFLAGS := -O2

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) $(CFLAGS) $< -o $@

run: $(TARGET)
	@./$(TARGET)

clean:
	rm -f $(TARGET)
