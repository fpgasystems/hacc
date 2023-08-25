#ifndef VECADD_H
#define VECADD_H

//#include "hip/hip_runtime.h" Marko: do we need this?

// Declare the HIP kernel function
namespace gpu {
    __global__ void vadd(double *a, double *b, double *c, int N, int deviceId);
}

#endif // VECADD_H