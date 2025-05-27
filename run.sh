#!/bin/bash
set -e

COMMAND=$1

case "$COMMAND" in
  up-d)
    echo "Starting containers in background..."
    docker-compose up -d
    ;;
  up)
    echo "Starting containers with full output..."
    docker-compose up
    ;;
  logs)
    echo "Streaming logs for 'drupal' container..."
    docker-compose logs -f drupal
    ;;
  exec)
    echo "Opening shell inside 'drupal' container..."
    docker-compose exec drupal bash
    ;;
  stop)
    echo "Stopping and removing all containers..."
    docker-compose down
    ;;
  rebuild)
    echo "Rebuilding from scratch (with volume cleanup)..."
    docker-compose down -v
    docker-compose build --no-cache
    docker-compose up -d
    ;;
  build)
    echo "Building containers without cache..."
    docker-compose build --no-cache
    ;;
  drush-cr)
    echo "Running drush cr..."
    docker-compose exec drupal ./vendor/bin/drush cr
    ;;
  drush-status)
    echo "Getting drush status..."
    docker-compose exec drupal ./vendor/bin/drush status
    ;;
  drush-cim)
    echo "Importing Drupal configuration..."
    docker-compose exec drupal ./vendor/bin/drush cim -y
    ;;
  drush-cex)
    echo "Exporting Drupal configuration..."
    docker-compose exec drupal ./vendor/bin/drush cex -y
    ;;
  drush-updb)
    echo "Running Drupal database updates..."
    docker-compose exec drupal ./vendor/bin/drush updb -y
    ;;
  drush-uli)
    echo "Generating one-time login link..."
    docker-compose exec drupal ./vendor/bin/drush uli
    ;;
  composer)
    echo "Running Composer in 'drupal' container..."
    shift
    docker-compose exec drupal composer "$@"
    ;;
  shell-db)
    echo "Opening PostgreSQL shell..."
    docker-compose exec db psql -U drupal10 -d drupal10
    ;;
  export-db)
    echo "Exporting PostgreSQL database to ./db/db.sql..."
    mkdir -p ./db
    docker-compose exec db pg_dump -U drupal10 -d drupal10 > ./db/db.sql
    echo "Database export complete: ./db/db.sql"
    ;;
  import-db)
    read -p "Enter path to SQL file (default: ./db/db.sql): " SQL_PATH
    SQL_PATH=${SQL_PATH:-./db/db.sql}

    if [ ! -f "$SQL_PATH" ]; then
      echo "File not found: $SQL_PATH"
      exit 1
    fi

    echo "Importing $SQL_PATH into PostgreSQL database..."
    cat "$SQL_PATH" | docker-compose exec -T db psql -U drupal10 -d drupal10
    echo "Database import complete."
    ;;
  status)
    echo "Showing container status..."
    docker-compose ps
    ;;
  clean)
    echo "Cleaning up unused containers, images, and volumes..."
    docker system prune -a --volumes -f
    ;;
  help|*)
    echo "Available commands:"
    echo "  ./run.sh up-d             - Start containers in background"
    echo "  ./run.sh up               - Start containers with output"
    echo "  ./run.sh logs             - View Drupal container logs"
    echo "  ./run.sh exec             - Shell into Drupal container"
    echo "  ./run.sh stop             - Stop and remove containers"
    echo "  ./run.sh rebuild          - Full rebuild with volume cleanup"
    echo "  ./run.sh build            - Build containers without cache"
    echo "  ./run.sh drush-cr         - Run drush cache rebuild"
    echo "  ./run.sh drush-status     - Show drush status"
    echo "  ./run.sh drush-cim        - Import Drupal configuration"
    echo "  ./run.sh drush-cex        - Export Drupal configuration"
    echo "  ./run.sh drush-updb       - Run database updates"
    echo "  ./run.sh drush-uli        - Generate one-time login link"
    echo "  ./run.sh composer [...]   - Run Composer in container"
    echo "  ./run.sh shell-db         - Open PostgreSQL shell"
    echo "  ./run.sh export-db        - Export DB to ./db/db.sql"
    echo "  ./run.sh import-db        - Import DB from local .sql file"
    echo "  ./run.sh status           - Show container status"
    echo "  ./run.sh clean            - Remove unused Docker resources"
    echo "  ./run.sh help             - Show this help menu"
    ;;
esac

