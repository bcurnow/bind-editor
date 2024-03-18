FROM debian:12

RUN apt-get update && apt-get install -y \
      bind9 \
      bind9-dnsutils \
      bind9-utils \
      iputils-ping \
      less \
      net-tools \
      openssh-client \
      procps \
      rsync \
      vim

COPY entry-point.sh /

ENTRYPOINT exec /entry-point.sh
