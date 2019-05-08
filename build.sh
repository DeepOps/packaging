#!/usr/bin/env bash
set -ex

NAME=slurm-build
TMP_DIST_DIR=./.tmp-dist
DIST_DIR=./dist

build () {
        docker build --pull -t "$NAME" --file="$1" \
                --build-arg DEBFULLNAME="${DEBFULLNAME}" \
                --build-arg DEBEMAIL="${DEBEMAIL}" \
                .
        docker ps -q -a -f "name=$NAME" | xargs -r docker rm
        docker create --name="$NAME" "$NAME"
        rm -rf "$TMP_DIST_DIR"
        docker cp "${NAME}:/dist" "$TMP_DIST_DIR"
        docker rm "$NAME"
        mkdir -p "$DIST_DIR"
        cp "$TMP_DIST_DIR"/* "$DIST_DIR"
        rm -rf "$TMP_DIST_DIR"
}

build_bionic () {
        build Dockerfile.bionic-ppa
}

build_centos7 () {
        build Dockerfile.centos7
}

case "$1" in
        bionic)
                build_bionic
                ;;
        centos7)
                build_centos7
                ;;
        all)
                build_bionic
                build_centos
                ;;
        *)
                echo "Usage: $0 [bionic|centos7|all]"
                exit 1
                ;;
esac
