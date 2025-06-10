# charmed-cassandra-snap
Charmed solution for Cassandra
This repository contains the packaging metadata for creating a snap of Apache Cassandra. 
For more information on snaps, visit [snapcraft.io](https://snapcraft.io/).
### Build
`snapcraft`

### Install
`sudo snap install cassandra_5.0.4_amd64.snap --devmode`

### Setup
```
make connect-interfaces
make sysctl-tuning
```

To setup management server add this line to the end of the cassandra-env.sh file:
```
JVM_OPTS="$JVM_OPTS -javaagent:/snap/cassandra/current/opt/mgmt-api/libs/datastax-mgmtapi-agent.jar"
```
Or use makefile:
```
make enable-mgmtapi
```
### Start
To start cassndra:
`sudo snap start cassandra.daemon`

To start cassandra with management API server:
`sudo snap start cassandra.mgmt-server`
