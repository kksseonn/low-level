#include <stdio.h>

#define P 499
#define Q 547
#define N (P * Q)

void generate_bbs(unsigned int seed) {
    unsigned int x = (seed * seed) % N;
    unsigned int result;
    int count = 100;

cycle_start:
    x = (x * x) % N;
    result = x & 0xFFFF;  // Используем 2 младших байта
    printf("%u\n", result);
    count--;
    if (count > 0) goto cycle_start;
}

int main() {
    unsigned int seed;
    printf("Enter seed (e.g., a number like 3, 7, 10, 100): ");
    scanf_s("%u", &seed);
    if (seed % P == 0 || seed % Q == 0) {
        printf("Seed should be coprime with %d. Please enter another number.\n", N);
        return 1;
    }
    generate_bbs(seed);
    return 0;
}