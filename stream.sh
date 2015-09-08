#!/bin/bash

# pass in the key

## pass the file name and stopwords dictionary as an argument

if [ $# -eq 0 ]
then
    echo "pass the streaming key"
    exit
fi

STREAM_KEY=$(cat $1)

#variable definitions
INRES="1366x768" # input resolution
OUTRES="1366x768" # output resolution
FPS="15" # target FPS
GOP="30" # i-frame interval, should be double of FPS,
GOPMIN="15" # min i-frame interval, should be equal to fps,
THREADS="2" # max 6
CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
QUALITY="veryfast" # one of the many FFMPEG preset
AUDIO_RATE="44100"
XOFFSET="1366"
YOFFSET="768"
#to hide logs use= -loglevel quiet
#avconv -f x11grab -r 30 -s 1366x768 -i :0.0 -vcodec libx264 -threads 4 \

avconv -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f alsa -ac 2 -i hw:0 -acodec alac -ab 128k -f flv -ac 2 -ar $AUDIO_RATE \
-vcodec libx264 -keyint_min 3 -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p \
-s $OUTRES -preset $QUALITY -acodec mp3 -threads $THREADS \
-bufsize $CBR "rtmp://usmedia3.livecoding.tv:1935/livecodingtv/$STREAM_KEY"

# ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f alsa -i hw:0 -f flv -ac 2 -ar $AUDIO_RATE \
# -vcodec libx264 -keyint_min 3 -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p \
# -s $OUTRES -preset $QUALITY -acodec mp3 -threads $THREADS \
# -bufsize $CBR "rtmp://usmedia3.livecoding.tv:1935/livecodingtv/$STREAM_KEY"
