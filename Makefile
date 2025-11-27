# Main Makefile for Persistency Demo Project
# Builds both C++ and Rust demonstrations

# Project metadata
PROJECT_NAME = persistency-demo
VERSION = 0.1.0
RELEASE = 1

.PHONY: all clean demo test install help cpp rust cpp-demo rust-demo
.PHONY: dist srpm rpm clean-dist

all: cpp rust

# Build both demos
cpp:
	@echo "Building C++ demo..."
	cd kvs-cpp-demo && $(MAKE)

rust:
	@echo "Building Rust demo..."
	cd kvs-rust-demo && $(MAKE) build

# Run demos
demo: cpp-demo rust-demo

cpp-demo: cpp
	@echo ""
	@echo "=== Running C++ Demo ==="
	cd kvs-cpp-demo && $(MAKE) demo

rust-demo: rust
	@echo ""
	@echo "=== Running Rust Demo ==="
	cd kvs-rust-demo && $(MAKE) demo

# Run simple C++ shell demo
simple-demo:
	@echo ""
	@echo "=== Running Simple Shell Demo ==="
	cd kvs-cpp-demo && $(MAKE) simple-demo

# Test both demos
test: cpp rust
	@echo "Testing C++ demo..."
	cd kvs-cpp-demo && $(MAKE) test
	@echo "Testing Rust demo..."
	cd kvs-rust-demo && $(MAKE) test
	@echo "All tests completed ✓"

# Clean both demos
clean: clean-dist
	@echo "Cleaning C++ demo..."
	cd kvs-cpp-demo && $(MAKE) clean
	@echo "Cleaning Rust demo..."
	cd kvs-rust-demo && $(MAKE) clean
	@echo "Clean complete"

# Install both demos
install: cpp rust
	@echo "Installing C++ demo..."
	cd kvs-cpp-demo && $(MAKE) install DESTDIR=$(DESTDIR)
	@echo "Installing Rust demo..."
	cd kvs-rust-demo && $(MAKE) install DESTDIR=$(DESTDIR)
	@echo "Installation complete"

# Show build information
info:
	@echo "Persistency Demo Project Build Information:"
	@echo "=========================================="
	@echo ""
	@echo "C++ Demo:"
	cd kvs-cpp-demo && $(MAKE) info
	@echo ""
	@echo "Rust Demo:"
	cd kvs-rust-demo && $(MAKE) info

# Package distribution targets

