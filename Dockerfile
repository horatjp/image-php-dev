FROM mcr.microsoft.com/vscode/devcontainers/php:8.2

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    imagemagick \
    libc-client-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libmagickwand-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libwebp-dev \
    libxslt-dev \
    libzip-dev \
    mariadb-client \
    postgresql-client \
    sqlite3 \
    supervisor \
    unzip \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN pecl install imagick mailparse redis-6.0.2 xdebug-3.3.1 \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-enable imagick mailparse redis xdebug \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    imap \
    intl \
    mysqli \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pgsql \
    xml \
    zip \
    && pecl clear-cache

COPY php-config/php.ini /usr/local/etc/php/conf.d/
COPY php-config/xdebug.ini /usr/local/etc/php/conf.d/
