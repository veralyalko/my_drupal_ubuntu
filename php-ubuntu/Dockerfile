FROM php:8.3-fpm

# Set higher PHP socket timeout to avoid PECL install failures on slow networks
RUN echo "default_socket_timeout=600" > /usr/local/etc/php/conf.d/99-timeout.ini

# Update APT with retries and timeouts for slow environments
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout="60" && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    mariadb-client \
    libzip-dev \
    nano \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache \
    && pecl install -f xdebug >> /tmp/xdebug-install.log 2>&1 \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.log_level=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Set working directory
WORKDIR /var/www

# Add Composer binary from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Optional: Pre-copy composer files and install dependencies
# COPY composer.json composer.lock /var/www/
# RUN composer install --no-interaction --prefer-dist --no-dev

# Now copy the rest of your Drupal project
COPY . /var/www