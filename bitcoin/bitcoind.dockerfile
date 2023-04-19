FROM debian:bullseye-slim

ENV BITCOIN_VERSION=24.0.1

ENV TZ=${TZ}

RUN apt-get update -y \
  && apt-get install -y wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TARGETPLATFORM=aarch64-linux-gnu

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz

RUN tar -xzf bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz \
   && install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${BITCOIN_VERSION}/bin/* \
   && rm -rf bitcoin-${BITCOIN_VERSION} \
   && rm bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz

STOPSIGNAL SIGINT

EXPOSE 8332 8333

RUN bitcoind -version

ENTRYPOINT ["bitcoind"]