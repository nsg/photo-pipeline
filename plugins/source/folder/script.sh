#!/bin/bash

SOURCE="$1"

if [ -z "$2" ]; then
    find "$SOURCE" -type f -exec $0 $SOURCE "{}" \;
else
    echo "{\"source\": \"$2\", \"data\": \"$(base64 -w0 $2)\"}"
fi
