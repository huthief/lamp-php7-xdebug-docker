## 2023.02.17 可以參考 https://hub.docker.com/r/shinsenter/phpfpm-apache
## （承上）https://github.com/shinsenter/php#pre-installed-php-modules
## （承上）上面專案是繼承此專案 https://github.com/serversideup/docker-php

## 原始版本：https://github.com/8ctopus/apache-php-fpm-alpine/tree/php7.4
## 自行調整項目
## zlib.output_compression = On
## max_execution_time = 900
## max_input_time = 6000
## max_input_vars = 15000
## memory_limit = 256M
## post_max_size = 150M
## upload_max_filesize = 150M
## max_file_uploads = 100
## date.timezone = Asia/Taipei
## add tzdata & ENV TZ
## composer 改用 alpine:3.14 本身的 (alpine:3.15 composer是搭配php8)
## php extensions增加以下項目:
## php7 gd xsl phar xmlreader redis simplexml pdo

FROM alpine:3.14.0

# expose ports
EXPOSE 80
EXPOSE 443

ENV DOMAIN localhost
ENV DOCUMENT_ROOT /
ENV TZ=Asia/Taipei

# add entry point script
ADD --chown=root:root include/start.sh /tmp/start.sh

# update apk repositories
RUN apk update \
    \
    # upgrade all
    && apk upgrade \
    \
    # add timezone
    && apk add --no-cache tzdata \
    \
    # install console tools
    inotify-tools \
    \
    # install zsh 
    zsh \
    zsh-vcs \
    \
    # install php
    php7 \
    # use php7-fpm instead of php7-apache2
    php7-fpm \
    php7-bcmath \
    php7-common \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fileinfo \
    php7-gettext \
    php7-json \
    php7-mbstring \
    php7-mysqli \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-posix \
    php7-session \
    php7-simplexml \
    php7-sodium \
    php7-tokenizer \
    php7-xml \
    php7-xmlwriter \
    php7-zip \
    php7-gd \
    php7-xsl \
    php7-phar \
    php7-xmlreader \
    php7-simplexml \
    \
    # install mcrypt
    php7-pecl-mcrypt \
    \
    # install redis
    php7-pecl-redis \
    \
    # install xdebug
    php7-pecl-xdebug \
    \
    # install composer
    composer \
    \
    # install apache
    apache2 \
    apache2-ssl \
    apache2-proxy \
    # add www-data
    # 82 is the standard uid/gid for "www-data" in Alpine
    && set -x \
    #    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data \
    && addgroup www-data xfs \
    && addgroup xfs www-data \
    \
    # enable mod rewrite
    && sed -i 's|#LoadModule rewrite_module modules/mod_rewrite.so|LoadModule rewrite_module modules/mod_rewrite.so|g' /etc/apache2/httpd.conf \
    \
    # authorize all directives in .htaccess
    && sed -i 's|    AllowOverride None|    AllowOverride All|g' /etc/apache2/httpd.conf \
    \
    # change log files location
    && mkdir -p /var/log/apache2 \
    && sed -i 's| logs/error.log| /var/log/apache2/error.log|g' /etc/apache2/httpd.conf \
    && sed -i 's| logs/access.log| /var/log/apache2/access.log|g' /etc/apache2/httpd.conf \
    \
    # change SSL log files location
    && sed -i 's|ErrorLog logs/ssl_error.log|ErrorLog /var/log/apache2/error.log|g' /etc/apache2/conf.d/ssl.conf \
    && sed -i 's|TransferLog logs/ssl_access.log|TransferLog /var/log/apache2/access.log|g' /etc/apache2/conf.d/ssl.conf \
    \
    # switch from mpm_prefork to mpm_event
    && sed -i 's|LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|g' /etc/apache2/httpd.conf \
    && sed -i 's|#LoadModule mpm_event_module modules/mod_mpm_event.so|LoadModule mpm_event_module modules/mod_mpm_event.so|g' /etc/apache2/httpd.conf \
    \
    # enable important apache modules
    && sed -i 's|#LoadModule deflate_module modules/mod_deflate.so|LoadModule deflate_module modules/mod_deflate.so|g' /etc/apache2/httpd.conf \
    && sed -i 's|#LoadModule expires_module modules/mod_expires.so|LoadModule expires_module modules/mod_expires.so|g' /etc/apache2/httpd.conf \
    && sed -i 's|#LoadModule ext_filter_module modules/mod_ext_filter.so|LoadModule ext_filter_module modules/mod_ext_filter.so|g' /etc/apache2/httpd.conf \
    \
    # authorize all changes in htaccess
    && sed -i 's|Options Indexes FollowSymLinks|Options All|g' /etc/apache2/httpd.conf \
    \ 
    # configure php-fpm to use unix socket
    && sed -i 's|listen = 127.0.0.1:9000|listen = /var/run/php-fpm7.sock|g' /etc/php7/php-fpm.d/www.conf \
    \
    #RUN sed -i 's|;listen.owner = nobody|listen.owner = apache|g' /etc/php7/php-fpm.d/www.conf
    && sed -i 's|;listen.owner = nobody|listen.owner = www-data|g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's|;listen.group = group|listen.group = www-data|g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's|user = nobody|user = www-data|g' /etc/php7/php-fpm.d/www.conf \ 
    && sed -i 's|group = nobody|group = www-data|g' /etc/php7/php-fpm.d/www.conf \
    \
    # switch apache to use php-fpm through proxy
    # don't use proxy pass match because it does not support directory indexing
    # huthief unmark
    # RUN sed -i 's|^DocumentRoot|ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/var/www/localhost/htdocs/$1\n\nDocumentRoot|g' /etc/apache2/httpd.conf
    \
    # use set handler to route php requests to php-fpm
    && sed -i 's|^DocumentRoot|<FilesMatch "\.php$">\n\
    SetHandler "proxy:unix:/var/run/php-fpm7.sock\|fcgi://localhost"\n\
    </FilesMatch>\n\nDocumentRoot|g' /etc/apache2/httpd.conf \
    \
    # update directory index to add php files
    && sed -i 's|DirectoryIndex index.html|DirectoryIndex index.php index.html|g' /etc/apache2/httpd.conf \
    \
    # change apache timeout for easier debugging
    && sed -i 's|^Timeout .*$|Timeout 600|g' /etc/apache2/conf.d/default.conf \
    \
    # change php max execution time for easier debugging
    # RUN sed -i 's|^max_execution_time .*$|max_execution_time = 600|g' /etc/php7/php.ini
    && sed -i 's|^max_execution_time .*$|max_execution_time = 900|g' /etc/php7/php.ini \
    \
    # add by huthief 
    && sed -i 's|^zlib.output_compression .*$|zlib.output_compression = On|g' /etc/php7/php.ini \
    && sed -i 's|^max_input_time .*$|max_input_time = 6000|g' /etc/php7/php.ini \
    && sed -i 's|^;max_input_vars .*$|max_input_vars = 1500|g' /etc/php7/php.ini \
    && sed -i 's|^memory_limit .*$|memory_limit = 256M|g' /etc/php7/php.ini \
    && sed -i 's|^post_max_size .*$|post_max_size = 150M|g' /etc/php7/php.ini \
    && sed -i 's|^upload_max_filesize .*$|upload_max_filesize = 150M|g' /etc/php7/php.ini \
    && sed -i 's|^max_file_uploads .*$|max_file_uploads = 100|g' /etc/php7/php.ini \
    && sed -i 's|^;date.timezone .*$|date.timezone = Asia/Taipei|g' /etc/php7/php.ini \
    \
    # add http authentication support
    && sed -i 's|^DocumentRoot|<VirtualHost _default_:80>\n    SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1\n</VirtualHost>\n\nDocumentRoot|g' /etc/apache2/httpd.conf \
    && sed -i 's|<VirtualHost _default_:443>|<VirtualHost _default_:443>\n\nSetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1|g' /etc/apache2/conf.d/ssl.conf \
    \
    # make entry point script executable
    && chmod +x /tmp/start.sh

# configure zsh
ADD --chown=root:root include/zshrc /etc/zsh/zshrc

# configure xdebug
ADD --chown=root:root include/xdebug.ini /etc/php7/conf.d/xdebug.ini

# add php-spx
ADD --chown=root:root include/php-spx/assets/ /usr/share/misc/php-spx/assets/
ADD --chown=root:root include/php-spx/spx.so /usr/lib/php7/modules/spx.so
ADD --chown=root:root include/php-spx/spx.ini /etc/php7/conf.d/spx.ini

# add test pages to site
ADD --chown=root:root html/public/ /var/www/html$DOCUMENT_ROOT/

# set working dir
WORKDIR /var/www/html/

# set entrypoint
ENTRYPOINT ["/tmp/start.sh"]
