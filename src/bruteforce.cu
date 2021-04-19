#include "hashsets.h"
#include "crc.h"

#include <stdint.h>
#include <stdio.h>

//TODO check a bunch of hashes, AND SORT THEM BY SIZE!!! or maybe even build a pseudo binary-tree

int main(){
    //Copy hashsets to device
    uint8_t *dh1;
    uint32_t *dh2;
    cudaMalloc(&dh1, 256);
    cudaMalloc(&dh2, 4*256);
    cudaMemcpy(dh1, hashSet1, 256, cudaMemcpyHostToDevice);
    cudaMemcpy(dh2, hashSet2, 4*256, cudaMemcpyHostToDevice);

    //Just random hashes, run the program to figure out what they are lol
    uint32_t hashes[] = {0x49541d5a, 0x5ad7f6bc, 0x937db7ec, 0xa988cb16, 0xdf4ac7b9};
    uint32_t goal = 0xdf4ac7b9;

    int maxLen = 7;
	for(int len=1;len<=maxLen;len++){
        //Checking 32 chars => max = 32^maxLen
		uint64_t max=32;
		for(int i=0;i<len;i++)
			max*=32;

		uint64_t *d_result;
		cudaMalloc(&d_result,sizeof(uint64_t));
		//bruteforceCRC32<<<1,1024>>>(d_result,len,max,hashes,sizeof(hashes)/4,dh1,dh2);

		bruteforceCRC32<<<1000,1024>>>(d_result,len,max,goal,dh1,dh2);
		cudaDeviceSynchronize();

		uint64_t result = 0;
		cudaMemcpy(&result, d_result, sizeof(uint64_t), cudaMemcpyDeviceToHost);

		if(result!=0){
			char decoded[len];
			decode(decoded,len,result);
			printf("RESULT: %s -> %x\n",decoded,calculateCRC32(decoded,len));
			break;
		}
	}

    cudaFree(dh1);
    cudaFree(dh2);
	return 0;
}
