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
