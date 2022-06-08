# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang libboost-all-dev libgeotiff-dev

## Add source code to the build stage.
ADD . /mayhem-libLAS
WORKDIR /mayhem-libLAS/makefiles
RUN cmake -G "Unix Makefiles" ../
RUN make
RUN make install

RUN mkdir -p /deps
RUN ldd /usr/local/bin/lasinfo | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04

COPY --from=builder /deps /deps
COPY --from=builder /usr/local/bin/lasinfo /usr/local/bin/lasinfo
ENV LD_LIBRARY_PATH=/deps