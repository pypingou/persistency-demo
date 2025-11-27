Name:           persistency-demo
Version:        0.1.0
Release:        1%{?dist}
Summary:        Demonstration programs for the persistency KVS library

License:        Apache-2.0
URL:            https://github.com/eclipse-score/score-persistency
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  gcc-c++
BuildRequires:  make
BuildRequires:  rust
BuildRequires:  cargo
BuildRequires:  score-baselibs-devel
BuildRequires:  persistency-cpp-devel
BuildRequires:  persistency-rust-devel
BuildRequires:  libacl-devel
BuildRequires:  libcap-devel

Requires:       persistency-cpp
Requires:       persistency-rust

%description
This package contains comprehensive demonstration programs for the Eclipse Score
persistency Key-Value Storage (KVS) library. It includes both C++ and Rust
examples that showcase the main capabilities of the persistency library including
data type support, snapshot management, default values handling, and persistence
operations.

%package cpp
Summary:        C++ demonstration program for persistency KVS library
Requires:       persistency-cpp

%description cpp
C++ demonstration program that showcases the capabilities of the persistency
KVS library including thread-safe operations, multiple data types support,
JSON-based persistence, snapshot management, and default values handling.

%package rust
Summary:        Rust demonstration program for persistency KVS library
Requires:       persistency-rust

%description rust
Rust demonstration program that showcases the capabilities of the persistency
KVS library including type-safe operations, multiple data types support,
JSON-based persistence, snapshot management, and default values handling.

%prep
%autosetup

%build
# Build C++ demo
cd kvs-cpp-demo
make %{?_smp_mflags}
cd ..

# Build Rust demo
cd kvs-rust-demo
# Ensure proper permissions on vendored sources
find vendor -type f -exec chmod 644 {} + 2>/dev/null || true
find vendor -type d -exec chmod 755 {} + 2>/dev/null || true
cargo build --release
cd ..

%install
# Install C++ demo
cd kvs-cpp-demo
make install DESTDIR=%{buildroot}
install -d %{buildroot}%{_docdir}/%{name}-cpp
install -m 644 simple_demo.sh %{buildroot}%{_docdir}/%{name}-cpp/
cd ..

# Install Rust demo
cd kvs-rust-demo
make install DESTDIR=%{buildroot}
cd ..

# Install documentation
install -d %{buildroot}%{_docdir}/%{name}
install -m 644 README.md %{buildroot}%{_docdir}/%{name}/

%check
# Test C++ demo
cd kvs-cpp-demo
make test
cd ..

# Test Rust demo
cd kvs-rust-demo
make test
cd ..

%files
%doc %{_docdir}/%{name}/README.md
%license LICENSE

%files cpp
%{_bindir}/kvs-cpp-demo
%doc %{_docdir}/%{name}-cpp/simple_demo.sh

%files rust
%{_bindir}/kvs-rust-demo

%changelog
* Tue Nov 25 2025 Pierre-Yves Chibon <pingou@pingoured.fr> - 0.1.0-1
- Initial package with C++ and Rust demonstrations
- Comprehensive examples for persistency KVS library
- Thread-safe operations and data type demonstrations
- Snapshot management and default values examples
