#include <stdio.h>

int test(int x, int y) {
  int val = y + 12;
  if (x < 0) {
    if (x < y)
      val = x * y;
    else
      val = x | y;
  } else if (y > 10)
    val = x / y;
  return val;
}

int main() {
    int v = test(12, 15);
    printf("the value is: %ld", v);
    return 0;
}