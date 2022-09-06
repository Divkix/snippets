#!/bin/bash

mkdir ffmpeg-build
cd ffmpeg-build

# identify arch
uname_machine=$(uname -m)
if [ "$uname_machine" = "amd64" ] || [ "$uname_machine" = "x86_64" ]; then
  arch="amd64"
elif [ "$uname_machine" = "arm64" ] || [ "$uname_machine" = "aarch64" ]; then
  arch="arm64"
else
  exit 1
fi

# download ffmpeg and its md5
wget "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-${arch}-static.tar.xz"
wget "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-${arch}-static.tar.xz.md5"

# verify md5, if not match, exit
md5sum -c "ffmpeg-release-${arch}-static.tar.xz.md5"

# extract
tar xvf ffmpeg*.xz

# copy binaries to /usr/local/bin
cp ffmpeg-*-static/ffmpeg "/usr/local/bin/ffmpeg"
cp ffmpeg-*-static/ffprobe "/usr/local/bin/ffprobe"
