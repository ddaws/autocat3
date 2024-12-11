#!/bin/sh

# Find the latest dump file
LATEST_DUMP=$(ls -t /tmp/dumps/*.pg_dump | head -n1)

if [ -z "$LATEST_DUMP" ]; then
    echo "No dump files found in /tmp/dumps"
    exit 1
fi

echo "Restoring from latest dump: $LATEST_DUMP"

# Run pg_restore using Docker
docker run --rm --network host \
    -v "$LATEST_DUMP:/latest.pg_dump" \
    postgres:10.23-alpine \
    pg_restore -h localhost -p 5432 -U postgres -d gutenberg -v -c "/latest.pg_dump"

echo "Restore completed"
