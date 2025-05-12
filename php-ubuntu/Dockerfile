# FROM php:8.3-fpm

# # Install PHP extensions + system tools
# RUN apt-get update && apt-get install -y \
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
#     && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache \
#     && pecl install xdebug \
#     && docker-php-ext-enable xdebug \
#     && echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     && echo "xdebug.log_level=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# # Set working directory
# WORKDIR /var/www

# # Add Composer binary (from the official Composer image)
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Copy the Drupal codebase from the build context (root folder)
# COPY . /var/www

# # Install PHP dependencies via Composer

FROM php:8.3-fpm

# Install PHP extensions + system tools
RUN apt-get update && apt-get install -y \
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
    # && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache \
    # && pecl install xdebug \
    # && docker-php-ext-enable xdebug \
    # && echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.log_level=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Set working directory
WORKDIR /var/www

# Add Composer binary (from the official Composer image)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the Drupal codebase from the build context (root folder)
COPY . /var/www

# Install PHP dependencies via Composer
RUN composer install --no-interaction --prefer-dist --no-dev


FROM php:8.3-fpm

# Install PHP extensions + system tools
RUN apt-get update && apt-get install -y \
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
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# OPTIONAL: Install and configure Xdebug (comment out for production)
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 
    # \
    # && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.log_level=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Set working directory
WORKDIR /var/www

# Add Composer binary (from the official Composer image)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy only composer files to leverage Docker layer caching
COPY composer.json composer.lock /var/www/

# Install PHP dependencies via Composer
RUN composer install --no-interaction --prefer-dist --no-dev

# Now copy the rest of the project
COPY . /var/www
