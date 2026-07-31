#include <cstdint>
#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>

#define N 0x3E80
#define THREADS_PER_BLOCK 0x200

__global__ void reduce(const uint32_t *in, uint32_t *out, const size_t n) {
  extern __shared__ uint32_t sdata[];

  unsigned int tid = threadIdx.x;
  unsigned int idx = blockIdx.x * blockDim.x + tid;

  if (idx < n) {
    sdata[tid] = in[idx];
  } else {
    sdata[tid] = (uint32_t)0;
  }

  __syncthreads();

  for (unsigned int stride = blockDim.x / 2; stride > 0; stride >>= 1) {
    if (tid < stride)
      sdata[tid] += sdata[tid + stride];

    __syncthreads();
  }

  if (tid == 0)
    out[blockIdx.x] = sdata[0];
}

int main(void) {
  const size_t bytes = N * sizeof(uint32_t);
  const int blocks = (N + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;

  uint32_t *h_slice = (uint32_t *)malloc(bytes);
  uint32_t *h_blocks = (uint32_t *)malloc(blocks * sizeof(uint32_t));

  for (size_t i = 0; i < N; i++) {
    h_slice[i] = i;
  }

  uint32_t *d_slice = NULL;
  uint32_t *d_blocks = NULL;

  cudaMalloc((void **)&d_slice, bytes);
  cudaMalloc((void **)&d_blocks, blocks * sizeof(uint32_t));

  cudaMemcpy(d_slice, h_slice, bytes, cudaMemcpyHostToDevice);

  reduce<<<blocks, THREADS_PER_BLOCK, THREADS_PER_BLOCK * sizeof(uint32_t)>>>(
      d_slice, d_blocks, N);

  cudaDeviceSynchronize();
  cudaMemcpy(h_blocks, d_blocks, blocks * sizeof(uint32_t),
             cudaMemcpyDeviceToHost);

  uint32_t sum = 0;
  for (int i = 0; i < blocks; i++) {
    sum += h_blocks[i];
  }

  printf("SUM: %d\n", sum);

  cudaFree(d_slice);
  cudaFree(d_blocks);

  free(h_slice);
  free(h_blocks);

  return 0;
}
