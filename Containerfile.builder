# Build environment for the project. Used locally (ci/container.sh) and in CI.
FROM registry.fedoraproject.org/fedora:44

RUN dnf -y install --setopt=install_weak_deps=False \
        cmake \
        ninja-build \
        gcc-c++ \
        clang \
        clang-tools-extra \
        gtest-devel \
        gmock-devel \
        doxygen \
        graphviz \
        ShellCheck \
        rpm-build \
        rpmlint \
        git \
        glibc-langpack-en \
        tar \
        gzip \
    && dnf clean all

ENV LANG=C.UTF-8

WORKDIR /src
