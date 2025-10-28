#!/usr/bin/env bash

set -ev

sudo apt-get install -y build-essential cmake pkgconf python3 libevent-dev libboost-dev libsqlite3-dev libzmq3-dev libcapnp-dev capnproto
git clone --depth 1 --branch 2025_threadpool_http_server https://github.com/furszy/bitcoin-core
cd bitcoin-core
cmake -B build -DWITH_BDB=OFF -DBUILD_GUI=OFF -DWITH_ZMQ=ON -DBUILD_BENCH=OFF -DBUILD_FUZZ_BINARY=OFF -DBUILD_GUI_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_UTIL=OFF -DBUILD_TX=OFF -DBUILD_WALLET_TOOL=OFF
cmake --build build
sudo mv build/bin/bitcoind /usr/local/bin/bitcoind
