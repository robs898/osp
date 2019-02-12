FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y git dvb-apps libavcodec-extra libavdevice-dev make g++ pkg-config libx264-dev zlib1g-dev ffmpeg libfreetype6-dev libjpeg62-dev libpng-dev libmad0-dev libfaad-dev libogg-dev libvorbis-dev libtheora-dev liba52-0.7.4-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev libxv-dev x11proto-video-dev libgl1-mesa-dev x11proto-gl-dev linux-sound-base libxvidcore-dev libssl-dev libjack-dev libasound2-dev libpulse-dev libsdl1.2-dev && \
    git clone https://github.com/gpac/gpac.git && \
    cd gpac && \
    ./configure && \
    make && \
    make install

COPY example.mpd /tmp/example.mpd
COPY list.txt /tmp/list.txt

ENTRYPOINT [ "ffmpeg" ]
