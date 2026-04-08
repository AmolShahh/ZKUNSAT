#!/bin/bash
# Setup and build script for ZKUNSAT project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== ZKUNSAT Build Setup ===${NC}"
echo ""

# Check for required commands
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed${NC}"
        return 1
    fi
}

# Check prerequisites
echo "Checking prerequisites..."
check_command cmake || { echo "Please install cmake"; exit 1; }
check_command g++ || { echo "Please install g++"; exit 1; }

# Check for NTL
if [ ! -f "/usr/include/NTL/GF2EX.h" ] && [ ! -f "/usr/local/include/NTL/GF2EX.h" ]; then
    echo -e "${YELLOW}Warning: NTL may not be installed. Install with: sudo apt-get install libntl-dev${NC}"
fi

echo -e "${GREEN}✓ Basic prerequisites found${NC}"
echo ""

# Check for emp libraries
EMP_TOOL_DIR=""
EMP_ZK_DIR=""

# Search for emp-tool
echo "Searching for emp-tool..."
for path in \
    ~/emp-tool \
    ~/dev/emp-tool \
    /opt/emp-tool \
    /usr/local/emp-tool \
    /usr/emp-tool \
    /home/ubuntu/emp-tool; do
    if [ -d "$path" ]; then
        EMP_TOOL_DIR=$(cd "$path" && pwd)
        echo -e "${GREEN}✓ Found emp-tool at: $EMP_TOOL_DIR${NC}"
        break
    fi
done

# Search for emp-zk
echo "Searching for emp-zk..."
for path in \
    ~/emp-zk \
    ~/dev/emp-zk \
    /opt/emp-zk \
    /usr/local/emp-zk \
    /usr/emp-zk \
    /home/ubuntu/emp-zk; do
    if [ -d "$path" ]; then
        EMP_ZK_DIR=$(cd "$path" && pwd)
        echo -e "${GREEN}✓ Found emp-zk at: $EMP_ZK_DIR${NC}"
        break
    fi
done

if [ -z "$EMP_TOOL_DIR" ] || [ -z "$EMP_ZK_DIR" ]; then
    echo -e "${YELLOW}Warning: emp-tool or emp-zk not found in standard locations${NC}"
    echo ""
    echo "You can:"
    echo "1. Install them to standard locations"
    echo "2. Set environment variables:"
    echo "   export EMP_TOOL_DIR=/path/to/emp-tool"
    echo "   export EMP_ZK_DIR=/path/to/emp-zk"
    echo "3. Manually specify paths when running cmake"
    echo ""
fi

# Create build directory
echo "Creating build directory..."
mkdir -p build
cd build

# Run cmake with optional paths
echo ""
echo "Running CMake..."
if [ ! -z "$EMP_TOOL_DIR" ] && [ ! -z "$EMP_ZK_DIR" ]; then
    cmake .. \
        -DEMP_TOOL_DIR="$EMP_TOOL_DIR" \
        -DEMP_ZK_DIR="$EMP_ZK_DIR" \
        -DCMAKE_BUILD_TYPE=Release
elif [ ! -z "$EMP_TOOL_DIR" ]; then
    cmake .. \
        -DEMP_TOOL_DIR="$EMP_TOOL_DIR" \
        -DCMAKE_BUILD_TYPE=Release
elif [ ! -z "$EMP_ZK_DIR" ]; then
    cmake .. \
        -DEMP_ZK_DIR="$EMP_ZK_DIR" \
        -DCMAKE_BUILD_TYPE=Release
else
    cmake .. -DCMAKE_BUILD_TYPE=Release
fi

echo ""
echo -e "${GREEN}✓ CMake configuration complete${NC}"
echo ""
echo "Now build with: cd build && make"
echo ""
