ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION} AS BUILD
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
ARG USER_NM="nobody"
ENV USER_NM="${USER_NM}"
ARG SECRET="45925c8ada44f78c8059f337c131b7c1"
ENV SECRET="${SECRET}"
ARG USR_PORT="443"
ENV USR_PORT="${USR_PORT}"
ARG LOCAL_PORT="8888"
ENV LOCAL_PORT="${LOCAL_PORT}"
ARG WORKS="1"
ENV WORKS="${WORKS}"
COPY --from=BUILD /MTProxy/objs/bin/mtproto-proxy /usr/bin/mtproto-proxy
RUN mkdir /mtproto-proxy-config
COPY ./mtproxy_configs.sh /mtproto-proxy-config/mtproxy_configs.sh
RUN chmod +x /mtproto-proxy-config/mtproxy_configs.sh
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE ${USR_PORT} ${LOCAL_PORT}