# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential rustc cargo cmake clang 

## Add source code to the build stage.
ADD . /COMPACT_STR
WORKDIR /COMPACT_STR

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
#RUN rm -rf build
#RUN mkdir build/
#RUN cd build/ && rm -rf *
#RUN cd build/ && cargo new compact_str
#Make fuzz targets
RUN cargo build --bin compact_str --features="libfuzzer-sys" --release
# Package Stage
FROM ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /COMPACT_STR/target/release/compact_str /
#COPY fuzz targets

#CMD ['target/release/compact_str']