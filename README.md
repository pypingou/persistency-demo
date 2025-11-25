# Persistency Demo Project

This project contains comprehensive demonstration programs for the Eclipse Score persistency Key-Value Storage (KVS) library. It showcases the capabilities of the persistency library through both C++ and Rust implementations.

## Overview

The persistency library provides a thread-safe, persistent key-value storage solution with support for:

- Multiple data types (integers, floats, booleans, strings, arrays, objects)
- JSON-based persistence
- Snapshot management and restoration
- Default values handling with validation
- Thread-safe operations
- Builder pattern for easy configuration

## Project Structure

```
persistency-demo/
├── README.md                 # This file
├── Makefile                  # Main build system
├── persistency-demo.spec     # RPM packaging specification
├── kvs-cpp-demo/            # C++ demonstration
│   ├── kvs_demo.cpp         # Main C++ demo program
│   ├── simple_demo.sh       # Shell-based demo script
│   └── Makefile             # C++ build system
└── kvs-rust-demo/           # Rust demonstration
    ├── rust_demo.rs         # Main Rust demo program
    ├── Cargo.toml           # Rust project configuration
    └── Makefile             # Rust build system
```

## Prerequisites

### For C++ Demo
- C++17 compatible compiler (GCC 8+ or Clang 7+)
- persistency C++ development libraries
- GNU Make

### For Rust Demo
- Rust toolchain 1.70 or later
- persistency Rust library
- Cargo build system

### Installation via RPM (Fedora/RHEL)
```bash
# Install persistency libraries
sudo dnf install persistency-cpp-devel persistency-rust-devel

# Install build tools
sudo dnf install gcc-c++ make rust cargo
```

## Building

### Build Both Demos
```bash
make
```

### Build Individual Demos
```bash
make cpp        # Build C++ demo only
make rust       # Build Rust demo only
```

## Running Demonstrations

### Interactive Demos
```bash
make demo       # Run both demos interactively
make cpp-demo   # Run C++ demo only
make rust-demo  # Run Rust demo only
```

### Simple Shell Demo
```bash
make simple-demo    # Run shell-based demo (no compilation needed)
```

## Demo Features

Both demonstrations showcase identical functionality:

### 1. Basic Operations
- Creating KVS instances with different configurations
- Setting and getting values of various data types
- Key existence checks
- Key removal operations
- Data persistence

### 2. Data Types Support
- **Integers**: i32, u32, i64, u64
- **Floating-point**: f64 with precision control
- **Boolean**: true/false values
- **String**: UTF-8 text data
- **Null**: null/nil values
- **Arrays**: Ordered collections of values
- **Objects**: Key-value mappings (nested structures)

### 3. Advanced Features
- **Snapshots**: Automatic snapshot creation during flush operations
- **Snapshot Restoration**: Rollback to previous states
- **Default Values**: Pre-configured fallback values with validation
- **Reset Operations**: Clear storage or reset individual keys

### 4. File Operations
- JSON-based persistence to disk
- Automatic directory creation
- Data integrity validation

## Testing

```bash
make test       # Run tests for both demos
```

## Installation

```bash
make install    # Install demos to /usr/bin/
```

Installed programs:
- `kvs-cpp-demo` - C++ demonstration program
- `kvs-rust-demo` - Rust demonstration program

## Building RPM Packages

```bash
# Create source tarball
tar czf persistency-demo-0.1.0.tar.gz persistency-demo/

# Build RPM packages
rpmbuild -ta persistency-demo-0.1.0.tar.gz
```

This creates:
- `persistency-demo` - Base package with documentation
- `persistency-demo-cpp` - C++ demonstration program
- `persistency-demo-rust` - Rust demonstration program

## Development

### C++ API Usage
```cpp
#include "persistency/kvsbuilder.hpp"

// Create KVS instance
auto kvs_result = KvsBuilder(InstanceId(1))
    .need_defaults_flag(false)
    .need_kvs_flag(false)
    .dir("./data")
    .build();

if (kvs_result) {
    Kvs kvs = std::move(kvs_result.value());

    // Store different data types
    kvs.set_value("temperature", KvsValue(23.5));
    kvs.set_value("active", KvsValue(true));
    kvs.set_value("name", KvsValue("sensor-01"));

    // Read with type safety
    auto temp = kvs.get_value("temperature");

    // Create snapshot
    kvs.flush();
}
```

### Rust API Usage
```rust
use rust_kvs::prelude::*;

// Create KVS instance
let builder = KvsBuilder::new(InstanceId(1))
    .dir("./data".to_string())
    .kvs_load(KvsLoad::Optional);
let kvs = builder.build()?;

// Store different data types
kvs.set_value("temperature", 23.5f64)?;
kvs.set_value("active", true)?;
kvs.set_value("name", "sensor-01")?;

// Read values
let temp: f64 = kvs.get_value("temperature")?;

// Create snapshot
kvs.flush()?;
```

## Troubleshooting

### Common Issues

1. **Missing persistency libraries**
   ```bash
   sudo dnf install persistency-cpp-devel persistency-rust-devel
   ```

2. **Compilation errors**
   - Ensure C++17 support: `gcc --version` (8.0+)
   - Check Rust version: `rustc --version` (1.70+)

3. **Runtime errors**
   - Verify write permissions to demo data directories
   - Check available disk space

### Getting Help

```bash
make help           # Show main help
cd kvs-cpp-demo && make help    # C++ demo help
cd kvs-rust-demo && make help   # Rust demo help
```

## License

Apache License 2.0 - See LICENSE file for details.

## Contributing

This demonstration project is part of the Eclipse Score persistency library. For contributions and issues, please refer to the main persistency project repository.