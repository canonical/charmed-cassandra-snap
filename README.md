# charmed-cassandra-snap
Charmed solution for Cassandra
This repository contains the packaging metadata for creating a snap of Apache Cassandra. 
For more information on snaps, visit [snapcraft.io](https://snapcraft.io/).

## Building the snap
### Clone Repository
```
git clone git@github.com:canonical/charmed-cassandra-snap.git
cd charmed-cassandra-snap
```
### Installing and Configuring Prerequisites
```
sudo snap install snapcraft
sudo snap install lxd
sudo lxd init --auto
```
### Packing the snap 
```
snapcraft pack
```

### Install
`sudo snap install charmed_cassandra*.snap --devmode`

### Setup
```
make connect-interfaces
make sysctl-tuning
```

To setup management server add this line to the end of the cassandra-env.sh file:
```
JVM_OPTS="$JVM_OPTS -javaagent:/snap/charmed-cassandra/{revision}/opt/mgmt-api/libs/datastax-mgmtapi-agent.jar"
```
Or use makefile:
```
make enable-mgmtapi
```
### Start
To start cassndra:
`sudo snap start charmed-cassandra.daemon`

To start cassandra with management API server:
`sudo snap start charmed-cassandra.mgmt-server`
