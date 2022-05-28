# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake clang autoconf automake openssl libevent-dev pkg-config libssl-dev

## Add source code to the build stage. ADD prevents git clone being cached when it shouldn't
WORKDIR /
ADD https://api.github.com/repos/capuanob/coturn/git/refs/heads/mayhem version.json
RUN git clone -b mayhem https://github.com/capuanob/coturn.git
WORKDIR /coturn

## Build
RUN ./configure
RUN make -j$(nproc)

## Prepare all library dependencies for copy
#RUN mkdir /deps
#RUN cp `ldd sdr_server | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :

## Package Stage

#FROM --platform=linux/amd64 ubuntu:20.04
#COPY --from=builder /sdr-server/build/sdr_server /sdr_server
#COPY --from=builder /sdr-server/build/configuration.config /configuration.config
#COPY --from=builder /deps /usr/lib

#CMD ["/sdr_server", "configuration.config"]
