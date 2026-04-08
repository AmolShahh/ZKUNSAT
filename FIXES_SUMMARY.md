# ZKUNSAT Repository - Build Fixes Summary

## Overview
This document summarizes all the issues identified and fixed in the ZKUNSAT repository to make it buildable and runnable.

## Issues Identified and Fixed

### 1. ✅ CMakeLists.txt - Hardcoded Library Paths (CRITICAL)

**Issue**: The CMakeLists.txt had hardcoded paths to `/home/ubuntu/emp-tool` and `/home/ubuntu/emp-zk` which don't exist in most systems.

**Fix Applied**:
- Updated CMakeLists.txt to search for emp-tool and emp-zk in multiple common locations:
  - `~/emp-tool`, `~/dev/emp-tool`
  - `/opt/emp-tool`, `/usr/local/emp-tool`
  - `/home/ubuntu/emp-tool`
  - Custom paths via environment variables
- Added helpful warning messages when libraries aren't found
- Added cache variables `EMP_TOOL_DIR` and `EMP_ZK_DIR` for manual configuration
- Made the build system more flexible and user-friendly

**Files Modified**: [CMakeLists.txt](CMakeLists.txt)

---

### 2. ✅ commons.h - Pragma Syntax Error

**Issue**: Line 4 had `#pragma once;` with an incorrect semicolon.

**Error**: This would cause a compilation warning or error depending on the compiler.

**Fix Applied**:
- Changed `#pragma once;` to `#pragma once`

**Files Modified**: [commons.h](commons.h#L4)

---

### 3. ✅ Missing parse_party_and_port() Function (CRITICAL)

**Issue**: [main.cpp](main.cpp#L19) calls `parse_party_and_port()` but this function was never defined.

**Error**: Undefined reference/symbol error during linking.

**Fix Applied**:
- Implemented `parse_party_and_port()` function in [utils.h](utils.h#L364-L382)
- Function parses command-line arguments for party (1=ALICE, 2=BOB) and port number
- Added input validation for party type and port range
- Provides helpful error messages for invalid arguments

**Implementation Details**:
```cpp
inline void parse_party_and_port(char** argv, int* party, int* port) {
    if (argv[1] == NULL || argv[2] == NULL) {
        error("Usage: program <party> <port> [args...]\n");
    }
    *party = atoi(argv[1]);
    *port = atoi(argv[2]);
    
    if (*party != ALICE && *party != BOB) {
        error("Party must be 1 (ALICE) or 2 (BOB)\n");
    }
    if (*port < 1024 || *port > 65535) {
        error("Port must be between 1024 and 65535\n");
    }
}
```

**Files Modified**: [utils.h](utils.h#L364-L382)

---

### 4. ✅ Code Organization and Documentation

**Added Files**:
- **README.md** - Comprehensive build and usage instructions
- **setup.sh** - Automated setup script to detect libraries and configure build
- **FIXES_SUMMARY.md** - This document

**Purpose**: 
- Help users understand project structure and dependencies
- Provide clear build instructions for different scenarios
- Create automation to make setup easier

---

## External Dependencies Required

The project depends on external libraries that must be installed separately:

### Critical Dependencies:
1. **emp-tool** - EMP Toolkit secure computation library
   - Repository: https://github.com/emp-toolkit/emp-tool
   - Build instructions in README.md

2. **emp-zk** - Zero-knowledge proof extensions for emp-tool
   - Repository: https://github.com/emp-toolkit/emp-zk
   - Includes required extensions like ram-zk and emp-vole-f2k

3. **NTL (Number Theory Library)** - For GF(2^k) field operations
   - Website: https://libntl.org/
   - Ubuntu: `sudo apt-get install libntl-dev`

### Why These Dependencies Aren't Included:
- These are large external libraries (emp-toolkit)
- They have their own build systems and configurations
- They may have system-specific optimizations
- Including them would significantly bloat the repository

---

## Code Quality Improvements

### What Was Fixed:
1. Build system flexibility and platform independence
2. Missing function implementation
3. Syntax errors
4. Documentation and setup assistance

### What Remains as Expected:
1. Empty source files (`clause.cpp`, `clauseRAM.cpp`) - These are intentionally header-only implementations with all code in .h files
2. External library dependencies - These are required by design for secure computation
3. Network communication code - Part of emp-tool and emp-zk frameworks

---

## Building the Project

### Quick Start:
```bash
# Using the setup script (Linux/macOS/WSL)
chmod +x setup.sh
./setup.sh

# Manual build (after installing dependencies)
cmake .
make
```

### With Custom Paths:
```bash
cmake . \
  -DEMP_TOOL_DIR=/path/to/emp-tool \
  -DEMP_ZK_DIR=/path/to/emp-zk
make
```

---

## Verification Checklist

- ✅ CMakeLists.txt properly configured with flexible paths
- ✅ Pragma syntax errors fixed
- ✅ All required functions implemented
- ✅ Build system properly handling missing dependencies with helpful messages
- ✅ Documentation provided for users
- ✅ Setup automation script included

---

## Testing

### Next Steps to Verify Build:
After installing emp-tool and emp-zk:
```bash
cd /path/to/ZKUNSAT
cmake .
make
```

Expected output:
```
[100%] Built target test
```

### Running Tests:
Once built successfully:
```bash
# Terminal 1 (ALICE):
./test 1 12345 127.0.0.1 /path/to/proof.prf.unfold

# Terminal 2 (BOB):
./test 2 12345 127.0.0.1 /path/to/proof.prf.unfold
```

---

## References

- EMP Toolkit Documentation: https://github.com/emp-toolkit/
- NTL library: https://libntl.org/
- CMake Documentation: https://cmake.org/
