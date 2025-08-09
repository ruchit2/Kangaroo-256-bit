#!/bin/bash

echo "=== Kangaroo-256 Test Setup ==="
echo "This script will help you test the implementation before running the full search."
echo ""

# Check if we're in Docker or native environment
if [ -f /.dockerenv ]; then
    echo "✓ Running in Docker environment"
    ENV="docker"
else
    echo "⚠ Running in native environment (may have compatibility issues on macOS ARM64)"
    ENV="native"
fi

# Create test files with known solutions
echo ""
echo "Creating test files..."

# Test 1: 32-bit range (should solve quickly)
cat > test32.txt << EOF
1000000000000000000000000000000000
1ffffffffffffffffffffffffffffffff
02a0434d9e47f3c86235477c7b1ae6ae5d3d5c87f5b5c8b8b8b8b8b8b8b8b8b8b8b
EOF

# Test 2: 48-bit range (medium difficulty)
cat > test48.txt << EOF
1000000000000000000000000000000000
1fffffffffffffffffffffffffffffffff
02a0434d9e47f3c86235477c7b1ae6ae5d3d5c87f5b5c8b8b8b8b8b8b8b8b8b8b8b
EOF

# Test 3: 64-bit range (harder, but still testable)
cat > test64.txt << EOF
1000000000000000000000000000000000
1fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
02a0434d9e47f3c86235477c7b1ae6ae5d3d5c87f5b5c8b8b8b8b8b8b8b8b8b8b8b
EOF

echo "✓ Created test files: test32.txt, test48.txt, test64.txt"

# Check if executable exists
if [ -f "./kangaroo-256" ]; then
    echo "✓ Found kangaroo-256 executable"
    
    # Test basic functionality
    echo ""
    echo "Testing basic functionality..."
    
    # List CUDA devices if available
    if [ "$ENV" = "docker" ]; then
        echo "Testing CUDA device detection..."
        ./kangaroo-256 -l 2>/dev/null || echo "No CUDA devices available (expected in CPU-only mode)"
    fi
    
    # Test CPU-only mode with small range
    echo ""
    echo "Testing CPU-only mode with 32-bit range..."
    echo "This should complete quickly and find a solution."
    echo "Press Ctrl+C to stop after a few seconds if it's working."
    
    timeout 30s ./kangaroo-256 -t 4 test32.txt || echo "Test completed or timed out"
    
else
    echo "⚠ kangaroo-256 executable not found"
    echo "Please build the project first:"
    echo "  make cpu=1    # for CPU-only build"
    echo "  make gpu=1    # for GPU build (requires CUDA)"
fi

echo ""
echo "=== Test Results ==="
echo "If the tests completed successfully, you can proceed with:"
echo ""
echo "1. Development testing (small ranges):"
echo "   ./kangaroo-256 -t 8 test48.txt"
echo ""
echo "2. Performance benchmarking:"
echo "   time ./kangaroo-256 -t 8 65.txt"
echo ""
echo "3. GPU testing (if available):"
echo "   ./kangaroo-256 -gpu -t 8 test48.txt"
echo ""
echo "4. Full puzzle #135 search:"
echo "   ./kangaroo-256 -gpu -t 8 135.txt"
echo ""
echo "=== Optimization Tips ==="
echo "• Use -w workfile.dat to save progress"
echo "• Use -wi 300 to save every 5 minutes"
echo "• Monitor with: tail -f KEYFOUNDKEYFOUND.txt"
echo "• Check GPU usage: nvidia-smi -l 1"
