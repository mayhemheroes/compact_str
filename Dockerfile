# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y rustc cargo

## Add source code to the build stage.
ADD . /COMPACT_STR
WORKDIR /COMPACT_STR

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN rm -rf build
RUN mkdir build/
RUN cd build/ && rm -rf *
RUN cd build/ && cargo new compact_str-fuzz
#Make fuzz targets
RUN cd build/ && cargo run --features="libfuzzer-sys"
# temp: --bin compact_str (place back in if needed)
# Package Stage
FROM ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /COMPACT_STR/build/target/debug/compact_str-fuzz /
#COPY fuzz targets

#CMD ['/compact-str-fuzz']