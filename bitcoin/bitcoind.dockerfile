FROM debian:bullseye-slim

ENV BITCOIN_VERSION=24.0.1

RUN apt-get update -y \
  && apt-get install -y wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TARGETPLATFORM=aarch64-linux-gnu
ENV TARGETPLATFORM=x86_64-linux-gnu

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz \
   && wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS \
   && sha256sum --ignore-missing --check SHA256SUMS

RUN tar -xzf bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz \
   && install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${BITCOIN_VERSION}/bin/* \
   && rm SHA256SUMS \
   && rm -rf bitcoin-${BITCOIN_VERSION} \
   && rm bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz \
   && rm /usr/local/bin/bitcoin-qt /usr/local/bin/test_bitcoin

STOPSIGNAL SIGINT

EXPOSE 8332 8333

RUN bitcoind -version

ENTRYPOINT ["bitcoind"]