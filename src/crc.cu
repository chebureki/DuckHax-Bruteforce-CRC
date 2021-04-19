#include "crc.h"
#include "hashsets.h"

uint32_t calculateCRC32(char *src, int len){
    uint32_t hash = 0xffffffff;
    for(int i=0;i<len;i++){
        hash = hashSet2[(hash&0xff)^hashSet1[src[i]]]^((hash) >>8);
    }
    return ~hash;
}


int iterative(int max, int len, uint32_t goal){
    for(int i=0;i<max;i++){
        uint32_t hash=0xffffffff;
        for(int j=0;j<len;j++){
            hash = hashSet2[(hash&0xff)^hashSet1[0x41+( (i&(31<<(5*j))) >>(5*j) )]]^((hash) >>8);
        }
        hash = ~hash;
        if(hash == goal){
            return i;
        }
    }
    return 0;
}

//__global__ void bruteforceCRC32(uint64_t *result,int len, uint64_t max,uint32_t *hashes, int lenHashes, uint8_t *hashSet1, uint32_t *hashSet2){
__global__ void bruteforceCRC32(uint64_t *result,int len, uint64_t max,uint32_t goal, uint8_t *hashSet1, uint32_t *hashSet2){
    uint64_t index = blockIdx.x*blockDim.x +threadIdx.x;
    uint64_t stride = blockDim.x * gridDim.x;

    for(uint64_t i=index;i<max;i+=stride){
        uint32_t hash=0xffffffff;
        for(int j=0;j<len;j++){
            //hashset1 is just 1,2,3,4,5.. 0xff right? FIX THIS FFS!
            //Kirill from the future: nope, see index 64-65
            hash = hashSet2[(hash&0xff)^hashSet1[0x41+( (i&(31<<(5*j))) >>(5*j) )]]^((hash) >>8);
        }
        //TODO: iterate lol
        hash = ~hash;
        if(*result != 0)
            break; // FIXME: this is stupid since it requires a memory read
        if(hash == goal){
            *result=i;
            break;
        }
    }
}

void decode(char* dst, int len, int result){
    for(int i=0;i<len;i++){
        char c = 0x41+((result&(31<<(5*i))) >>(5*i));
        dst[i] = c;
    }
}
