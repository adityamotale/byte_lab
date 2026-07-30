#include <cuda_runtime.h>
#include <stdint.h>
#include <stdio.h>

#define N 0x100

__global__ void saxpy(const uint32_t a, const uint32_t n, const uint32_t *X,
                      const uint32_t *Y, uint32_t *C) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;

  if (idx < n) {
    C[idx] = a * X[idx] + Y[idx];
  }
}

int main(void) {
  const int blocks = 1;
  const int threads_per_block = N;
  const size_t bytes = N * sizeof(uint32_t);

  uint32_t *h_x = (uint32_t *)malloc(bytes);
  uint32_t *h_y = (uint32_t *)malloc(bytes);
  uint32_t *h_c = (uint32_t *)malloc(bytes);

  for (int i = 0; i < N; i++) {
    h_x[i] = (uint32_t)i;
    h_y[i] = (uint32_t)(i * 0x0A);
  }

  uint32_t *d_x = NULL;
  uint32_t *d_y = NULL;
  uint32_t *d_c = NULL;

  cudaMalloc((void **)&d_x, bytes);
  cudaMalloc((void **)&d_y, bytes);
  cudaMalloc((void **)&d_c, bytes);

  cudaMemcpy(d_x, h_x, bytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, h_y, bytes, cudaMemcpyHostToDevice);

  saxpy<<<blocks, threads_per_block>>>(0x0A, N, d_x, d_y, d_c);

  cudaDeviceSynchronize();
  cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

  printf("\nResults:\n");
  for (int i = 0; i < 0x0A; i++) {
    printf("%4d : %4d + %4d = %4d\n", i, h_x[i], h_y[i], h_c[i]);
  }

  cudaFree(d_x);
  cudaFree(d_y);
  cudaFree(d_c);

  free(h_x);
  free(h_y);
  free(h_c);

  return 0;
}
