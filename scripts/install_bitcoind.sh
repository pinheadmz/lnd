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

# bitcoind from PR #35182 was built against Debian trixie and links
# dynamically against split libevent sub-libs (core/extra/pthreads) plus
# libzmq, libsodium and libsqlite3. Install all of them on the CI host
# so bitcoind can actually start; otherwise it dies silently and tests
# fail with "connection refused" against the RPC port.
sudo apt-get update -qq
sudo apt-get install -y \
    libevent-2.1-7t64 \
    libevent-core-2.1-7t64 \
    libevent-extra-2.1-7t64 \
    libevent-pthreads-2.1-7t64 \
    libzmq5 \
    libsodium23 \
    libsqlite3-0

# Sanity check: if this fails, the error is visible in CI logs instead of
# manifesting as a mysterious RPC connection refused later.
bitcoind -version
