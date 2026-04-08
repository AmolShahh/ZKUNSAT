# ZKUNSAT - Zero-Knowledge Unsatisfiability Proof System

This is a C++ implementation of a zero-knowledge proof system for SAT unsatisfiability proofs.

## Project Structure

```
├── main.cpp              # Main program entry point
├── clause.h/cpp          # Clause representation and operations
├── polynomial.h/cpp      # Polynomial arithmetic operations
├── clauseRAM.h/cpp       # RAM-based clause storage and verification
├── commons.h             # Global variable declarations and includes
├── utils.h               # Utility functions and helpers
├── CMakeLists.txt        # CMake build configuration
├── prover_backend/       # Python scripts for proof generation
└── benchmark_*/          # Benchmark test cases
```

## Dependencies

This project requires the following libraries:

1. **emp-tool** - Secure Multi-party Computation Library
   - GitHub: https://github.com/emp-toolkit/emp-tool
   - Version: HEAD or recent stable

2. **emp-zk** - Zero-Knowledge Proof Extensions for emp-tool
   - GitHub: https://github.com/emp-toolkit/emp-zk
   - Includes: ram-zk and emp-vole-f2k extensions

3. **NTL (Number Theory Library)** - For GF(2^k) operations
   - Website: https://libntl.org/

4. **Standard C++ libraries** with C++14 support

## Build Instructions

### Prerequisites

1. Install NTL:
```bash
sudo apt-get install libntl-dev
# or from source: https://libntl.org/
```

2. Install emp-tool, emp-zk
```bash
wget https://raw.githubusercontent.com/emp-toolkit/emp-readme/master/scripts/install.py
python3 install.py --deps --tool --ot --zk
```

### Building the Project

#### Standard Build (assuming libraries installed to system paths):
```bash
cd /path/to/ZKUNSAT
cmake .
make
```

#### Custom Library Paths:
If the emp libraries are not installed to standard system paths, specify them manually:
```bash
cmake . \
  -DEMP_TOOL_DIR=/path/to/emp-tool \
  -DEMP_ZK_DIR=/path/to/emp-zk
make
```

#### Build with Specific Compiler:
```bash
cmake . -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++
make
```

## Running the Program

The program requires two parties (ALICE and BOB) to run in a two-party computation setting:

```bash
# Terminal 1 (ALICE - Party 1):
./test 1 12345 127.0.0.1 /path/to/proof.prf.unfold

# Terminal 2 (BOB - Party 2):
./test 2 12345 127.0.0.1 /path/to/proof.prf.unfold
```

### Command-line Arguments:
- `<party>`: 1 for ALICE, 2 for BOB
- `<port>`: Port number for communication (1024-65535)
- `<host>`: IP address/hostname (BOB only, ALICE uses local server)
- `<proof_file>`: Path to the proof file (for ALICE, BOB can use any path)

## Proof File Format

The proof file should contain SAT resolution proofs in the format:
```
clause: <literal1> <literal2> ... support: <index1> <index2> ... pivot: <pivot_value> ... end:
...
DEGREE: <maximum_clause_size>
```

Example files are provided in the `benchmark_*/` directories.

## Project Features

1. **Zero-Knowledge Proofs**: Verifies SAT unsatisfiability without revealing the proof
2. **GF(2^k) Arithmetic**: Uses finite field arithmetic for secure computation
3. **RAM-based Verification**: Efficient memory-based clause storage and access
4. **Secure Multi-party Computation**: Built on emp-zk framework for privacy

## Troubleshooting

### CMake Configuration Issues

If you see warnings about library paths not found:
```
WARNING: emp-tool directory not found at: /home/ubuntu/emp-tool
```

This is expected. Specify the correct paths:
```bash
cmake . -DEMP_TOOL_DIR=$HOME/emp-tool -DEMP_ZK_DIR=$HOME/emp-zk
```

### Compilation Errors

**Error: `fatal error: emp-zk/emp-zk.h: No such file or directory`**
- Solution: Ensure emp-zk is properly installed or specify EMP_ZK_DIR correctly

**Error: `undefined reference to 'emp' function`**
- Solution: Check that all emp libraries are linked in CMakeLists.txt

### Runtime Errors

**Error: Connection refused**
- Solution: Ensure both ALICE and BOB are running with the same port and ALICE is started first

**Error: Proof verification failed**
- Solution: Verify the proof file exists and is in the correct format

## Code Fixes Applied

1. ✅ Fixed `#pragma once;` syntax error in commons.h
2. ✅ Added configurable CMakeLists.txt with multiple library search paths
3. ✅ Implemented missing `parse_party_and_port()` function
4. ✅ Updated build configuration for flexibility

## References

- EMP Toolkit: https://github.com/emp-toolkit/
- NTL Documentation: https://libntl.org/
- Paper: Related work on secure ZK proofs for SAT
