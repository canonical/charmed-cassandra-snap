#!/bin/bash

set -e

"${SNAP}"/usr/bin/setpriv \
    --clear-groups \
    --reuid _daemon_ \
    --regid _daemon_ -- \
    ${SNAP}/usr/lib/jvm/${java}/bin/java \
    -Duser.home="${SNAP_COMMON}/home/_daemon_" \
    -jar ${SNAP}/opt/nosqlbench/bin/${jar} \
    "${@}"
