# cassandra-snap

### Build
`snapcraft`

### Install
`sudo snap install cassandra_5.0.4_amd64.snap --devmode`

### Setup
```
    sudo snap connect cassandra:log-observe
    sudo snap connect cassandra:mount-observe
    sudo snap connect cassandra:process-control
    sudo snap connect cassandra:system-observe
    sudo snap connect cassandra:sys-fs-cgroup-service
    sudo snap connect cassandra:shmem-perf-analyzer
```
To setup management server add this line to the end of the cassandra-env.sh file:
```
JVM_OPTS="$JVM_OPTS -javaagent:/snap/cassandra/current/opt/mgmt-api/libs/datastax-mgmtapi-agent.jar"
```
### Start
`sudo snap start cassandra.daemon`

