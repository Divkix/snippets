#!/usr/bin/env bash

set -euo pipefail

readonly LATEST_TAG=$(curl -s https://api.github.com/repos/git/git/tags | jq -r '.[0].name')

git clone --depth=1 "https://github.com/git/git" -b "$LATEST_TAG"

cd git

make configure

./configure --prefix=/usr/local --with-curl

sudo make -j "$(nproc)" install

echo "Git version $(git --version) installed successfully."

cd -

rm -rf git
