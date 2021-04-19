#include <stdint.h>


uint32_t calculateCRC32(char *src, int len);

//Soley there for testing purposes!
int iterative(int max, int len, uint32_t goal);
void decode(char* dst, int len, int result);

__global__ void bruteforceCRC32(uint64_t *result,int len, uint64_t max,uint32_t goal, uint8_t *hashSet1, uint32_t *hashSet2);

