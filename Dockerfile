FROM docker.io/almalinux:minimal

ARG FLUTTER_VERSION=3.47.0

ENV FLUTTER_HOME=/home/ci/flutter-sdk
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

RUN microdnf update -y && \
    microdnf --setopt=install_weak_deps=0 \
        install -y \
        git \
        which \
        wget \
        tar \
        xz \
        unzip \
        libstdc++ \
        clang \
        make \
        cmake \
        mesa-libGLU && \
    microdnf -y clean all

RUN useradd -ms /bin/bash ci && \
    git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_HOME" && \
    chown -R ci:ci ${FLUTTER_HOME}

USER ci

RUN git config --global --add safe.directory ${FLUTTER_HOME} && \
    flutter config --no-analytics && \
    flutter --disable-analytics && \
    flutter precache --web || flutter doctor
