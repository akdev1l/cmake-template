# Version is injected by ci/package.sh (--define "pkg_version X.Y.Z") from
# CMakeLists.txt or the release tag.
%{!?pkg_version:%global pkg_version 0.0.0}

Name:           helloworld
Version:        %{pkg_version}
Release:        1%{?dist}
Summary:        Minimal greeting program built from the CMake template
License:        GPL-3.0-or-later
URL:            https://github.com/akdev1l/cmake-template
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  cmake >= 3.25
BuildRequires:  gcc-c++
BuildRequires:  ninja-build
BuildRequires:  gtest-devel

%description
A minimal hello world program and library, used as the base for new CMake
projects.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Headers and CMake package files for developing against the %{name} library.

%prep
%autosetup

%build
%cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DHELLOWORLD_BUILD_TESTS=ON \
    -DHELLOWORLD_BUILD_DOCS=OFF
%cmake_build

%install
%cmake_install

%check
%ctest

%files
%license LICENSE
%doc README.md
%{_bindir}/%{name}
%{_libdir}/lib%{name}.so.*

%files devel
%dir %{_includedir}/akdev
%{_includedir}/akdev/%{name}.hpp
%{_includedir}/akdev/%{name}/
%{_libdir}/lib%{name}.so
%{_libdir}/cmake/%{name}/

%changelog
* Tue Oct 06 2026 Alex Diaz <alex@akdev.xyz> - 0.1.0-1
- Initial package
