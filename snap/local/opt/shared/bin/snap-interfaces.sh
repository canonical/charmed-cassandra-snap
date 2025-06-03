#!/usr/bin/env bash


function exit_if_missing_perm () {
    if ! snapctl is-connected "${1}";
    then
        echo "Please run the following command: sudo snap connect cassandra:${1}"
        echo "Then run: sudo snap start cassandra.daemon"
        exit 1
    fi
}

function warn_if_missing_perm () {
    if ! snapctl is-connected "${1}";
    then
        echo "WARN: connection ${1} NOT FOUND"
        echo "Please, run command: sudo snap connect cassandra:${1}"
        echo "Then run: sudo snap start cassandra.daemon"
    fi
}
