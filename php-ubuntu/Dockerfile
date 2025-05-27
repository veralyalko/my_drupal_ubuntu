# Step 1: Get Composer binary
FROM composer:latest AS composer

# Step 2: Main Drupal environment
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
    apt-transport-https \
    iputils-ping \
    openssl \
    git

# Copy trusted root certificates
COPY certs/DoD_Root_CA_3.crt /usr/local/share/ca-certificates/
COPY certs/DoD_Root_CA_4.crt /usr/local/share/ca-certificates/
COPY certs/DoD_Root_CA_5.crt /usr/local/share/ca-certificates/
COPY certs/DoD_Root_CA_6.crt /usr/local/share/ca-certificates/
COPY certs/ecma-wcf-trusted.crt /usr/local/share/ca-certificates/
COPY certs/SSLcom-TLS-Root-2022-RSA.crt /usr/local/share/ca-certificates/
COPY certs/SSLcom-TLS-Root-2022-ECC.crt /usr/local/share/ca-certificates/

# Update CA trust store (for standard certs)
RUN update-ca-certificates

# Copy Menlo cert directly to OpenSSL cert store and manually trust it
COPY certs/MenloSecurityRootH1.crt /etc/ssl/certs/MenloSecurityRootH1.pem

# Rehash and append Menlo cert to system trust bundle
RUN c_rehash /etc/ssl/certs && \
    cat /etc/ssl/certs/MenloSecurityRootH1.pem >> /etc/ssl/certs/ca-certificates.crt

# Add PHP repository
RUN apt-get update && apt-get install -y gnupg2 && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update

# Install PHP, Nginx, Supervisor and dependencies
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
    unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Use Composer from Step 1
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Make sure PHP-FPM is accessible via standard path
RUN ln -sf /usr/sbin/php-fpm8.2 /usr/sbin/php-fpm

# Create PHP socket directory
RUN mkdir -p /run/php && chmod 755 /run/php && chown www-data:www-data /run/php

# Set working directory
WORKDIR /var/www

# Copy Drupal project
COPY . /var/www

# Copy init script (place it outside the bind-mounted /var/www)
COPY php-ubuntu/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Set permissions
RUN mkdir -p /var/www/web/sites/default/files && \
    chown -R www-data:www-data /var/www/web/sites/default/files && \
    chmod -R 755 /var/www/web/sites/default/files

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY php-ubuntu/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set ownership and permissions for writable directories
RUN mkdir -p /var/www/web/sites/default/files /var/www/vendor /var/www/core && \
    chown -R www-data:www-data /var/www/web/sites/default/files /var/www/vendor /var/www/core && \
    chmod -R u=rwX,g=rX,o=rX /var/www/web/sites/default/files /var/www/vendor /var/www/core && \
    chmod 644 /var/www/web/sites/default/settings.php || true

# Expose HTTP
EXPOSE 80

# Run init script on container start
CMD ["/usr/local/bin/init.sh"]