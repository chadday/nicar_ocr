#!/bin/bash

i=$1
if [ -n "$(find "$i" -prune -size +1000000c)" ]; then
    printf '%s is larger than 1 MB\n' "$i"
    time convert\
    -density 72\
    "$i"\
    -depth 8\
    -strip\
    -background white\
    -alpha off\
    "${i%.*}"_im.tiff;
else
    printf '%s is smaller than 1 MB\n' "$i"
    time convert\
    -density 300\
    "$i"\
    -depth 8\
    -strip\
    -background white\
    -alpha off\
    "${i%.*}"_im.tiff;
fi

tesseract --oem 1 "${i%.*}"_im.tiff "${i%.*}"_im $2;