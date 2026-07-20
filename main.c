#include <stddef.h>
#include <stdio.h>

extern size_t strlen(const char *str);

int main(void) {
  const char *s = "Howdy from AVX2 ;)";

  size_t len = strlen(s);

  printf("String : \"%s\"\n", s);
  printf("Length : %zu\n", len);

  return 0;
}
