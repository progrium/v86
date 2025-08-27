FROM alpine:latest AS build
WORKDIR /v86
RUN apk add --update curl clang make openjdk8-jre-base npm python3 git openssh && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && PATH="${HOME}/.cargo/bin:${PATH}" rustup target add wasm32-unknown-unknown
COPY . .
RUN PATH="${HOME}/.cargo/bin:${PATH}" make all && \
    rm -rf closure-compiler gen lib src .cargo cargo.toml Makefile

FROM scratch AS dist
COPY --from=build /v86/build /