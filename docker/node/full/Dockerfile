FROM lsqtzj/openeuler_httpd AS base

RUN yum clean all
RUN yum -y update 

FROM lsqtzj/openeuler_tars_node:php AS node_php

FROM base AS runtime

WORKDIR /root/
ENV DEBIAN_FRONTEND=noninteractive
# Install cpp

RUN yum -y install golang 
RUN yum -y install unzip gcc gcc-c++ make cmake curl wget protobuf-devel protobuf-c zlib-devel openssl-devel mysql mysql-devel mysql-common

# Install java
RUN yum -y install wget java-11-openjdk-devel
ARG VERSION=v17.5.0
ARG DISTRO=linux-x64


# Get and install nodejs
RUN mkdir -p /usr/local/lib/nodejs
COPY ./docker/node/nodejs/node-*.tar.xz /opt/

RUN tar -xJvf /opt/node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs 
ENV PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH

RUN yum -y install wget tar
RUN npm install -g npm pm2 n \
    && n install v16.13.0 

# -- PHP env settings
ENV SWOOLE_VERSION=v4.4.16

# COPY PHP7

COPY --from=node_php /usr/local/php7 /usr/local/php7
COPY --from=node_php /root/phptars /root/phptars 
COPY --from=node_php /etc/init.d/php-fpm /etc/init.d/php-fpm
COPY --from=node_php /usr/lib64/libwebp.so* /usr/lib64/

RUN mkdir -p /usr/local/php7/etc/php.d
RUN chmod +x /etc/init.d/php-fpm 
RUN yum -y install psmisc
RUN yum clean all
# copy source
COPY ./docker/node/entrypoint.sh /sbin/
ENV PATH=$PATH:/usr/local/php7/bin
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]