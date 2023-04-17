FROM debian:latest

RUN apt-get update && apt-get install -y \
      bind9-dnsutils \
      bind9-utils \
      iputils-ping \
      less \
      net-tools \
      openssh-client \
      procps \
      rsync \
      vim

RUN groupadd --gid 105 bind \
    && useradd --uid 104 -g bind bind \
    && install -d -m 0755 -o bind -g bind /home/bind

COPY entry-point.sh /

ENTRYPOINT exec /entry-point.sh
