#!/bin/bash

. config.conf

output_pipeline() {
    local total=${#OUTPUT_PLUGINS[@]}
    local current="$1"

    if [ $current -ge $total ]; then
        cat -
    else
        local plugin="${OUTPUT_PLUGINS[$current]}"
        local image=${plugin%#*}
        local params=${plugin#*#}
        cat - | sudo docker run -iv $params:/out $image | output_pipeline $(( $current + 1 ))
    fi
}

process_pipeline() {
    local total=${#PROCESS_PLUGINS[@]}
    local current="$1"

    if [ $current -ge $total ]; then
        cat - | output_pipeline 0
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
