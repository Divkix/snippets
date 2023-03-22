#!/bin/bash

set -e

readonly uname_machine=$(uname -m)
case $uname_machine in
  amd64|x86_64)
    arch="amd64"
    ;;
  arm64|aarch64)
    arch="arm64"
    ;;
  *)
    echo "Unsupported architecture: $uname_machine"
    exit 1
    ;;
esac

# download ffmpeg and its md5
curl -O "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-${arch}-static.tar.xz"
curl -O "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-${arch}-static.tar.xz.md5"

# verify md5, if not match, exit
if ! md5sum --check "ffmpeg-release-${arch}-static.tar.xz.md5"; then
  echo "MD5 checksum does not match"
  exit 1
fi

# extract and copy binaries to /usr/local/bin
tar xvf "ffmpeg-release-${arch}-static.tar.xz" -C /usr/local/bin --strip-components=1 "ffmpeg-*-static/ffmpeg" "ffmpeg-*-static/ffprobe"
