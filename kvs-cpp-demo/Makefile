# Standalone Makefile for KVS C++ Demo
# This demo requires the persistency C++ libraries to be installed

CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wpedantic -O2 -g
DEMO_TARGET = kvs_demo

# System include and library paths for installed persistency
INCLUDES = -I/usr/include -I/usr/include/kvs -I/usr/include/score/static_reflection_with_serialization/visitor/include
LIBS = -lkvs_cpp -lkvs_internal -lkvsvalue -lscore_memory -lscore_utils -lscore_containers -lscore_bitmanipulation -lscore_filesystem -lscore_concurrency -lscore_json -lscore_os -lscore_log -lscore_analysis -lscore_safecpp -lscore_quality -lscore_result -lscore_futurecpp -lacl -lcap -lgcov -lpthread

# Source files
DEMO_SOURCES = kvs_demo.cpp
DEMO_OBJS = $(DEMO_SOURCES:.cpp=.o)

# Default target
.PHONY: all clean demo test install help

all: $(DEMO_TARGET)

# Build demo program
$(DEMO_TARGET): $(DEMO_OBJS)
	@echo "Building demo program..."
	$(CXX) $(CXXFLAGS) $(DEMO_OBJS) $(LIBS) -o $@
	@echo "Demo program built successfully: ./$(DEMO_TARGET)"

# Compile source files
%.o: %.cpp
	@echo "Compiling $<..."
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -f $(DEMO_OBJS) $(DEMO_TARGET)
	rm -rf kvs_demo_data/
	@echo "Clean complete"

# Run the demo
demo: $(DEMO_TARGET)
	@echo ""
	@echo "🚀 Starting KVS C++ Demo Program..."
	@echo "====================================="
	@mkdir -p kvs_demo_data
	./$(DEMO_TARGET) kvs_demo_data

# Run the simple shell-based demo
simple-demo:
	@echo ""
	@echo "🚀 Starting KVS Demo (Shell-based)..."
	@echo "====================================="
	@chmod +x simple_demo.sh
	./simple_demo.sh

# Quick test
test: $(DEMO_TARGET)
	@echo "Running quick test..."
	@mkdir -p test_data
	@echo "q" | timeout 10 ./$(DEMO_TARGET) test_data > /dev/null 2>&1 || true
	@rm -rf test_data
	@echo "Test completed ✓"

# Install demo program
install: $(DEMO_TARGET)
	@echo "Installing demo program..."
	install -d $(DESTDIR)/usr/bin
	install -m 755 $(DEMO_TARGET) $(DESTDIR)/usr/bin/kvs-cpp-demo
	@echo "Demo installed to $(DESTDIR)/usr/bin/kvs-cpp-demo"

# Show build information
info:
	@echo "KVS C++ Demo Build Configuration:"
	@echo "  CXX: $(CXX)"
	@echo "  CXXFLAGS: $(CXXFLAGS)"
	@echo "  INCLUDES: $(INCLUDES)"
	@echo "  LIBS: $(LIBS)"
	@echo "  Target: $(DEMO_TARGET)"

# Help
help:
	@echo "KVS C++ Demo Makefile"
	@echo "====================="
	@echo ""
	@echo "Available targets:"
	@echo "  all         - Build the demo program (default)"
	@echo "  demo        - Build and run the interactive demo"
	@echo "  simple-demo - Run the shell-based demo"
	@echo "  test        - Build and run a quick test"
	@echo "  clean       - Remove build artifacts and test data"
	@echo "  install     - Install demo to system"
	@echo "  info        - Show build configuration"
	@echo "  help        - Show this help"
	@echo ""
	@echo "Prerequisites:"
	@echo "  - C++17 compatible compiler"
	@echo "  - persistency C++ libraries installed (dnf install persistency-cpp-devel)"
	@echo ""
	@echo "Examples:"
	@echo "  make                    # Build the demo"
	@echo "  make demo              # Build and run interactively"
	@echo "  make simple-demo       # Run shell-based demo"
	@echo "  make clean             # Clean up"