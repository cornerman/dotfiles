#!/bin/bash

fileInfo=$(echo $QUTE_TEXT | grep -oE "/[^:]+:[0-9]+" | head -n 1)
[[ -z "$fileInfo" ]] && exit 0

file=$(echo $fileInfo | awk -F: '{print $1}')
line=$(echo $fileInfo | awk -F: '{print $2}')

urxvt -e vim "+$line" "$file"

