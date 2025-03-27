#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 <INPUT> <OUTPUT> [OPTION]"
  exit 1
fi

INPUT=$1
OUTPUT=$2

if [ ! -e $INPUT ]; then
  echo "$INPUT doesn't exist."
  exit 1
fi

if [ $# -ge 3 ]; then
  shift
  shift
  OPTION=$*
  echo "additional option: $OPTION"
fi

ffmpeg -y -i $INPUT \
  -pass 1 -threads 8 -target ntsc-dvd \
  ${OPTION} -vcodec mpeg2video -s 720x480 -aspect 4:3 -r 29.97 -an \
  /dev/null \
&& \
ffmpeg -i $INPUT \
  -pass 2 -threads 8 -target ntsc-dvd \
  ${OPTION} -acodec ac3 -ar 48000 \
  -vcodec mpeg2video -s 720x480 -aspect 4:3 -r 29.97 \
  $OUTPUT
