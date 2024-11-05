//#include <stdio.h>
//
//
//#define P 499
//#define Q 547
//#define N (P * Q)
//
//void generate_bbs(unsigned int seed) {
//    unsigned int x = (seed * seed) % N;
//    for (int i = 0; i < 100; i++) {
//        x = (x * x) % N;
//        unsigned int result = x & 0xFFFF;  // Используем 2 младших байта
//        printf("%u\n", result);
//    }
//}
//
//int main() {
//    unsigned int seed;
//    printf("Enter seed (e.g., a number like 3, 7, 10, 100): ");
//    scanf_s("%u", &seed);
//    generate_bbs(seed);
//    return 0;
//}