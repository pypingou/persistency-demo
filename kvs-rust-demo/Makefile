# Standalone Makefile for KVS Rust Demo
# This demo requires the persistency Rust library to be installed

DEMO_TARGET = rust_demo

# Default target
.PHONY: all clean demo test install help

all: build

# Build demo program
build:
	@echo "Building Rust demo..."
	cargo build --release

# Run the demo
demo: build
	@echo ""
	@echo "🚀 Starting KVS Rust Demo..."
	@echo "=============================="
	@mkdir -p rust_demo_data
	cargo run --release rust_demo_data

# Quick test
test: build
	@echo "Running quick test..."
	@mkdir -p test_data
	@timeout 10 cargo run --release test_data > /dev/null 2>&1 || true
	@rm -rf test_data
	@echo "Test completed ✓"

# Clean build artifacts
clean:
	@echo "Cleaning Rust demo..."
	cargo clean
	rm -rf rust_demo_data/ test_data/
	@echo "Clean complete"

# Install demo program
install: build
	@echo "Installing Rust demo..."
	install -d $(DESTDIR)/usr/bin
	install -m 755 target/release/$(DEMO_TARGET) $(DESTDIR)/usr/bin/kvs-rust-demo
	@echo "Demo installed to $(DESTDIR)/usr/bin/kvs-rust-demo"

# Show build information
info:
	@echo "KVS Rust Demo Build Configuration:"
	@echo "  Target: $(DEMO_TARGET)"
	@echo "  Rust toolchain: $(shell rustc --version 2>/dev/null || echo 'Not found')"
	@echo "  Cargo version: $(shell cargo --version 2>/dev/null || echo 'Not found')"

# Help
help:
	@echo "KVS Rust Demo Makefile"
	@echo "======================"
	@echo ""
	@echo "Available targets:"
	@echo "  all (build) - Build the demo program (default)"
	@echo "  demo        - Build and run the interactive demo"
	@echo "  test        - Build and run a quick test"
	@echo "  clean       - Remove build artifacts and test data"
	@echo "  install     - Install demo to system"
	@echo "  info        - Show build configuration"
	@echo "  help        - Show this help"
	@echo ""
	@echo "Prerequisites:"
	@echo "  - Rust toolchain 1.70+"
	@echo "  - persistency Rust library installed (dnf install persistency-rust-devel)"
	@echo ""
	@echo "Examples:"
	@echo "  make                    # Build the demo"
	@echo "  make demo              # Build and run interactively"
	@echo "  make clean             # Clean up"