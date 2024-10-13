#include <stdio.h>

int exchange(int num1, int num2)
{
    printf("Before exchange num1 = %d and num2 = %d.\n", num1, num2);

    int temp = num1;
    num1 = num2;
    num2 = temp;

    printf("After exchange num1 = %d and num2 = %d.\n", num1, num2);
    return 0;
}