# Create source distribution tarball with vendored Rust dependencies
dist: clean-dist
	@echo "Creating source distribution..."
	@mkdir -p dist
	@echo "Copying rust_kvs source into demo project..."
	@cp -r ../persistency/src/rust/rust_kvs ./
	@echo "Creating standalone Cargo.toml for rust_kvs..."
	@echo '[package]' > rust_kvs/Cargo.toml
	@echo 'name = "rust_kvs"' >> rust_kvs/Cargo.toml
	@echo 'version = "0.1.0"' >> rust_kvs/Cargo.toml
	@echo 'edition = "2021"' >> rust_kvs/Cargo.toml
	@echo '' >> rust_kvs/Cargo.toml
	@echo '[dependencies]' >> rust_kvs/Cargo.toml
	@echo 'adler32 = "1.2.0"' >> rust_kvs/Cargo.toml
	@echo 'tinyjson = "2.5.1"' >> rust_kvs/Cargo.toml
	@echo '' >> rust_kvs/Cargo.toml
	@echo '[dev-dependencies]' >> rust_kvs/Cargo.toml
	@echo 'tempfile = "3.20"' >> rust_kvs/Cargo.toml
	@echo "Vendoring Rust dependencies..."
	@cd kvs-rust-demo && cargo vendor vendor --versioned-dirs
	@echo "Cleaning up vendor directory for RPM build..."
	@find kvs-rust-demo/vendor -name ".github" -type d -exec rm -rf {} \; 2>/dev/null || true
	@find kvs-rust-demo/vendor -name "*.yml" -delete 2>/dev/null || true
	@find kvs-rust-demo/vendor -name "*.yaml" -delete 2>/dev/null || true
	@find kvs-rust-demo/vendor -name ".gitignore" -delete 2>/dev/null || true
	@echo "Updating cargo checksums after cleanup..."
	@for dir in kvs-rust-demo/vendor/*/; do \
		if [ -f "$$dir/.cargo-checksum.json" ]; then \
			echo "Updating checksum for $$dir"; \
			(cd "$$dir" && python3 $(CURDIR)/fix_checksum.py); \
		fi; \
	done
	@find kvs-rust-demo/vendor -type f -exec chmod 644 {} + 2>/dev/null || true
	@find kvs-rust-demo/vendor -type d -exec chmod 755 {} + 2>/dev/null || true
	@echo "Creating tarball with vendored dependencies..."
	@tar --exclude='dist' --exclude='*.rpm' --exclude='*.tar.gz' \
	     --exclude='.git*' --exclude='target' --exclude='*.o' \
	     --exclude='*_data' --exclude='test_data' \
	     --transform='s|^|$(PROJECT_NAME)-$(VERSION)/|' \
	     -czf dist/$(PROJECT_NAME)-$(VERSION).tar.gz \
	     *
	@echo "Source tarball created: dist/$(PROJECT_NAME)-$(VERSION).tar.gz"

# Build source RPM
srpm: dist
	@echo "Building source RPM..."
	@set -e; \
	TMPDIR=$$(mktemp -d); \
	echo "Using temp directory: $$TMPDIR"; \
	cp dist/$(PROJECT_NAME)-$(VERSION).tar.gz "$$TMPDIR"/; \
	cp $(PROJECT_NAME).spec "$$TMPDIR"/; \
	(cd "$$TMPDIR" && rpmbuild -bs --define "_topdir $$TMPDIR" $(PROJECT_NAME).spec); \
	cp "$$TMPDIR"/*.src.rpm .; \
	rm -rf "$$TMPDIR"; \
	echo "Source RPM built successfully"; \
	ls -la *.src.rpm

# Build binary RPMs from source RPM
rpm: srpm
	@echo "Building binary RPMs..."
	@set -e; \
	TMPDIR=$$(mktemp -d); \
	echo "Using temp directory: $$TMPDIR"; \
	cp *.src.rpm "$$TMPDIR"/; \
	(cd "$$TMPDIR" && rpmbuild --rebuild --define "_topdir $$TMPDIR" *.src.rpm); \
	find "$$TMPDIR" -name "*.rpm" -not -name "*.src.rpm" -exec cp {} . \;; \
	rm -rf "$$TMPDIR"; \
	echo "Binary RPMs built successfully"; \
	ls -la *.rpm

# Clean distribution artifacts
clean-dist:
	@echo "Cleaning distribution artifacts..."
	@rm -rf dist/
	@rm -f $(PROJECT_NAME)-$(VERSION).tar.gz
	@rm -f *.rpm
	@echo "Distribution artifacts cleaned"

# Help
help:
	@echo "Persistency Demo Project Makefile"
	@echo "================================="
	@echo ""
	@echo "This project contains demonstration programs for the Eclipse Score"
	@echo "persistency Key-Value Storage (KVS) library in both C++ and Rust."
	@echo ""
	@echo "Available targets:"
	@echo "  all         - Build both C++ and Rust demos (default)"
	@echo "  cpp         - Build C++ demo only"
	@echo "  rust        - Build Rust demo only"
	@echo "  demo        - Build and run both demos interactively"
	@echo "  cpp-demo    - Build and run C++ demo"
	@echo "  rust-demo   - Build and run Rust demo"
	@echo "  simple-demo - Run shell-based C++ demo (no compilation)"
	@echo "  test        - Build and run quick tests for both demos"
	@echo "  clean       - Remove all build artifacts"
	@echo "  install     - Install both demos to system"
	@echo "  info        - Show build configuration for both demos"
	@echo "  help        - Show this help"
	@echo ""
	@echo "Package distribution targets:"
	@echo "  dist        - Create source distribution tarball"
	@echo "  srpm        - Build source RPM package"
	@echo "  rpm         - Build both source and binary RPM packages"
	@echo "  clean-dist  - Remove distribution artifacts"
	@echo ""
	@echo "Prerequisites:"
	@echo "  - C++17 compatible compiler (for C++ demo)"
	@echo "  - Rust toolchain 1.70+ (for Rust demo)"
	@echo "  - persistency C++ libraries (dnf install persistency-cpp-devel)"
	@echo "  - persistency Rust library (dnf install persistency-rust-devel)"
	@echo "  - rpmbuild (for RPM packaging)"
	@echo ""
	@echo "Examples:"
	@echo "  make                    # Build both demos"
	@echo "  make cpp               # Build C++ demo only"
	@echo "  make demo              # Build and run both demos"
	@echo "  make simple-demo       # Run shell-based demo"
	@echo "  make dist              # Create source tarball"
	@echo "  make srpm              # Build source RPM"
	@echo "  make rpm               # Build source and binary RPMs"
	@echo "  make clean             # Clean up everything"
	@echo ""
	@echo "Individual demo directories:"
	@echo "  kvs-cpp-demo/   - C++ demonstration"
	@echo "  kvs-rust-demo/  - Rust demonstration"