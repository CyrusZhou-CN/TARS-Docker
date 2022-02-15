FROM openeuler/openeuler:20.09 AS base

RUN yum -y update && yum -y  install wget tar python3 python3-pip

ARG VERSION=v17.5.0
ARG DISTRO=linux-x64

RUN mkdir -p /usr/local/lib/nodejs
COPY ./docker/node/nodejs/node-*.tar.xz /opt/

RUN tar -xJvf /opt/node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs 
ENV PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH

WORKDIR /root/
ENV DEBIAN_FRONTEND=noninteractive

# Get and install nodejs

RUN npm install -g npm pm2 n \
    && n install v16.13.0 

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN yum clean all
# copy source
COPY ./docker/node/entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
