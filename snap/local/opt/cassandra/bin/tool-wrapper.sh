#!/bin/bash

set -e

"${SNAP}"/usr/bin/setpriv \
    --clear-groups \
    --reuid _daemon_ \
    --regid _daemon_ -- \
    ${SNAP_CURRENT}/opt/cassandra/tools/bin/${bin_script} "${@}"
