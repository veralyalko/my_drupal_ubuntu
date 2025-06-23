#!/bin/bash

set -e

apt-get update && apt-get install -y wget curl ca-certificates gnupg lsb-release software-properties-common

echo "Setting up PostgreSQL APT source..."
echo "deb [signed-by=/usr/share/keyrings/postgres.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgres.gpg
apt-get update && apt-get install -y postgresql-client-16

echo "Adding custom certificates..."
mkdir -p /usr/local/share/ca-certificates/custom
cp /app/certs/*.crt /usr/local/share/ca-certificates/custom/
update-ca-certificates

cp /app/certs/MenloSecurityRootH1.crt /etc/ssl/certs/MenloSecurityRootH1.pem
c_rehash /etc/ssl/certs
cat /etc/ssl/certs/MenloSecurityRootH1.pem >> /etc/ssl/certs/ca-certificates.crt
