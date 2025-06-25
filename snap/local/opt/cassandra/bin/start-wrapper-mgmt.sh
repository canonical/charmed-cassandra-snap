#!/usr/bin/env bash

set -eu

source "${SNAP}"/opt/shared/bin/snap-interfaces.sh
source "${SNAP}"/opt/cassandra/bin/cassandra-utils.sh

# === Heap size logic ===
max_heap_size="$(max_heap_size_mb)"
heap_new_size="$(heap_new_size_mb)"

if ! echo "$max_heap_size" | grep -Eq '^[0-9]+$'; then
    max_heap_size=""
fi

if ! echo "$heap_new_size" | grep -Eq '^[0-9]+$'; then
    heap_new_size=""
fi

env_vars=()
[ -n "$max_heap_size" ] && env_vars+=(MAX_HEAP_SIZE="${max_heap_size}M")
[ -n "$heap_new_size" ] && env_vars+=(HEAP_NEWSIZE="${heap_new_size}M")


function start_cassandra() {
  exit_if_missing_perm "system-observe"
  exit_if_missing_perm "process-control"
  exit_if_missing_perm "mount-observe"

  echo "Starting Cassandra with management API..."

  env "${env_vars[@]}" \
    "${SNAP}"/usr/bin/setpriv \
    --clear-groups \
    --reuid _daemon_ \
    --regid _daemon_ -- \
    ${JAVA_HOME}/bin/java -jar ${MGMT_API_DIR}/libs/datastax-mgmtapi-server.jar -S /tmp/db.sock -H tcp://127.0.0.1:${MGMT_API_PORT}
}

start_cassandra
