# ZKUNSAT Development Guide

## For Contributors

This guide helps contributors set up their development environment and understand the codebase.

## Quick Setup

### 1. Install Dependencies

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install build-essential cmake g++ libntl-dev

# macOS (with Homebrew)
brew install cmake ntl

# Then install emp-tool and emp-zk from https://github.com/emp-toolkit/
```

### 2. Setup Development Environment

```bash
# Clone and setup
git clone https://github.com/your-repo/ZKUNSAT.git
cd ZKUNSAT
chmod +x setup.sh
./setup.sh

# Build
cd build
make
```

## Project Structure

```
ZKUNSAT/
├── src/                     # Source files
│   ├── main.cpp             # Entry point
│   ├── clause.{h,cpp}       # Clause operations
│   ├── polynomial.{h,cpp}   # GF(2^k) polynomial arithmetic
│   ├── clauseRAM.{h,cpp}    # Memory-based clause storage
│   ├── commons.h            # Global declarations
│   └── utils.h              # Utility functions
├── prover_backend/          # Proof generation scripts
├── benchmark_*/             # Test benchmarks
├── CMakeLists.txt           # Build configuration
├── README.md                # User guide
├── FIXES_SUMMARY.md         # Build fix documentation
├── CONTRIBUTING.md          # This file
└── setup.sh                 # Setup automation
```

## Code Organization

### Header Files (.h)
- Most implementation is in header files (template-heavy code)
- Intended for header-only library usage
- Reduces compilation time by avoiding link-time dependencies

### Source Files (.cpp)
- Minimal `.cpp` files - mostly just includes
- Large cpp files have full implementations (polynomial.cpp)
- Source organization follows class hierarchy

## Key Concepts

### Finite Field Arithmetic (GF(2^k))
- Uses NTL library for field operations
- GF2E for field elements
- GF2EX for polynomials
- gfmul() for multiplication

### Two-Party Computation
- Built on emp-tool framework
- ALICE = party 1 (prover/input provider)
- BOB = party 2 (verifier)

### Zero-Knowledge Proofs
- Proves SAT formula unsatisfiability without revealing proof details
- Uses secure multi-party computation
- RAM-based clause access with integrity verification

## Building and Testing

### Building
```bash
cd build
make                    # Standard build
make clean             # Remove build artifacts
make VERBOSE=1         # Verbose build output
```

### Debugging
```bash
# Build with debug symbols
cmake . -DCMAKE_BUILD_TYPE=Debug
make

# Run with debugger
gdb ./test
```

## Code Style

### Naming Conventions
- Classes: PascalCase (e.g., `clause`, `polynomial`)
- Functions: snake_case (e.g., `fill_data_and_mac`)
- Constants: UPPER_CASE (e.g., `VAL_SZ`, `DEGREE`)
- Macros: UPPER_CASE (e.g., `INDEX_SZ`)

### Comments
- Include comments for non-obvious logic
- Document function parameters and return values
- Explain performance-critical sections

### Code Formatting
- Use 4-space indentation
- Keep lines under 100 characters where possible
- Use meaningful variable names

## Common Development Tasks

### Adding a New Feature
1. Create feature branch: `git checkout -b feature/my-feature`
2. Implement changes with comments
3. Update README.md if needed
4. Test thoroughly
5. Commit with clear message: `git commit -m "Add feature: description"`
6. Create pull request

### Fixing a Bug
1. Create issue if not exists, note the issue number
2. Create bugfix branch: `git checkout -b bugfix/issue-123`
3. Add test to reproduce bug
4. Implement fix
5. Verify test passes
6. Update FIXES_SUMMARY.md if it's a build/setup issue
7. Commit: `git commit -m "Fix #123: description"`

### Improving Documentation
1. Identify missing or unclear documentation
2. Update README.md, FIXES_SUMMARY.md, or create guide
3. Include code examples where helpful
4. Keep writing clear and concise

## Performance Considerations

### Hot Paths
- `polynomial::Evaluate()` - Called frequently, performance critical
- `clauseRAM::get()` - Memory access tracking
- Field multiplication (`gfmul()`)

### Memory
- Clause data stored in polynomial form
- MAC (Message Authentication Code) stored separately
- Pre-allocated buffers via SVOLE

## Troubleshooting

### Build Issues
- Check apt/brew dependencies installed
- Verify emp-tool and emp-zk paths in CMakeLists.txt
- See FIXES_SUMMARY.md for common issues

### Runtime Issues
- Ensure proper command-line arguments
- Check network connectivity between ALICE and BOB
- Verify proof file format

### Debugging Tips
- Use `-DCMAKE_BUILD_TYPE=Debug` for better debugging
- Add debug output with `cout` (remember to flush with `endl`)
- Use `gdb` to step through code

## Resources

- [EMP Toolkit](https://github.com/emp-toolkit/)
- [NTL Library](https://libntl.org/)
- [CMake Documentation](https://cmake.org/help/documentation.html)

## Questions or Issues?

- Check FIXES_SUMMARY.md for known issues
- Review README.md for setup instructions
- Consult code comments for implementation details

## License

See LICENSE file for terms
