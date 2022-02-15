FROM openeuler/openeuler:20.09

WORKDIR /root/
ENV DEBIAN_FRONTEND=noninteractive
# Install
RUN yum -y update 

RUN yum -y update && yum -y install wget java-11-openjdk-devel
RUN yum clean all

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN yum clean all
# copy source
COPY ./docker/node/entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]