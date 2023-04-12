FROM debian:latest

RUN apt-get update && apt-get install -y \
      bind9-dnsutils \
      bind9-utils \
      procps \
      vim

COPY entry-point.sh /

ENTRYPOINT exec /entry-point.sh
