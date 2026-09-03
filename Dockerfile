ARG BUILDPLATFORM

FROM --platform=$BUILDPLATFORM docker.io/almalinux:latest

ARG FLUTTER_VERSION=3.47.0

ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

RUN dnf update -y && \
    dnf --setopt=install_weak_deps=False \
        install -y \
        git \
        which \
        wget \
        tar \
        xz \
        unzip \
        libstdc++ \
        mesa-libGLU && \
    dnf -y clean all

# For local development, stop wasting resources
# COPY flutter_linux_${FLUTTER_VERSION}-stable.tar.xz .
# RUN tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -C /opt && \
#     rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

RUN wget --quiet https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -O flutter_linux.tar.xz && \
    tar xf flutter_linux.tar.xz -C /opt && \
    rm flutter_linux.tar.xz


RUN useradd -ms /bin/bash ci && \
    chown -R ci:ci ${FLUTTER_HOME}
