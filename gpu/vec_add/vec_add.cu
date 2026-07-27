#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>

#define N 0x400

__global__ void vec_add(const float *a, const float *b, float *c, int n) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;

  if (idx < n) {
    c[idx] = a[idx] + b[idx];
  }
}

int main(void) {
  const size_t bytes = N * sizeof(float);

  float *h_a = (float *)malloc(bytes);
  float *h_b = (float *)malloc(bytes);
  float *h_c = (float *)malloc(bytes);

  if (!h_a || !h_b || !h_c) {
    fprintf(stderr, "malloc error\n");
    return 1;
  }

  for (int i = 0; i < N; i++) {
    h_a[i] = (float)i;
    h_b[i] = (float)(2 * i);
  }

  float *d_a = NULL;
  float *d_b = NULL;
  float *d_c = NULL;

  cudaMalloc((void **)&d_a, bytes);
  cudaMalloc((void **)&d_b, bytes);
  cudaMalloc((void **)&d_c, bytes);

  cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

  const int threads_per_block = 0x100;
  const int blocks = (N + threads_per_block - 1) / threads_per_block;

  vec_add<<<blocks, threads_per_block>>>(d_a, d_b, d_c, N);

  cudaDeviceSynchronize();
  cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

  printf("\nResults:\n");
  for (int i = 0; i < 0x0A; i++) {
    printf("%4d : %.1f + %.1f = %.1f\n", i, h_a[i], h_b[i], h_c[i]);
  }

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  free(h_a);
  free(h_b);
  free(h_c);

  return 0;
}
