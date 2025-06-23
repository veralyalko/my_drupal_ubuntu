#!/bin/bash

set -e

echo "Updating CA certificates..."
apt-get update && apt-get install -y ca-certificates

# Install PostgreSQL client if not installed
if ! command -v psql >/dev/null 2>&1; then
  echo "Installing PostgreSQL client..."
  apt-get install -y wget curl gnupg lsb-release software-properties-common
  echo "deb [signed-by=/usr/share/keyrings/postgres.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgres.gpg
  apt-get update && apt-get install -y postgresql-client-16
fi

# Trust custom certs
echo "Installing custom CA certs..."
mkdir -p /usr/local/share/ca-certificates/custom
cp /app/certs/*.crt /usr/local/share/ca-certificates/custom/
update-ca-certificates
cp /app/certs/MenloSecurityRootH1.crt /etc/ssl/certs/MenloSecurityRootH1.pem
c_rehash /etc/ssl/certs
cat /etc/ssl/certs/MenloSecurityRootH1.pem >> /etc/ssl/certs/ca-certificates.crt

# Install Composer if not found
if ! command -v composer >/dev/null 2>&1; then
  echo "Installing Composer..."
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
else
  echo "Composer already installed."
fi

