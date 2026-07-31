NVCC := nvcc

SRC := reduce.cu
TARGET := reduce

CFLAGS := -O2

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) $(CFLAGS) $< -o $@

run: $(TARGET)
	@./$(TARGET)

clean:
	rm -f $(TARGET)
