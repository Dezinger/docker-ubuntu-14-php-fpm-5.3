FROM dezinger/ubuntu-14:latest

MAINTAINER dezinger@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV SSH_KEYS_DIRECTORY /root/.ssh
ARG PHP_VERSION=5
ARG VER=5.3.29-0ubuntu4
ENV PHP_VERSION=${PHP_VERSION}

COPY files/ /
WORKDIR /var/www

RUN \
# add repo php5.3
    add-apt-repository ppa:hentenaar/php && \ 
    apt-get -y update && \
# setup php
    apt-get install --no-install-recommends -y \
    curl ca-certificates ssh git vim \
    php5-common=$VER \
    php5-cli=$VER \ 
    php5-fpm=$VER \
    #php-apc \
    php-pear=$VER \
    php5-pgsql=$VER \
    php5-curl=$VER \
    php5-gd=$VER \
    php5-xsl=$VER \
    php5-xmlrpc=$VER \
    php5-tidy=$VER \
    php5-mcrypt=$VER \
    libmemcached-dev \
    #php5-memcached \
    imagemagick \
    #php5-imagick \
    php5-intl=$VER && \
    #php5-mbstring \
    #php5-msgpack \
    #php5-zip && \
    php --version && \
    php -m && \
# setup composer
    php -r "readfile('http://getcomposer.org/installer');" | \
    php -- --install-dir=/usr/bin/ --filename=composer && \
# php-fpm config
    sed -i -e 's/^listen = 127.0.0.1:9000$/listen = 9000/g' \ 
           /etc/php$PHP_VERSION/fpm/pool.d/www.conf && \
    ln -sf /etc/php$PHP_VERSION/fpm/php.ini /etc/php$PHP_VERSION/cli/php.ini && \
# setup mode
    chmod +x /usr/local/bin/add-ssh-keys.sh && \
# clean 
    apt-get -y autoremove && apt-get -y clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["$SSH_KEYS_DIRECTORY", "/var/www"]

EXPOSE 9000