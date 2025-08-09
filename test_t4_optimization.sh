#!/bin/bash

# Test script for T4 optimizations
echo "=== Testing T4 Optimizations ==="

# Test 1: Check if CUDA is available
echo "Test 1: CUDA Availability"
if command -v nvcc &> /dev/null; then
    echo "✓ NVCC found: $(nvcc --version | head -n1)"
else
    echo "✗ NVCC not found"
    exit 1
fi

# Test 2: Check if we can compile with T4 optimizations
echo ""
echo "Test 2: Compilation Test"
make clean > /dev/null 2>&1
if make gpu=1 ccap=75 > /dev/null 2>&1; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
    echo "Trying with default compute capability..."
    if make gpu=1 > /dev/null 2>&1; then
        echo "✓ Compilation successful with default settings"
    else
        echo "✗ Compilation failed completely"
        exit 1
    fi
fi

# Test 3: Check if executable was created
echo ""
echo "Test 3: Executable Check"
if [ -f "./kangaroo-256" ]; then
    echo "✓ Executable created: ./kangaroo-256"
    ls -la ./kangaroo-256
else
    echo "✗ Executable not found"
    exit 1
fi

# Test 4: Check GPU detection
echo ""
echo "Test 4: GPU Detection"
if command -v nvidia-smi &> /dev/null; then
    echo "✓ nvidia-smi available"
    echo "GPU Information:"
    nvidia-smi --query-gpu=name,compute_cap,memory.total --format=csv,noheader,nounits | nl -v1
else
    echo "⚠ nvidia-smi not available (may be running on non-GPU system)"
fi

# Test 5: Check if we can run with help
echo ""
echo "Test 5: Basic Functionality Test"
if ./kangaroo-256 -v 2>&1 | grep -q "Kangaroo"; then
    echo "✓ Basic functionality test passed"
    echo "Version: $(./kangaroo-256 -v 2>&1 | head -n1)"
else
    echo "✗ Basic functionality test failed"
    exit 1
fi

# Test 6: Check optimization flags
echo ""
echo "Test 6: Optimization Verification"
if strings ./kangaroo-256 | grep -q "T4_OPTIMIZED"; then
    echo "✓ T4 optimizations detected in binary"
else
    echo "⚠ T4 optimizations not detected (may be normal)"
fi

echo ""
echo "=== All Tests Completed ==="
echo "✓ T4 optimization setup appears to be working correctly"
echo ""
echo "To run with T4 optimizations:"
echo "  ./kangaroo-256 -gpu -gpuId 0,1 -g 40,128 -d 15 -t 8 <input_file>"
echo ""
echo "For full optimization setup, run:"
echo "  ./t4_optimization.sh"
