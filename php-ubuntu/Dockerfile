FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Add the Sury PHP 8.3 repo
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    ca-certificates \
    apt-transport-https \
    gnupg \
    && curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/php.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/php.list

# Install PHP 8.3, extensions, and Xdebug
RUN apt-get update && apt-get install -y \
    php8.3 \
    php8.3-fpm \
    php8.3-cli \
    php8.3-mysql \
    php8.3-xml \
    php8.3-curl \
    php8.3-mbstring \
    php8.3-gd \
    php8.3-bcmath \
    php8.3-zip \
    php8.3-xdebug \
    mariadb-client \
    unzip \
    zip \
    nano \
    git

# Update www.conf to use TCP port 9000 instead of Unix socket
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.3/fpm/pool.d/www.conf

# Set working directory
WORKDIR /var/www

# Copy your Drupal project
COPY . /var/www

# Start PHP-FPM in foreground
CMD ["php-fpm8.3", "-F"]



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
#     && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache \
#     && pecl install -f xdebug \
#     && docker-php-ext-enable xdebug
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
