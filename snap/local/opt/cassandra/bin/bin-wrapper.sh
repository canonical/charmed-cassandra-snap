#!/bin/bash

set -e

"${SNAP}"/usr/bin/setpriv \
    --clear-groups \
    --reuid _daemon_ \
    --regid _daemon_ -- \
    ${SNAP}/opt/cassandra/bin/${bin_script} "${@}"
