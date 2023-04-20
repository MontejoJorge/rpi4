ARG VERSION=v0.9.10

FROM rust:1.48.0-slim AS builder

ARG VERSION

WORKDIR /build


RUN apt-get update \
   && apt-get install -y git curl gpg clang cmake libsnappy-dev

RUN git clone --branch $VERSION https://github.com/romanz/electrs . \
   && curl https://romanzey.de/pgp.txt | gpg --import \
   && git verify-tag $VERSION

# cargo under QEMU building for ARM can consumes 10s of GBs of RAM...
# Solution: https://users.rust-lang.org/t/cargo-uses-too-much-memory-being-run-in-qemu/76531/2
ENV CARGO_NET_GIT_FETCH_WITH_CLI true

RUN cargo install --locked --path .

FROM debian:buster-slim

COPY --from=builder /usr/local/cargo/bin/electrs /bin/electrs

# Electrum RPC
EXPOSE 50001

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

ENTRYPOINT ["electrs"]