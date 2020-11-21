# 20201121  更新至 php:7.3.24-apache ,composer 1.10.17
# 20200610  更新至 php:7.3.18-apache ,composer 1.10.7 ，並加入redis連結
# 20200414  更新至php 7.3 , xxdebug 2.9.4 ,composer 1.10.4
# 20181105  加入composer v1.7.3 (設定參考來源：https://github.com/composer/docker)
# 20181013	由php 7.1.20改為7.2.10
# 20180727	加入docker-php-ext-install zip
# 
# ====================================
FROM php:7.3.24-apache
RUN apt-get update && apt-get install -y \
    apt-utils \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    unzip \
    zip \
    libzip-dev \
    redis-tools \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt \
    && pecl install redis \
    && docker-php-ext-enable redis \
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

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.10.17

RUN set -eux; \
    curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer; \
    php -r " \
    \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
    \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
    unlink('/tmp/installer.php'); \
    echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
    exit(1); \
    }"; \
    php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}; \
    composer --ansi --version --no-interaction; \
    rm -f /tmp/installer.php; \
    find /tmp -type d -exec chmod -v 1777 {} +

#FILES DELETION
RUN apt-get autoremove -y \
    && rm -rf /tmp/*

EXPOSE 80
EXPOSE 9000
ENV PHP_XDEBUG_ENABLED: 1  

#docker-php-ext-install  mysqli pdo pdo_mysql
#calendar date dom exif exif fileinfo gd gettext hash iconv json libxml mcrypt mysqli pcre pdo pdo_mysql phar posix readline session shmop sockets sysvmsg tokenizer wddx xml xmlreader xmlwriter zip
