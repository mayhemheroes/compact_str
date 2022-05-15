# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl
RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ${HOME}/.cargo/bin/rustup default nightly
RUN ${HOME}/.cargo/bin/cargo install -f cargo-fuzz

## Add source code to the build stage.
ADD . /compact_str
WORKDIR /compact_str

RUN ${HOME}/.cargo/bin/cargo fuzz build --features=libfuzzer-sys --debug-assertions compact_str

# Package Stage
FROM ubuntu:20.04

COPY --from=builder compact_str/target/x86_64-unknown-linux-gnu/release/compact_str /