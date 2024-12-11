#!/bin/sh

# Set default directory or use the first argument if provided
DUMPS_DIR=${1:-docker/postgres/dumps}

# Find the latest dump file
LATEST_DUMP=$(ls -t "$DUMPS_DIR"/*.pg_dump 2>/dev/null | head -n1)

if [ -z "$LATEST_DUMP" ]; then
    echo "No dump files found in $DUMPS_DIR"
    exit 1
fi

echo "Restoring from latest dump: $LATEST_DUMP"

# Run pg_restore using Docker
docker run --rm --network host \
    -v "$LATEST_DUMP:/latest.pg_dump" \
    postgres:10.23-alpine \
    pg_restore -h localhost -p 5432 -U postgres -d gutenberg -v -c "/latest.pg_dump"

echo "Restore completed"
