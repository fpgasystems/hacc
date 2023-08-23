#ifndef VECSUB_H
#define VECSUB_H

//#include "hip/hip_runtime.h" Marko do we need this?

// Declare the HIP kernel function
__global__ void vadd(double *a, double *b, double *c, int N, int deviceId);

#endif // VECSUB_H