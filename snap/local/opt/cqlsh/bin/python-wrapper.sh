#!/bin/bash
set -e

export PYTHONPATH="${SNAP}/lib/python3.12/site-packages"

exec "${SNAP}/bin/python3" "${SNAP}/bin/${bin}" "$@"
