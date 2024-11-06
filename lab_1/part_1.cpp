//#include <stdio.h>
//
//
//#define P 499
//#define Q 547
//#define N (P * Q)
//
//
//int main() {
//    unsigned int seed;
//    printf("Enter seed (e.g., a number like 3, 7, 10, 100): ");
//    scanf_s("%u", &seed);
//    unsigned int x = (seed * seed) % N;
//    for (int i = 0; i < 100; i++) {
//        x = (x * x) % N;
//        unsigned int result = x & 0xFFFF;  // Используем 2 младших байта
//        printf("%u\n", result);
//    }
//    return 0;
//}