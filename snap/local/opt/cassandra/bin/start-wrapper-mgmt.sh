#!/usr/bin/env bash

set -eu

source "${SNAP}"/opt/shared/bin/snap-interfaces.sh

function start_cassandra() {
  exit_if_missing_perm "system-observe"
  exit_if_missing_perm "process-control"
  exit_if_missing_perm "mount-observe"

  echo "Starting Cassandra with management API..."

  "${SNAP}"/usr/bin/setpriv \
    --clear-groups \
    --reuid _daemon_ \
    --regid _daemon_ -- \
    ${JAVA_HOME}/bin/java -jar ${MGMT_API_DIR}/libs/datastax-mgmtapi-server.jar -S /tmp/db.sock -H tcp://127.0.0.1:${MGMT_API_PORT}
}

start_cassandra
