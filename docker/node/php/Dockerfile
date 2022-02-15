FROM lsqtzj/openeuler_httpd

WORKDIR /root/

# -- env settings
ENV SWOOLE_VERSION=v4.4.16 
ENV DEBIAN_FRONTEND=noninteractive
# Install
RUN yum -y update
RUN yum -y install cmake make libxml2 libxml2-devel openssl openssl-devel \
    curl-devel libjpeg-devel libpng-devel freetype-devel libzip libzip-devel \
    libsodium sqlite sqlite-devel oniguruma oniguruma-devel libwebp-devel git
RUN yum clean all

COPY  ./docker/node/php/php-7.4.27.tar.gz /tmp/
RUN cd /tmp/ && tar -xvf php-7.4.27.tar.gz 
RUN cd /tmp/php-7.4.27 && \
    ./configure --prefix=/usr/local/php7 \
    --with-config-file-path=/usr/local/php7/etc \
    --with-config-file-scan-dir=/usr/local/php7/etc/php.d \
    --enable-mysqlnd --with-mysqli --with-pdo-mysql \
    --enable-fpm \
    --enable-gd  --with-iconv --with-zlib --enable-xml \
    --enable-shmop --enable-sysvsem --enable-inline-optimization \
    --enable-mbregex --enable-mbstring --enable-ftp --with-openssl \
    --enable-pcntl --enable-sockets --with-xmlrpc --with-zip --with-jpeg \
    --with-webp --enable-soap --without-pear --with-gettext --enable-session \
    --with-curl --with-freetype --enable-opcache --disable-fileinfo &&\
    make && make install
RUN mkdir -p /usr/local/php7/etc/php.d
RUN ln -s /usr/local/php7/bin/php /usr/bin/php&&\
    ln -s  /usr/local/php7/bin/php-config /usr/bin/php-config &&\
    ln -s  /usr/local/php7/bin/phpize /usr/bin/phpize &&\
    cd /usr/local/php7/etc &&\
    cp php-fpm.conf.default php-fpm.conf &&\
    cp php-fpm.d/www.conf.default php-fpm.d/www.conf &&\
    cp /tmp/php-7.4.27/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm &&\
    chmod +x /etc/init.d/php-fpm 

# RUN  /usr/local/php7/bin/pecl install swoole php-gd php-curl php-mysql \
# 	php-zip php-fileinfo php-redis php-mbstring php-pear

RUN rm -Rf /tmp/*
RUN yum -y install make gcc gcc-c++ flex
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# Clone Tars repo and init php submodule
RUN cd /root/ && git clone https://gitee.com/TarsCloud/Tars.git \
	&& cd /root/Tars/ \
	&& git submodule update --init --recursive php \
	#intall PHP Tars module
	&& cd /root/Tars/php/tars-extension/ && phpize \
	&& ./configure --enable-phptars && make && make install \
	&& echo "extension=phptars.so" > /usr/local/php7/etc/php.d/10-phptars.ini \
	# Install PHP swoole module
	&& cd /root && git clone https://github.com/swoole/swoole \
	&& cd /root/swoole && git checkout $SWOOLE_VERSION \
	&& cd /root/swoole \
	&& phpize && ./configure --with-php-config=/usr/bin/php-config \
	&& make \
	&& make install \
	&& echo "extension=swoole.so" > /usr/local/php7/etc/php.d/20-swoole.ini \
	# Do somethine clean
	&& cd /root && rm -rf swoole \
	&& mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars 
RUN yum clean all
# copy source
COPY ./docker/node/entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]