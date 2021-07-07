#!/bin/bash

SOURCE_PLUGINS=(
    ghcr.io/photo-channel/plugin-source-folder:master#/home/nsg/Pictures/Dump-Pixel4-jan2021/Pictures/Spelkväll/
)

PROCESS_PLUGINS=(
    ghcr.io/photo-channel/plugin-process-cat:master
    ghcr.io/photo-channel/plugin-process-wc:master
)

process_pipeline() {
    local total=${#PROCESS_PLUGINS[@]}
    local current="$1"

    if [ $current -ge $total ]; then
        cat -
    else
        local image="${PROCESS_PLUGINS[$current]}"
        cat - | sudo docker run -i $image | process_pipeline $(( $current + 1 ))
    fi
}

if [ x$1 == xprocess ]; then
    cat - | process_pipeline 0
else
    for plugin in $SOURCE_PLUGINS; do
        image=${plugin%#*}
        params=${plugin#*#}
        sudo docker run -tv $params:/source:ro $image /source | ./splitter.py
    done
fi
