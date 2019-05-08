#!/usr/bin/env bash
set -ex

NAME=slurm-build
TMP_DIST_DIR=./.tmp-dist
DIST_DIR=./dist

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 dir"
    exit 1
fi

docker build --pull -t "$NAME" \
    --build-arg DEBFULLNAME="${DEBFULLNAME}" \
    --build-arg DEBEMAIL="${DEBEMAIL}" \
    "$1"
docker ps -q -a -f "name=$NAME" | xargs -r docker rm
docker create --name="$NAME" "$NAME"
rm -rf "$TMP_DIST_DIR"
docker cp "${NAME}:/dist" "$TMP_DIST_DIR"
docker rm "$NAME"
mkdir -p "$DIST_DIR"
cp "$TMP_DIST_DIR"/* "$DIST_DIR"
rm -rf "$TMP_DIST_DIR"
