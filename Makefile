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

# Create source distribution tarball
dist: clean-dist
	@echo "Creating source distribution..."
	@mkdir -p dist
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
	@TMPDIR=$$(mktemp -d) && \
	mkdir -p "$$TMPDIR"/{SOURCES,SPECS,BUILD,SRPMS,RPMS} && \
	cp dist/$(PROJECT_NAME)-$(VERSION).tar.gz "$$TMPDIR"/SOURCES/ && \
	cp $(PROJECT_NAME).spec "$$TMPDIR"/SPECS/ && \
	rpmbuild -bs --define "_topdir $$TMPDIR" "$$TMPDIR"/SPECS/$(PROJECT_NAME).spec && \
	cp "$$TMPDIR"/SRPMS/$(PROJECT_NAME)-$(VERSION)-$(RELEASE)*.src.rpm . && \
	rm -rf "$$TMPDIR"
	@echo "Source RPM built successfully"
	@ls -la $(PROJECT_NAME)-$(VERSION)-$(RELEASE)*.src.rpm

# Build binary RPMs from source RPM
rpm: srpm
	@echo "Building binary RPMs..."
	@TMPDIR=$$(mktemp -d) && \
	mkdir -p "$$TMPDIR"/{SOURCES,SPECS,BUILD,SRPMS,RPMS} && \
	cp $(PROJECT_NAME)-$(VERSION)-$(RELEASE)*.src.rpm "$$TMPDIR"/SRPMS/ && \
	rpmbuild --rebuild --define "_topdir $$TMPDIR" "$$TMPDIR"/SRPMS/$(PROJECT_NAME)-$(VERSION)-$(RELEASE)*.src.rpm && \
	cp "$$TMPDIR"/RPMS/*/*.rpm . && \
	rm -rf "$$TMPDIR"
	@echo "Binary RPMs built successfully"
	@ls -la $(PROJECT_NAME)*-$(VERSION)-$(RELEASE)*.rpm

# Clean distribution artifacts
clean-dist:
	@echo "Cleaning distribution artifacts..."
	@rm -rf dist/
	@rm -f $(PROJECT_NAME)-$(VERSION).tar.gz
	@rm -f $(PROJECT_NAME)*-$(VERSION)-$(RELEASE)*.rpm
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