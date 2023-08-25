#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <math.h>

//HIP application workflow
#include "hip/hip_runtime.h"
#include "gpu_kernels.hpp" 
#include "../global_params.hpp"
#include "../configs/config_000.hpp" // config_000.hpp is overwritten with the configuration you select

#define HIP_ASSERT(x) (assert((x)==hipSuccess))
 
int main( int argc, char* argv[] )
{
    // Size of vectors (replaced by N in config_000)
    //int n = 10240; 

    int deviceId = 0; // Default value in case no argument is provided.

    // Convert the first command-line argument (argv[1]) to an integer.
    if (argc > 1) // Ensure that at least one command-line argument is provided.
    {
        deviceId = std::atoi(argv[1]);
    }

    // Set the device from the host code
    hipError_t setDeviceResult = hipSetDevice(deviceId);
    if (setDeviceResult != hipSuccess) {
        std::cerr << "Failed to set the device. Error: " << hipGetErrorString(setDeviceResult) << std::endl;
        return 1;
    }

    // Check if the device ID was truly set
    int currentDevice;
    hipError_t getDeviceResult = hipGetDevice(&currentDevice);
    if (getDeviceResult != hipSuccess) {
        std::cerr << "Failed to get the current device. Error: " << hipGetErrorString(getDeviceResult) << std::endl;
        return 1;
    }

    if (currentDevice != deviceId) {
        std::cerr << "The selected deviceId (" << deviceId << ") was not set properly. Current device ID is: " << currentDevice << std::endl;
        return 1;
    }

    // Your program logic using the deviceId goes here.
    std::cout << "Device ID: " << deviceId << std::endl;

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
    size_t bytes = N*sizeof(double);
 
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
    for( i = 0; i < N; i++ ) {
        CPUArrayA[i] = i;
        CPUArrayB[i] = i+1;
    }
 
    // Copy host vectors to device
    HIP_ASSERT(hipMemcpy(GPUArrayA, CPUArrayA, bytes, hipMemcpyHostToDevice));
    HIP_ASSERT(hipMemcpy(GPUArrayB, CPUArrayB, bytes, hipMemcpyHostToDevice));
 
    //int blockSize, gridSize;
    int gridSize;
 
    // Number of threads in each thread block (replaced by N_THREADS in config_000)
    //blockSize = 256;
 
    // Number of thread blocks in grid
    gridSize = (int)ceil((float)N/N_THREADS);
 
    // Execute the kernel
    gpu::vadd<<<gridSize,N_THREADS>>>(GPUArrayA,GPUArrayB,GPUArrayC,N,deviceId);
    hipDeviceSynchronize();
    // Copy array back to host
   HIP_ASSERT(hipMemcpy(CPUArrayC,GPUArrayC, bytes, hipMemcpyDeviceToHost));

   //Compute for CPU 
   for(i=0; i <N; i++)
   {
    CPUVerifyArrayC[i] = CPUArrayA[i] + CPUArrayB[i];
   }

    //Verfiy results
    int err = 0;
    for (int i = 0; i < N; i++) {
        if (abs(CPUVerifyArrayC[i] - CPUArrayC[i]) > 1e-5) {
            printf("Error at position i %d, Expected: %f, Found: %f \n", i, CPUVerifyArrayC[i], CPUArrayC[i]);
            err = 1;
            break;
        }       
    }

    //print error message
    if (err == 0) {    
        printf("TEST PASSED!\n");
    } else {
        printf("TEST FAILED!\n");
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
