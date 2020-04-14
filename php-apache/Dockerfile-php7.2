# 20181013	由php 7.1.20改為7.2.10
# 20180727	加入docker-php-ext-install zip
#
# ====================================
FROM php:7.2.10-apache
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
    && pecl install mcrypt-1.0.1 \
	&& docker-php-ext-enable mcrypt \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && a2enmod rewrite \
    && service apache2 restart
EXPOSE 80
EXPOSE 9000
ENV PHP_XDEBUG_ENABLED: 1  
    
#docker-php-ext-install  mysqli pdo pdo_mysql
#calendar date dom exif exif fileinfo gd gettext hash iconv json libxml mcrypt mysqli pcre pdo pdo_mysql phar posix readline session shmop sockets sysvmsg tokenizer wddx xml xmlreader xmlwriter zip
