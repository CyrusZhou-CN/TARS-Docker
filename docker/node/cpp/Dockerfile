FROM lsqtzj/openeuler_httpd

WORKDIR /root/
ENV DEBIAN_FRONTEND=noninteractive
# Install
RUN yum -y update
RUN yum -y install unzip gcc gcc-c++ make cmake curl wget mysql mysql-devel mysql-common protobuf-devel protobuf-c zlib-devel openssl openssl-devel
RUN yum -y install golang 
RUN yum clean all

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# copy source
COPY ./docker/node/entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]