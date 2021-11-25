mkdir /static-ffmpeg
cd /tmp && mkdir ffmpeg-build && cd ffmpeg-build

# identify arch
uname_machine=$(uname -m)
if [ "$uname_machine" = "amd64" ] || [ "$uname_machine" = "x86_64" ]; then
  arch="amd64"
elif [ "$uname_machine" = "arm64" ] || [ "$uname_machine" = "aarch64" ]; then
  arch="arm64"
else
  exit 1
fi

wget "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-${arch}-static.tar.xz"
tar xvf ffmpeg*.xz
cp ffmpeg-*-static/ffmpeg "/static-ffmpeg/ffmpeg"
cp ffmpeg-*-static/ffprobe "/static-ffmpeg/ffprobe"
