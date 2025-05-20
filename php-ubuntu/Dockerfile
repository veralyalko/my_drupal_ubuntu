FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    unzip \
    apt-transport-https && \
    update-ca-certificates

# Add trusted CA certs individually
COPY certs/DoD_Root_CA_3.crt /usr/local/share/ca-certificates/
COPY certs/DoD_Root_CA_4.crt /usr/local/share/ca-certificates/
COPY certs/DoD_Root_CA_5.crt /usr/local/share/ca-certificates/
COPY certs/DoD_Root_CA_6.crt /usr/local/share/ca-certificates/
COPY certs/ecma-wcf-trusted.crt /usr/local/share/ca-certificates/
COPY certs/SSLcom-TLS-Root-2022-RSA.crt /usr/local/share/ca-certificates/
COPY certs/SSLcom-TLS-Root-2022-ECC.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Optional: Verify certs
RUN ls -l /usr/local/share/ca-certificates && cat /etc/ca-certificates.conf

# Add PHP repository
RUN apt-get update && apt-get install -y gnupg2 && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update

# Install PHP, Nginx, Supervisor and other dependencies
RUN apt-get install -y \
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

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer   

# Ensure PHP-FPM is accessible via standard path
RUN ln -sf /usr/sbin/php-fpm8.2 /usr/sbin/php-fpm

# Create PHP socket directory
RUN mkdir -p /run/php && chmod 755 /run/php && chown www-data:www-data /run/php

# Set working directory
WORKDIR /var/www

# Copy Drupal project
COPY . /var/www

RUN mkdir -p /var/www/web/sites/default/files && \
    chown -R www-data:www-data /var/www/web/sites/default/files && \
    chmod -R 755 /var/www/web/sites/default/files

# Copy configuration files last (to avoid overwrite)
COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY php-ubuntu/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose HTTP
EXPOSE 80

# Run Supervisor
CMD ["/usr/bin/supervisord", "-n"]




# FROM ubuntu:22.04

# # Avoid interactive prompts
# ENV DEBIAN_FRONTEND=noninteractive

# # Install base packages and update CA certs
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ca-certificates \
#     curl \
#     wget \
#     gnupg2 \
#     lsb-release \
#     software-properties-common \
#     unzip \
#     apt-transport-https && \
#     update-ca-certificates

# # Copy custom SSL certs
# COPY certs/*.crt /usr/local/share/ca-certificates/
# COPY certs/*.pem /usr/local/share/ca-certificates/

# RUN update-ca-certificates

# # Install PHP repo separately to avoid cert issues during HTTPS calls
# RUN add-apt-repository ppa:ondrej/php -y

# # Install PHP, Nginx, and other packages
# RUN apt-get update && apt-get install -y \
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

# # Set working directory
# WORKDIR /var/www

# # Copy configuration files
# COPY nginx.conf /etc/nginx/nginx.conf
# COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
# COPY php-ubuntu/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# # Add Composer from official image
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Copy your Drupal project
# COPY . /var/www

# # Expose HTTP port
# EXPOSE 80

# # Start services via Supervisor
# CMD ["/usr/bin/supervisord", "-n"]






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