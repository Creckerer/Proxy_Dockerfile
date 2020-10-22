#!/bin/sh
/mtproto-proxy-config/mtproxy_configs.sh
/usr/bin/mtproto-proxy -u nobody -p "$LOCAL_PORT" -H "$USR_PORT" -S "$SECRET" --aes-pwd /mtproto-proxy-config/proxy-secret /mtproto-proxy-config/proxy-multi.conf -M "$WORKS"
