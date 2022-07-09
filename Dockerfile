# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake clang autoconf automake pkg-config libevent-dev libssl-dev

## Add source code to the build stage. ADD prevents git clone being cached when it shouldn't
WORKDIR /
ADD https://api.github.com/repos/capuanob/coturn/git/refs/heads/mayhem version.json
RUN git clone -b mayhem https://github.com/capuanob/coturn.git
WORKDIR /coturn

## Build
RUN mkdir ./dist
RUN ./configure --prefix=$PWD/dist
RUN make -j$(nproc) install

## Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y libevent-dev libssl-dev
COPY --from=builder /coturn/dist /coturn
