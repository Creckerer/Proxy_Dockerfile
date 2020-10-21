ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION} AS BUILD
WORKDIR /
RUN apt-get update && apt-get install --fix-missing -y \
    git \
    curl \
    build-essential \
    libssl-dev \
    zlib1g-dev
RUN git clone https://github.com/TelegramMessenger/MTProxy
WORKDIR /MTProxy
RUN make

FROM ubuntu:${UBUNTU_VERSION}
RUN apt-get update && apt-get install -y \
    curl \
    cron \
    xxd \
    openssl \
 && rm -rf /var/lib/apt/lists/*
COPY --from=BUILD /MTProxy/objs/bin/mtproto-proxy /usr/bin/mtproto-proxy
RUN mkdir /mtproto-proxy-config
COPY ./mtproxy_configs.sh /mtproto-proxy-config/mtproxy_configs.sh
COPY ./configs /configs
RUN chmod +x /mtproto-proxy-config/mtproxy_configs.sh
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 443 8888