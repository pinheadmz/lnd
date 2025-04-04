#!/usr/bin/env bash

set -ev

sudo apt-get install -y build-essential cmake pkgconf python3 libevent-dev libboost-dev libsqlite3-dev libzmq3-dev
git clone --depth 1 --branch http-rewrite-13march2025 https://github.com/pinheadmz/bitcoin
cd bitcoin
cmake -B build -DWITH_BDB=OFF -DBUILD_GUI=OFF -DWITH_ZMQ=ON -DBUILD_BENCH=OFF -DBUILD_FUZZ_BINARY=OFF -DBUILD_GUI_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_UTIL=OFF -DBUILD_TX=OFF -DBUILD_WALLET_TOOL=OFF
cmake --build build
sudo mv build/bin/bitcoind /usr/local/bin/bitcoind
