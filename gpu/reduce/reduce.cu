#include <chrono>
#include <cstdint>
#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>

#define N (1 << 0x1A)
#define THREADS_PER_BLOCK 0x1000

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

  //
  // CPU bench
  //

  auto cpu_start = std::chrono::high_resolution_clock::now();

  uint32_t cpu_sum = 0;
  for (size_t i = 0; i < N; i++) {
    cpu_sum += h_slice[i];
  }

  auto cpu_end = std::chrono::high_resolution_clock::now();
  double cpu_ms =
      std::chrono::duration<double, std::milli>(cpu_end - cpu_start).count();

  //
  // GPU bench
  //

  uint32_t *d_slice = NULL;
  uint32_t *d_blocks = NULL;

  cudaMalloc((void **)&d_slice, bytes);
  cudaMalloc((void **)&d_blocks, blocks * sizeof(uint32_t));

  cudaMemcpy(d_slice, h_slice, bytes, cudaMemcpyHostToDevice);

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  reduce<<<blocks, THREADS_PER_BLOCK, THREADS_PER_BLOCK * sizeof(uint32_t)>>>(
      d_slice, d_blocks, N);

  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float gpu_ms = 0.0f;
  cudaEventElapsedTime(&gpu_ms, start, stop);

  cudaMemcpy(h_blocks, d_blocks, blocks * sizeof(uint32_t),
             cudaMemcpyDeviceToHost);

  uint32_t gpu_sum = 0;
  for (int i = 0; i < blocks; i++) {
    gpu_sum += h_blocks[i];
  }

  printf("CPU Sum        : %u\n", cpu_sum);
  printf("GPU Sum        : %u\n", gpu_sum);
  printf("CPU Time       : %.6f ms\n", cpu_ms);
  printf("GPU Kernel Time: %.6f ms\n", gpu_ms);

  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  cudaFree(d_slice);
  cudaFree(d_blocks);

  free(h_slice);
  free(h_blocks);

  return 0;
}
