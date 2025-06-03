#!/usr/bin/env bash

set -eu

source "${SNAP_CURRENT}"/opt/shared/bin/snap-interfaces.sh

WITH_API=false

# Parse flags
for arg in "$@"; do
  case $arg in
    --with-api)
      WITH_API=true
      shift
      ;;
    *)
      ;;
  esac
done

# TODO: make shure not to launch cassandra while mgmt-server is up, or vise versa. Maybe by checking /tmp/snap-private-tmp/snap.cassandra/tmp/cassandra.pid is exists
function start_cassandra () {
    exit_if_missing_perm "log-observe"
    exit_if_missing_perm "mount-observe"
    exit_if_missing_perm "sys-fs-cgroup-service"
    exit_if_missing_perm "system-observe"

    warn_if_missing_perm "process-control"

    if [ "$WITH_API" = true ]; then
        echo "Starting Cassandra with management API..."

	
        if [ ! -f "${MGMT_API_DIR}/libs/datastax-mgmtapi-server.jar" ]; then
            echo "Error: ${MGMT_API_DIR}/libs/datastax-mgmtapi-server.jar not found!"
            exit 1
        fi

        # Check if cassandra-env.sh contains the javaagent line
        expected_agent_path="${MGMT_API_DIR}/libs/datastax-mgmtapi-agent.jar"

        if ! grep -q "javaagent:${expected_agent_path}" "${CASSANDRA_CONF}/cassandra-env.sh"; then
            echo "Error: ${CASSANDRA_CONF}/cassandra-env.sh does not contain required javaagent line for management API"
            echo "Missing line: JVM_OPTS=\"\$JVM_OPTS -javaagent:${expected_agent_path}\""
            exit 1
        fi
	
        "${SNAP}"/usr/bin/setpriv \
            --clear-groups \
            --reuid snap_daemon \
            --regid snap_daemon -- \
            ${JAVA_HOME}/bin/java -jar ${MGMT_API_DIR}/libs/datastax-mgmtapi-server.jar -S /tmp/db.sock -H tcp://127.0.0.1:${MGMT_API_PORT}
    else
        echo "Starting Cassandra..."
        "${SNAP}"/usr/bin/setpriv \
            --clear-groups \
            --reuid snap_daemon \
            --regid snap_daemon -- \
            "${CASSANDRA_BIN}"/cassandra -f
    fi
}

start_cassandra
