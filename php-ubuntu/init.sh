#!/bin/bash
set -e

echo "init.sh WAS executed!!!!!"

# Setup writable directories and symlink
mkdir -p /var/www/web/sites/default/files /var/www/vendor /var/www/core
chown -R www-data:www-data /var/www/web/sites/default/files /var/www/vendor /var/www/core
chmod -R u=rwX,g=rX,o=rX /var/www/web/sites/default/files /var/www/vendor /var/www/core
ln -sfn /var/www/web /var/www/html

# Always run composer install
echo "Installing composer dependencies..."
composer install --prefer-dist --no-interaction --no-progress || {
  echo "Composer install failed"
  exit 1
}

# Clear Drupal cache if Drush is available
if [ -f "./vendor/bin/drush" ]; then
  echo "Clearing Drupal cache..."
  ./vendor/bin/drush cr || echo "Drush cache clear failed but continuing..."
else
  echo "Drush not found. Skipping cache clear."
fi

# Start Supervisor
echo "Starting supervisord..."
exec /usr/bin/supervisord -n

