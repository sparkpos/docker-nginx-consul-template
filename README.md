# description
This image combine nginx and consul-template. An nginx.conf.ctmpl is embeded for generate nginx vhost. 

# Usage
## run it directly via docker run
```
docker run -d --name my-nginx -p 80:80 -p 443:443 \
  -e CONSUL_PORT_8500_TCP_ADDR=[your-consul-address] \
  -v /YOUR-CERT-PATH:/etc/nginx/certs \
  sparkpos/nginx-consul-template
```

## docker-compose.yml
```
version: '3'
services:
  consul:
    image: sparkpos/nginx-consul-template
    ports:
      - 80:80
      - 443:443
    environment:
      - CONSUL_PORT_8500_TCP_ADDR=1.1.1.1
      # in experiment, ignore this. so registrator will not register this container to consul.
      - SERVICE_IGNORE=true
    volumes:
      #- ./nginx.conf.ctmpl:/etc/nginx/nginx.conf.ctmpl
      - /root/certs-wild:/etc/nginx/certs
    container_name: ngnx-consul
```

## Run consul
```
docker run -d --name consul -p 8500:8500 consul -dev -ui -client 0.0.0.0
```

## Run Registrator
```
docker run -d --name=registrator -v/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator:latest -ip="[your-real-ip]" consul://[your-consul-ip]:8500
```

## Run Apps
```
docker run -d --name=whoami10 -h whoami10 -p 8080:8000 -e SERVICE_NAME="de_dplor_com" jwilder/whoami
docker run -d --name=whoami11 -h whoami11 -p 8081:8000 -e SERVICE_NAME="de_dplor_com" jwilder/whoami
docker run -d --name=whoami12 -h whoami12 -p 8082:8000 -e SERVICE_NAME="de_dplor_com" jwilder/whoami
```

# IMPORTANT
Because of [Service name with . (dot) not found](https://github.com/hashicorp/consul-template/issues/304), so when we running Apps, the environment "SERVICE_NAME"
replace the dot(.) with underslash(_). In nginx.conf.ctmpl, the _ will be replace with .
So if your domain is a.b.com, the SERVER_NAME should be a_b_com.
