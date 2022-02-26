FROM lsqtzj/openeuler_tars_node:cpp

ARG VERSION=v17.5.0
ARG DISTRO=linux-x64

RUN mkdir -p /usr/local/lib/nodejs
COPY ./docker/node/nodejs/node-*.tar.xz /opt/

RUN tar -xJvf /opt/node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs && rm -Rf /opt/node-*.tar.xz
ENV PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH

WORKDIR /root/

ENV TARS_INSTALL  /usr/local/tars/cpp/deploy

ARG FRAMEWORK_TAG=master
ARG WEB_TAG=master

RUN yum install -y protobuf-devel protobuf-c zlib-devel curl openssl-devel flex bison

# Get and install nodejs
RUN npm install -g npm pm2 n \
	&& n install v16.13.0 

RUN yum -y install psmisc
RUN rm -Rf /develop

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install Tars framework
# RUN mkdir -p /tmp/Tars && cd /tmp/Tars && git clone https://github.com/TarsCloud/TarsFramework framework --recursive && cd framework && git checkout $FRAMEWORK_TAG && git submodule update --init --recursive
# RUN cd /tmp/Tars && git clone https://github.com/TarsCloud/TarsWeb web && cd web && git checkout $WEB_TAG 

# 改本地调试版本
COPY ./develop/TarsFramework/ /tmp/Tars/framework/
COPY ./develop/TarsWeb/ /tmp/Tars/web
RUN mv /tmp/Tars/framework/build/build.sh /tmp/ && mv /tmp/Tars/framework/build/README.md /tmp/ && \
	rm -Rf /tmp/Tars/framework/build/* && \
	mv /tmp/build.sh /tmp/Tars/framework/build/ && mv /tmp/README.md /tmp/Tars/framework/build/

RUN mkdir -p /data \
	&& chmod u+x /tmp/Tars/framework/build/build.sh \
	&& cd /tmp/Tars/framework/build/ \
	&& cmake .. && make -j4 && make install 

RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
	&& rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg && yum -y install yarn
RUN rm -Rf /tmp/Tars/web/client/node_modules \
	&& cd /tmp/Tars/web/client && yarn install

RUN cd /tmp/Tars/web/client && export NODE_OPTIONS=--openssl-legacy-provider && yarn build 
RUN cp -rf /tmp/Tars/web /usr/local/tars/cpp/deploy/ \
	&& rm -rf /tmp 

RUN yum clean all
RUN	${TARS_INSTALL}/tar-server.sh

ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]


#web
EXPOSE 3000
#user system
EXPOSE 3001
#tarslog
EXPOSE 18993
#tarspatch
EXPOSE 18793
#tarsqueryproperty
EXPOSE 18693
#tarsconfig
EXPOSE 18193
#tarsnotify
EXPOSE 18593
#tarsproperty
EXPOSE 18493
#tarsquerystat
EXPOSE 18393
#tarsstat
EXPOSE 18293
#tarsAdminRegistry
EXPOSE 12000
#tarsnode
EXPOSE 19385
#tarsregistry
EXPOSE 17890
EXPOSE 17891