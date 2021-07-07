#!/bin/bash

. config.conf

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
    process_pipeline 0
else
    for plugin in $SOURCE_PLUGINS; do
        image=${plugin%#*}
        params=${plugin#*#}
        sudo docker run -tv $params:/source:ro $image /source | ./splitter.py
    done
fi
