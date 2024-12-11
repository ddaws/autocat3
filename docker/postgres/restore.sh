#!/bin/sh

# Set default directory or use the first argument if provided
SCRIPT_DIR="$(dirname "$0")"
DUMPS_DIR=${1:-./docker/postgres/dumps}

# Find the latest dump file
LATEST_DUMP=$(ls -t "$DUMPS_DIR"/*.pg_dump 2>/dev/null | head -n1)

if [ -z "$LATEST_DUMP" ]; then
    echo "No dump files found in $DUMPS_DIR"
    exit 1
fi

echo "Restoring from latest dump: $LATEST_DUMP"

# Run pg_restore using Docker
docker run --rm --network host \
    -v "${LATEST_DUMP}:/tmp/latest.pg_dump" \
    --env-file "${SCRIPT_DIR}/postgres.env" \
    postgres:10.23-alpine \
    sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" pg_restore -h localhost -p 5432 -U "$POSTGRES_USER" -d "$POSTGRES_DB" "/tmp/latest.pg_dump"'

echo "Restore completed"
