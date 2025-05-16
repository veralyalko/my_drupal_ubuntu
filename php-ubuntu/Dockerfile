FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages and update CA certs
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    unzip && \
    update-ca-certificates

# Copy custom SSL certs
COPY certs/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Enable PHP 8.2 from Ondrej PPA
RUN add-apt-repository ppa:ondrej/php -y && \
    apt-get update && apt-get install -y \
    nginx \
    php8.2-fpm \
    php8.2-cli \
    php8.2-mysql \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-pgsql \
    php8.2-curl \
    php8.2-gd \
    php8.2-zip \
    php8.2-bcmath \
    php8.2-soap \
    php8.2-intl \
    php8.2-xdebug \
    supervisor \
    git \
    unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure php-fpm is available at standard path
RUN ln -sf /usr/sbin/php-fpm8.2 /usr/sbin/php-fpm

# Create PHP socket directory
RUN mkdir -p /run/php && chown www-data:www-data /run/php && chmod 755 /run/php

# Set working directory
WORKDIR /var/www

# Copy config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY php-ubuntu/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy your Drupal project
COPY . /var/www

# Expose HTTP port
EXPOSE 80

# Start services via Supervisor
CMD ["/usr/bin/supervisord", "-n"]




# FROM ubuntu:22.04

# # Avoid interactive prompts
# ENV DEBIAN_FRONTEND=noninteractive

# # Install base packages and update CA certs
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ca-certificates \
#     curl \
#     wget \
#     gnupg \
#     lsb-release \
#     software-properties-common \
#     unzip && \
#     update-ca-certificates

# # Enable PHP 8.2 from Ondrej PPA
# RUN add-apt-repository ppa:ondrej/php -y && \
#     apt-get update && apt-get install -y \
#     nginx \
#     php8.2-fpm \
#     php8.2-cli \
#     php8.2-mysql \
#     php8.2-mbstring \
#     php8.2-xml \
#     php8.2-pgsql \
#     php8.2-curl \
#     php8.2-gd \
#     php8.2-zip \
#     php8.2-bcmath \
#     php8.2-soap \
#     php8.2-intl \
#     php8.2-xdebug \
#     supervisor \
#     git \
#     unzip && \
#     apt-get clean && rm -rf /var/lib/apt/lists/*

# # Ensure php-fpm is available at standard path
# RUN ln -sf /usr/sbin/php-fpm8.2 /usr/sbin/php-fpm

# # Create PHP socket directory
# RUN mkdir -p /run/php && chown www-data:www-data /run/php && chmod 755 /run/php






# # Copy Composer binary from official image
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Copy your Drupal project
# COPY . /var/www

# (Optional) Ensure config/sync exists and is writable
# RUN mkdir -p /var/www/config/sync && \
#     chown -R www-data:www-data /var/www/config && \
#     chmod -R 755 /var/www/config

# # Set Composer environment
# ENV COMPOSER_ALLOW_SUPERUSER=1 \
#     COMPOSER_DISABLE_XDEBUG_WARN=1 \
#     COMPOSER_SECURE_HTTP=false

# Install Composer dependencies (optional – uncomment if needed)
# RUN composer install --no-interaction --prefer-dist

# Set working directory
WORKDIR /var/www

# Copy config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY php-ubuntu/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy your Drupal project
COPY . /var/www

# Expose HTTP port
EXPOSE 80

# Start services via Supervisor
CMD ["/usr/bin/supervisord", "-n"]

# Version php:8.3-fpm with xdebug using pecl
# FROM php:8.3-fpm

# # Set higher PHP socket timeout to avoid PECL install failures on slow networks
# RUN echo "default_socket_timeout=600" > /usr/local/etc/php/conf.d/99-timeout.ini

# # Update APT with retries and timeouts for slow environments
# RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout="60" && apt-get install -y \
#     ca-certificates \
#     git \
#     curl \
#     libpng-dev \
#     libjpeg-dev \
#     libfreetype6-dev \
#     libonig-dev \
#     libxml2-dev \
#     zip \
#     unzip \
#     mariadb-client \
#     libzip-dev \
#     nano \
#     # 👇 These are required for building and installing Xdebug
#     autoconf \
#     gcc \
#     make \
#     pkg-config \
#     libtool \
#     && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache
#     # && pecl install -f xdebug \
#     # && docker-php-ext-enable xdebug
#     # && docker-php-ext-enable xdebug \
#     # && echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.log_level=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# # Set working directory
# WORKDIR /var/www

# # Add Composer binary from the official Composer image
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Optional: Pre-copy composer files and install dependencies
# # COPY composer.json composer.lock /var/www/
# # RUN composer install --no-interaction --prefer-dist --no-dev

# # Now copy the rest of your Drupal project
# COPY . /var/www


# Version php:8.3-fpm with xdebug using curl
# FROM php:8.3-fpm

# # Install system and PHP build dependencies
# RUN apt-get update && apt-get install -y \
#     autoconf \
#     gcc \
#     make \
#     git \
#     curl \
#     unzip \
#     libtool \
#     pkg-config \
#     libxml2-dev \
#     libzip-dev \
#     libpng-dev \
#     libjpeg-dev \
#     libfreetype6-dev \
#     libonig-dev \
#     default-mysql-client \
#     default-libmysqlclient-dev \
#     nano \
#     && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# # Download and compile Xdebug from source
# RUN mkdir -p /usr/src/php/ext \
#     && cd /usr/src/php/ext \
#     && curl -fsSL https://github.com/xdebug/xdebug/archive/refs/tags/3.3.1.zip -o xdebug.zip \
#     && unzip xdebug.zip && mv xdebug-3.3.1 xdebug && rm xdebug.zip \
#     && cd xdebug \
#     && phpize \
#     && ./configure \
#     && make \
#     && make install \
#     && docker-php-ext-enable xdebug

# # # Configure Xdebug
# # RUN echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
# #     && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
# #     && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
# #     && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
# #     && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
# #     && echo "xdebug.log_level=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# # Set working directory
# WORKDIR /var/www

# # Add Composer from official image
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Copy your Drupal project
# COPY . /var/www