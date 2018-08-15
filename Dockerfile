FROM dezinger/ubuntu-14:latest

MAINTAINER dezinger@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV SSH_KEYS_DIRECTORY /root/.ssh
ARG PHP_VERSION=53
ENV PHP_VERSION=${PHP_VERSION}

COPY files/ /
WORKDIR /var/www

RUN \
# add repo php5.3
    add-apt-repository ppa:sergey-dryabzhinsky/php53 && \ 
    add-apt-repository ppa:sergey-dryabzhinsky/php-modules && \
    apt-get -y update && \
# setup php
    apt-get install --no-install-recommends -y \
    curl ca-certificates ssh git supervisor vim wget \
    php53p-cli \ 
    php53p-fpm \
    php53p-mod-pgsql \
    php53p-mod-curl \
    php53p-common \
    php53p-mod-gd \
    php53p-mod-xsl \
    php53p-mod-xmlrpc \
    php53p-mod-tidy \
    php53p-mod-mcrypt \
    php53p-mod-json \
    php53p-mod-phar \
    php53p-mod-openssl \
    libmemcached-dev \
    php53-mod-memcached \
    imagemagick \
    php53-mod-imagick \
    php53p-mod-intl \
    php53p-mod-mbstring \
    php53p-mod-dom \
    php53p-mod-tokenizer \
    #php53p-mod-msgpack \
    php53-mod-zip && \
    php --version && \
    php -m && \
# setup composer
    php -r "readfile('http://getcomposer.org/installer');" | \
    php -- --install-dir=/usr/bin/ --filename=composer && \
# php-fpm config
    cp /etc/php$PHP_VERSION/fpm/pool.d/pool-www-data.conf.example /etc/php$PHP_VERSION/fpm/pool.d/www.conf && \
    sed -i -e 's/^listen = \/var\/run\/php53-fpm\/\$pool.socket$/listen = 9000/g' \ 
           -e 's/^prefix = \/var\/www\/sites\/default$/;prefix = \/var\/www\/sites\/default/g' \ 
           -e 's/^chdir = \/var\/www\/sites\/default$/;chdir = \/var\/www\/sites\/default/g' \
           /etc/php$PHP_VERSION/fpm/pool.d/www.conf && \
    ln -sf /etc/php$PHP_VERSION/fpm/php.ini /etc/php$PHP_VERSION/cli/php.ini && \
# setup mode
    chmod +x /usr/local/bin/add-ssh-keys.sh

VOLUME ["$SSH_KEYS_DIRECTORY", "/var/www"]

EXPOSE 9000