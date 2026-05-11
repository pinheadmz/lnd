#!/usr/bin/env bash

set -ev

REPO=pinheadmz/bitcoin
BITCOIND_VERSION=pr35182
TAG_SUFFIX=-e8e4cb3238

docker pull ${REPO}:${BITCOIND_VERSION}${TAG_SUFFIX}
CONTAINER_ID=$(docker create ${REPO}:${BITCOIND_VERSION}${TAG_SUFFIX})
sudo docker cp $CONTAINER_ID:/opt/bin/bitcoind /usr/local/bin/bitcoind
docker rm $CONTAINER_ID

# "How ironic..."
# Even though the HTTP server is replaced, bitcoind still links dynamically
# to libevent in the PR branch. Since the binary is being copied out of
# the container it was built in, we need to install this on the ci platform itself.
sudo apt install -y libevent-dev
