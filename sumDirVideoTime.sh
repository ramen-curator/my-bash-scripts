#!/bin/bash

find . -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" \) -print0 | sort -uz | xargs -0 -n 1 ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 | awk '{ total += $1 } END { hours=int(total/3600); mins=int((total%3600)/60); secs=int(total%60); printf "Total duration: %d hours %d minutes %d seconds\n", hours, mins, secs }'
