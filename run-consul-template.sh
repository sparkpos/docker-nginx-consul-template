#!/bin/bash
/usr/local/bin/consul-template \
    -log-level ${LOG_LEVEL:-warn} \
    -consul-addr ${CONSUL_PORT_8500_TCP_ADDR:-localhost}:${CONSUL_PORT_8500_TCP_PORT:-8500} \
    -template "/etc/nginx/nginx.conf.ctmpl:/etc/nginx/site-enabled/apps.conf:nginx -s reload || true"
