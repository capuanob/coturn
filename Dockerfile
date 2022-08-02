# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang autoconf automake pkg-config libevent-dev libssl-dev git

# Add code
ADD . /coturn
WORKDIR /coturn

## Build
RUN mkdir ./dist
RUN ./configure --prefix=$PWD/dist
RUN make -j$(nproc) install

## Package Stage
FROM --platform=linux/amd64 ubuntu:20.04 as packager
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y libssl1.1 libevent-2.1-7 libevent-pthreads-2.1-7 libevent-extra-2.1-7 libevent-openssl-2.1-7
COPY --from=builder /coturn/dist /coturn
COPY --from=builder /coturn/fuzzturnserver.conf /fuzzturnserver.conf
