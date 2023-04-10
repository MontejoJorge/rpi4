FROM debian:bullseye-slim

ENV BITCOIN_VERSION=24.0.1

RUN apt-get update -y \
  && apt-get install -y wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-aarch64-linux-gnu.tar.gz

RUN tar -xzf bitcoin-${BITCOIN_VERSION}-aarch64-linux-gnu.tar.gz \
   && install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${BITCOIN_VERSION}/bin/* \
   && rm -rf bitcoin-${BITCOIN_VERSION} \
   && rm bitcoin-${BITCOIN_VERSION}-aarch64-linux-gnu.tar.gz

STOPSIGNAL SIGINT

EXPOSE 8332 8333

RUN bitcoind -version

ENTRYPOINT ["bitcoind"]