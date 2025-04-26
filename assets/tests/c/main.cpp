#include <stdio.h>
int main()
{
    const int x = 20;
    printf("The valaue of x is %d \n", x);
    int *ptr = (int *)&x;
    *ptr = 5;
    printf("The valaue of x is %d \n", x);
}