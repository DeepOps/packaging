#!/usr/bin/env bash
set -ex

SLURM_VERSION=18.08.6-2

NAME=slurm-build
DIST_DIR=./dist

build () {
        docker build --pull -t "$NAME" --file="$1" --build-arg SLURM_VERSION="$SLURM_VERSION" .
        docker ps -q -a -f "name=$NAME" | xargs -r docker rm
        docker create --name="$NAME" "$NAME"
        rm -rf "$DIST_DIR"
        docker cp "${NAME}:/dist" "$DIST_DIR"
        docker rm "$NAME"
        cp "$DIST_DIR"/* .
}

build_bionic () {
        build Dockerfile.bionic
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
