FROM ubuntu:22.04
WORKDIR /home/openharmony

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Prevent tz/locale prompts during build and fail fast on pipelines
ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Base tools, compilers, libraries
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
     automake autoconf m4 libtool \
     ca-certificates apt-utils curl wget gnupg git git-lfs \
     bison flex bc build-essential make ccache m4 \
     binutils binutils-dev gperf \
     gcc g++ gcc-multilib g++-multilib \
     gcc-arm-none-eabi \
     libc6-dev-i386 libstdc++6 libdwarf-dev \
     libelf-dev libffi-dev libfl-dev \
     libx11-dev libgl1-mesa-dev x11proto-core-dev \
     libxml2-dev xsltproc \
     lib32z1-dev lib32ncurses5-dev \
     libtinfo5 libtinfo-dev libncurses5 libncurses5-dev libncursesw5 \
     zlib1g-dev libexpat1-dev \
     device-tree-compiler libfdt-dev \
     libaio-dev libxkbcommon-dev libudev-dev \
     libsdl2-dev libpng-dev libjpeg-dev libnss3-dev \
     libsasl2-dev libcapstone-dev libkeyutils-dev libsphinxbase-dev \
     cmake ninja-build scons pkg-config \
     u-boot-tools mtd-utils genext2fs e2fsprogs dosfstools mtools rsync tar \
     jfsutils reiserfsprogs xfsprogs squashfs-tools kmod pcmciautils quota ppp \
     default-jre default-jdk \
     python3 python3-pip python3-distutils python-is-python3 \
     perl ruby openssl libssl-dev \
     cpio lz4 jq unzip zip \
     vim openssh-client \
     locales \
  && locale-gen "en_US.UTF-8" \
  && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Repo tool (OpenHarmony uses repo)
RUN curl -fsSL https://gitee.com/oschina/repo/raw/fork_flow/repo-py3 -o /usr/bin/repo \
  && chmod +x /usr/bin/repo

# Python packages (use Huawei mirror where applicable)
RUN pip3 install -i https://repo.huaweicloud.com/repository/pypi/simple --trusted-host repo.huaweicloud.com \
      requests setuptools pymongo kconfiglib pycryptodome ecdsa ohos-build pyyaml \
      rich pygments mdurl markdown-it-py \
      prompt_toolkit==1.0.14 redis json2html yagmail python-jenkins \
  && pip3 install --upgrade --ignore-installed six esdk-obs-python

# Node.js 20 LTS + HPM CLI (OpenHarmony)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends nodejs \
  && npm install -g @ohos/hpm-cli --registry https://mirrors.huaweicloud.com/repository/npm/ \
  && rm -rf /var/lib/apt/lists/*

