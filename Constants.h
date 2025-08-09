#ifndef CONSTANTSH
#define CONSTANTSH

// Release number
#define RELEASE "2.3-T4-OPTIMIZED"

// Use symmetry
//#define USE_SYMMETRY

// Number of random jumps - optimized for T4
// T4 has 40 SMs, so we use 40 jumps for better distribution
#define NB_JUMP 40

// GPU group size - optimized for T4 (40 SMs, 2560 cores)
// T4 has 64 cores per SM, so 128 threads per group works well
#define GPU_GRP_SIZE 128

// GPU number of run per kernel call - optimized for T4
// Increased for better occupancy and reduced kernel launch overhead
#define NB_RUN 96

// Kangaroo type
#define TAME 0  // Tame kangaroo
#define WILD 1  // Wild kangaroo

// SendDP Period in sec
#define SEND_PERIOD 2.0

// Timeout before closing connection idle client in sec
#define CLIENT_TIMEOUT 3600.0

// Number of merge partition
#define MERGE_PART 256

// T4-specific optimizations
#define T4_OPTIMIZED 1

// Memory alignment for T4
#define MEMORY_ALIGNMENT 256

// Stream count for multi-GPU
#define MAX_STREAMS 4

#endif //CONSTANTSH
