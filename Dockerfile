FROM nginx:alpine
MAINTAINER Terry Zhang <zterry@qq.com>

ENV CONSUL_TEMPLATE_VERSION=0.19.4

RUN apk --no-cache add curl bash supervisor

###### set up timezone
RUN apk update && apk add ca-certificates && \
    apk add tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

#### get nginx config
ADD https://raw.githubusercontent.com/sparkpos/nginx-php-config/master/nginx.conf /etc/nginx/
RUN mkdir /etc/nginx/site-enabled

##### Install consul-template
ENV DL_URL https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz
RUN wget $DL_URL -O /tmp/consul-template.tar.gz && \
  tar -xvzf /tmp/consul-template.tar.gz -C /usr/local/bin && \
  chmod +x /usr/local/bin/consul-template && \
  rm /tmp/consul-template.tar.gz

ADD run-consul-template.sh /usr/local/bin/run-consul-template
RUN chmod +x /usr/local/bin/run-consul-template /usr/local/bin/consul-template
ADD nginx.conf.ctmpl /etc/nginx/nginx.conf.ctmpl

ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
