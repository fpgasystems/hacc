#include "hip/hip_runtime.h"
#include "vsub.hpp"

// HIP kernel. Each thread takes care of one element of c
__global__ void gpu::vsub(double *a, double *b, double *c, int N, int deviceId)
{
    // Get our global thread ID
    int id = blockIdx.x * blockDim.x + threadIdx.x;

    // Make sure we do not go out of bounds
    if (id < N)
    {
        c[id] = a[id] - b[id];
    }
}