#!/usr/bin/env bash

set -ev

# Integration-test build: pull bitcoind from a custom image built from
# bitcoin/bitcoin#35182 (HTTP server rewrite). This script ignores any
# version argument; the image tag is pinned here.
REPO=pinheadmz/bitcoin
BITCOIND_VERSION=pr35182
TAG_SUFFIX=-ddefe4263b

docker pull ${REPO}:${BITCOIND_VERSION}${TAG_SUFFIX}
CONTAINER_ID=$(docker create ${REPO}:${BITCOIND_VERSION}${TAG_SUFFIX})
sudo docker cp $CONTAINER_ID:/opt/bin/bitcoind /usr/local/bin/bitcoind
docker rm $CONTAINER_ID

# Even though the HTTP server is replaced, bitcoind still links dynamically
# to libevent in the PR branch. Since the binary is being copied out of
# the container it was built in, libevent needs to be installed on the CI host.
sudo apt-get install -y libevent-dev
