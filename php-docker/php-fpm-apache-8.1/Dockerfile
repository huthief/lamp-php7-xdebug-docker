# This file belongs to the project https://code.shin.company/php
# Author:  Shin <shin@shin.company>
# License: https://code.shin.company/php/blob/main/LICENSE
################################################################################

ARG BASE_IMAGE=shinsenter/php
ARG PHP_VERSION=8.1

# 設定ImageMagick參數位置
ARG imagemagic_config=/etc/ImageMagick-6/policy.xml

################################################################################

# base image
FROM ${BASE_IMAGE}:${PHP_VERSION}-fpm

ARG APACHE_BUILD_DEPS="gnupg2 apt-utils"
ARG APACHE_PPA_KEY="4F4EA0AAE5267A6C"
ARG APACHE_PPA_URL="http://ppa.launchpadcontent.net/ondrej/apache2/ubuntu"

################################################################################

# installs apache
RUN echo "Installing Apache" \
    && apt-update \
    && apt-get install -y --no-install-recommends \
    ghostscript \
    locales \
    vim \
    && apt-install $APACHE_BUILD_DEPS \
    && apt-deb ppa-apache ${APACHE_PPA_URL} ${APACHE_PPA_KEY} \
    && apt-install apache2 && disable apache2 \
    && echo "ServerName localhost" >>/etc/apache2/apache2.conf \
    && sed -i 's/LogFormat "%h %l %u %t \\\"%r\\\" %>s %O \\\"/LogFormat "%a %l %u %t \\\"%r\\\" %>s %O \\\"/' /etc/apache2/apache2.conf \
    && echo >>/etc/apache2/envvars \
    && echo "export DOCUMENT_ROOT=\"\${WEBHOME}\${APACHE_DOCUMENT_ROOT}\"" >>/etc/apache2/envvars \
    && echo "export APACHE_RUN_USER=\${WEBUSER}" >>/etc/apache2/envvars \
    && echo "export APACHE_RUN_GROUP=\${WEBGROUP}" >>/etc/apache2/envvars \
    \
    # modifies Apache modules
    && a2dismod \
        mpm_prefork mpm_worker \
    && a2enmod \
        actions autoindex brotli cache deflate expires headers http2 \
        mpm_event proxy proxy_fcgi remoteip rewrite setenvif ssl unique_id \
    # add by huthief
    && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && echo 'zh_TW.UTF-8 UTF-8' >> /etc/locale.gen \
    locale-gen \
    && phpaddmod imagick \
    # 調整設定使其可以產製PDF
    #&& if [ -f $imagemagic_config ] ; then sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' $imagemagic_config ; else echo did not see file $imagemagic_config ; fi \
    # Re-enable GhostScript formats in ImageMagick
    #&& sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml \
    && a2enmod rewrite \
    # cleanup
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/log/apache2 ${WEBHOME}/*.html \
    && apt-upgrade -uq \
    && cleanup $APACHE_BUILD_DEPS

# adds config files
ADD root/ /

# sets the working directory
# WORKDIR $WEBHOME

# exposes ports
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

# sets default entrypoint
ENTRYPOINT ["/init"]

################################################################################

# sets env variables
ENV APACHE_DOCUMENT_ROOT=""
ENV APACHE_MAX_CONNECTIONS_PER_CHILD=0
ENV APACHE_MAX_REQUEST_WORKERS=150
ENV APACHE_MAX_SPARE_THREADS=75
ENV APACHE_MIN_SPARE_THREADS=10
ENV APACHE_START_SERVERS=2
ENV APACHE_THREAD_LIMIT=64
ENV APACHE_THREADS_PER_CHILD=25

################################################################################
# add by huthief
#
################################################################################
# Control your timezone
ENV TZ="Asia/Taipei"

# Sets the directory from which Apache will serve files
ENV WEBHOME="/var/www/html"

# Set Apache root folder within $WEBHOME
# E.g: APACHE_DOCUMENT_ROOT="/public"
ENV APACHE_DOCUMENT_ROOT=""

# set ENABLE_CRONTAB=true to enable crontab
ENV ENABLE_CRONTAB=true

ENV PUID=1000
ENV PGID=100
################################################################################

LABEL traefik.enable=true