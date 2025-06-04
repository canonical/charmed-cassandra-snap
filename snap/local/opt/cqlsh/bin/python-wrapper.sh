#!/bin/bash
set -e

export PYTHONPATH="${SNAP}/lib/python3.12/site-packages"

exec "${SNAP}/usr/bin/setpriv" \
    --clear-groups \
    --reuid _daemon_ \
    --regid _daemon_ \
    -- \
    "${SNAP}/bin/python3" "${SNAP}/bin/"${bin} "$@"
