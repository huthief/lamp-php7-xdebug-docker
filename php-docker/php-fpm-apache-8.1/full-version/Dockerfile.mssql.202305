# ====================================
# Ubuntu + PHP + Apache + FPM
# source : https://github.com/shinsenter/php
#（承上）預設安裝的PHP模組 https://github.com/shinsenter/php#pre-installed-php-modules
#（ 承上）上面專案是繼承此專案 https://github.com/serversideup/docker-php
# ====================================
#   設定檔位置
#   (沒用)/usr/local/etc/php -> /etc/php/cli
#   (使用中)/usr/local/etc/php-fpm -> /etc/php/fpm
#
# ====================================
# 20230503  加入MSSQL Driver
# 20230218  初版。自行加入ghostscript, vim, 調整ImageMagick使之可以讀pdf產出圖檔
# 
# #0 6.398 You should add "extension=mcrypt.so" to php.ini
# ====================================
#FROM shinsenter/phpfpm-apache:php8.1-tidy
FROM shinsenter/php:8.1-fpm-apache


# Control your timezone
ENV TZ="Asia/Taipei"

# Sets the directory from which Apache will serve files
ENV WEBHOME="/var/www/html"

# Set Apache root folder within $WEBHOME
# E.g: APACHE_DOCUMENT_ROOT="/public"
ENV APACHE_DOCUMENT_ROOT=""
# 不要自動生成index.php
ENV AUTO_CREATE_INDEX_FILE=false

# set ENABLE_CRONTAB=true to enable crontab
ENV ENABLE_CRONTAB=true

# 設定apache 運行的使用者ID與所屬GROUP ID
ENV PUID=1000
ENV PGID=100

# Show PHP errors on screen
ENV PHP_DISPLAY_ERRORS="Off"

# Set the maximum time in seconds a script is allowed
# to run before it is terminated by the parser
ENV PHP_MAX_EXECUTION_TIME="600"

# Set the maximum amount of memory in bytes that a script is allowed to allocate
ENV PHP_MEMORY_LIMIT="256M"

# Limit the files that can be accessed by PHP to the specified directory-tree
# Default: PHP_OPEN_BASEDIR="$WEBHOME"

# Sets max size of post data allowed
ENV PHP_POST_MAX_SIZE="150M"

# The maximum size of an uploaded file
ENV PHP_UPLOAD_MAX_FILE_SIZE="150M"

# The maximum amount of input variables accepted
ENV PHP_UPLOAD_MAX_INPUT_VARS="15000"

# 設定ImageMagick參數位置
ARG imagemagic_config=/etc/ImageMagick-6/policy.xml

# for MSSQL DRIVE
#ENV ACCEPT_EULA=Y

RUN apt-get update && apt-get install -y --no-install-recommends \
    ghostscript \
    locales \
    vim \
    apt-transport-https \
    gnupg2 \
    libpng-dev \
    libzip-dev \
    unzip \
    curl \
    ca-certificates \
    \
    && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && echo 'zh_TW.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen \
    && phpaddmod imagick \
    # 調整設定使其可以產製PDF
    && if [ -f $imagemagic_config ] ; then sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' $imagemagic_config ; else echo did not see file $imagemagic_config ; fi \
    # Re-enable GhostScript formats in ImageMagick
    && sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml \
    && a2enmod rewrite \
    ## 安裝 MSSQL
    #&& cat /etc/os-release \
    #&& apt-get update \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools18 \
    && printf '\nexport PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc \
    && apt-get install -y unixodbc-dev \
    && printf "; priority=20\nextension=php_sqlsrv_81_nts.so\n" > /etc/php/8.1/mods-available/sqlsrv.ini \
    && printf "; priority=30\nextension=php_pdo_sqlsrv_81_nts.so\n" > /etc/php/8.1/mods-available/pdo_sqlsrv.ini \
    && ln -s /etc/php/8.1/mods-available/pdo_sqlsrv.ini /etc/php/8.1/fpm/conf.d/30-pdo_sqlsrv.ini \
    && ln -s /etc/php/8.1/mods-available/sqlsrv.ini /etc/php/8.1/fpm/conf.d/20-sqlsrv.ini \
    && apt-get autoremove -y \
    && apt-get clean \
    # && rm -Rexitf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \ 
    # cleanup
    && rm -rf /var/log/php-fpm \
    && rm -rf /var/log/apache2 /var/www/html/* /tmp/* /var/tmp/* \
    ## 將慢日誌丟出來
    #&& ln -sf /dev/stderr /var/log/php-fpm/slow.log \
    #&& ln -sf /dev/stderr /var/log/php-fpm/error.log \
    && rm -rf /var/lib/apt/lists/*

# 複製sql server php so
COPY ./sqlsrv/* /usr/lib/php/20210902/