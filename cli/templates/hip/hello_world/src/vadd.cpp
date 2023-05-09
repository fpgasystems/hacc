#include "hip/hip_runtime.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define HIP_ASSERT(x) (assert((x)==hipSuccess))

// HIP kernel. Each thread takes care of one element of c
__global__ void vecAdd(double *a, double *b, double *c, int n)
{
    // Get our global thread ID
    int id = blockIdx.x*blockDim.x+threadIdx.x;
 
    // Make sure we do not go out of bounds
    if (id < n)
    { 
       c[id] = a[id] + b[id];
    }
}
 
int main( int argc, char* argv[] )
{
    // Size of vectors
    int n = 10240;
 
    // Host input vectors
    double *CPUArrayA;
    double *CPUArrayB;
    //Host output vector
    double *CPUArrayC;
    //Host output vector for verification
    double *CPUVerifyArrayC;
 
    // Device input vectors
    double *GPUArrayA;
    double *GPUArrayB;
    //Device output vector
    double *GPUArrayC;

   
    // Size, in bytes, of each vector
    size_t bytes = n*sizeof(double);
 
    // Allocate memory for each vector on host
    CPUArrayA = (double*)malloc(bytes);
    CPUArrayB = (double*)malloc(bytes);
    CPUArrayC = (double*)malloc(bytes);
    CPUVerifyArrayC = (double*)malloc(bytes);

    // Allocate memory for each vector on GPU
   HIP_ASSERT(hipMalloc(&GPUArrayA, bytes));
   HIP_ASSERT(hipMalloc(&GPUArrayB, bytes));
   HIP_ASSERT(hipMalloc(&GPUArrayC, bytes));
 
    int i;
    // Initialize vectors on host
    for( i = 0; i < n; i++ ) {
        CPUArrayA[i] = i;
        CPUArrayB[i] = i+1;
    }
 
    // Copy host vectors to device
    HIP_ASSERT(hipMemcpy(GPUArrayA, CPUArrayA, bytes, hipMemcpyHostToDevice));
    HIP_ASSERT(hipMemcpy(GPUArrayB, CPUArrayB, bytes, hipMemcpyHostToDevice));
 
    int blockSize, gridSize;
 
    // Number of threads in each thread block
    blockSize = 256;
 
    // Number of thread blocks in grid
    gridSize = (int)ceil((float)n/blockSize);
 
    // Execute the kernel
    vecAdd<<<gridSize,blockSize>>>(GPUArrayA,GPUArrayB,GPUArrayC,n);
    hipDeviceSynchronize();
    // Copy array back to host
   HIP_ASSERT(hipMemcpy(CPUArrayC,GPUArrayC, bytes, hipMemcpyDeviceToHost));

   //Compute for CPU 
   for(i=0; i <n; i++)
   {
    CPUVerifyArrayC[i] = CPUArrayA[i] + CPUArrayB[i];
   }


    //Verfiy results
    for(i=0; i <n; i++)
    {
    if (abs(CPUVerifyArrayC[i] - CPUArrayC[i]) > 1e-5) 
     {
     printf("Error at position i %d, Expected: %f, Found: %f \n", i, CPUVerifyArrayC[i], CPUArrayC[i]);
     }  
    }	

    
    // Release device memory
    HIP_ASSERT(hipFree(GPUArrayA));
    HIP_ASSERT(hipFree(GPUArrayB));
    HIP_ASSERT(hipFree(GPUArrayC));
 
    // Release host memory
    free(CPUArrayA);
    free(CPUArrayB);
    free(CPUArrayC);
    free(CPUVerifyArrayC);
 
    return 0;
}
