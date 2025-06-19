# Charmed Cassandra Snap

Charmed Cassandra snap includes Apache Cassandra database and set of auxiliary tools like Cassandra Management API Server.

This repository contains the packaging metadata for creating the Charmed Cassandra Snap. For more information on snaps, visit [snapcraft.io](https://snapcraft.io/).

## Building the snap

### Clone Repository

```bash
git clone git@github.com:canonical/charmed-cassandra-snap.git
cd charmed-cassandra-snap
```

### Setup Prerequisites

```bash
sudo snap install snapcraft --classic
sudo snap install lxd
sudo lxd init --auto
```

### Pack the snap

```bash
snapcraft pack
```

## Using the snap

### Setup the snap

```bash
sudo snap install charmed-cassandra*.snap --devmode
```

Cassandra requires `process-control` and `system-observe` interfaces to be connected in order to be started - this can be done manually or with `make connect-interfaces`. Also, `vm.max_map_count` and `vm.swappiness` sysctl parameters can be tuned to achieve better Cassandra performance - this can be done with `make sysctl-tuning`.

To start Cassandra: `sudo snap start charmed-cassandra.daemon`

### RAM

Initially, a single Cassandra instance will use slightly more than a half of the RAM available to the system. To limit the RAM usage (for example, prior running several Cassandra instances simultaneously on single machine) you can uncomment and configure `MAX_HEAP_SIZE` and `HEAP_NEWSIZE` parameters in the `/var/snap/charmed-cassandra/current/etc/cassandra/cassandra-env.sh` file. Note that `HEAP_NEWSIZE` should be the half of a size of the `MAX_HEAP_SIZE`. For basic needs `MAX_HEAP_SIZE="1024M"` & `HEAP_NEWSIZE="512M"` is sufficient.

### Single Node Deployment Example

1. Start a Cassandra daemon: `sudo snap start charmed-cassandra.daemon`.
2. After a while, you will be able to retrieve a cluster status via `sudo charmed-cassandra.nodetool status`.

  ```
  Datacenter: datacenter1
  =======================
  Status=Up/Down
  |/ State=Normal/Leaving/Joining/Moving
  --  Address    Load        Tokens  Owns (effective)  Host ID                               Rack 
  UN  127.0.0.1  114.74 KiB  16      100.0%            c6da97b2-39cf-40a6-b23a-312112f95701  rack1
  ```

3. You can verify cluster works with `charmed-cassandra.cqlsh`:

  ```
  Connected to Test Cluster at 127.0.0.1:9042
  [cqlsh 6.2.0 | Cassandra 5.0.4 | CQL spec 3.4.7 | Native protocol v5]
  Use HELP for help.
  cqlsh> create keyspace test WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};
  cqlsh> use test;
  cqlsh:test> create table t1 (message text primary key);
  cqlsh:test> select * from t1;

  message
  ---------

  (0 rows)
  cqlsh:test> insert into t1 (message) values ('hello');
  cqlsh:test> select * from t1;

  message
  ---------
    hello

  (1 rows)
  ```

4. Cassandra is successfully deployed and accessible.

### Multi Node Deployment Example

In this example, the next 3 LXC containers will be used:

- c1: `10.44.178.5`
- c2: `10.44.178.247`
- c3: `10.44.178.81`

1. Setup the required parameters in `/var/snap/charmed-cassandra/current/etc/cassandra/cassandra.yaml` on first machine:

  ```yaml
  seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
        - seeds: "10.44.178.5:7000"
  listen_address: 10.44.178.5
  ```

  > [!NOTE]
  > You should bind Cassandra node to the public IP of the machine in order to make service accessible and also explicitly specify it as seed node.

2. Start and wait for Cassandra to initialize the cluster on first machine: `sudo snap start charmed-cassandra.daemon` & `sudo charmed-cassandra.nodetool status`.

  ```
  Datacenter: datacenter1
  =======================
  Status=Up/Down
  |/ State=Normal/Leaving/Joining/Moving
  --  Address      Load        Tokens  Owns (effective)  Host ID                               Rack 
  UN  10.44.178.5  118.77 KiB  16      100.0%            c6da97b2-39cf-40a6-b23a-312112f95701  rack1
  ```

3. Configure the second machine in the same way, but set seed pointing to the first machine: `- seeds: "10.44.178.5:7000"`.

  ```
  Datacenter: datacenter1
  =======================
  Status=Up/Down
  |/ State=Normal/Leaving/Joining/Moving
  --  Address        Load        Tokens  Owns (effective)  Host ID                               Rack 
  UN  10.44.178.247  119.67 KiB  16      51.2%             bbfc37c2-3533-4a54-ac42-5cb16e898939  rack1
  UN  10.44.178.5    118.77 KiB  16      48.8%             c6da97b2-39cf-40a6-b23a-312112f95701  rack1
  ```

4. Configure the third machine in the same way, but set seed pointing to the first machine: `- seeds: "10.44.178.5:7000"`.

  ```
  Datacenter: datacenter1
  =======================
  Status=Up/Down
  |/ State=Normal/Leaving/Joining/Moving
  --  Address        Load        Tokens  Owns (effective)  Host ID                               Rack 
  UN  10.44.178.247  85.1 KiB    16      31.6%             bbfc37c2-3533-4a54-ac42-5cb16e898939  rack1
  UN  10.44.178.5    118.77 KiB  16      32.7%             c6da97b2-39cf-40a6-b23a-312112f95701  rack1
  UN  10.44.178.81   90.13 KiB   16      35.7%             f27b8e4a-f912-46a7-8807-42c93e70d90d  rack1
  ```

5. Verify test data is writeable on second machine with `charmed-cassandra.cqlsh`:

  ```
  Connected to Test Cluster at 127.0.0.1:9042
  [cqlsh 6.2.0 | Cassandra 5.0.4 | CQL spec 3.4.7 | Native protocol v5]
  Use HELP for help.
  cqlsh> create keyspace multitest WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 3};
  cqlsh> use multitest;
  cqlsh:multitest> create table ttt (message text primary key);
  cqlsh:multitest> insert into ttt (message) values ('hello');
  cqlsh:multitest> select * from ttt;

  message
  ---------
    hello

  (1 rows)
  ```

6. Verify test data is readable and writeable on third machine with `charmed-cassandra.cqlsh`:

  ```
  Connected to Test Cluster at 127.0.0.1:9042
  [cqlsh 6.2.0 | Cassandra 5.0.4 | CQL spec 3.4.7 | Native protocol v5]
  Use HELP for help.
  cqlsh> use multitest;
  cqlsh:multitest> select * from ttt;

  message
  ---------
    hello

  (1 rows)
  cqlsh:multitest> insert into ttt (message) values ('world');
  cqlsh:multitest> select * from ttt;

  message
  ---------
    hello
    world

  (2 rows)
  ```

7. Verify test data is readable on first machine with `charmed-cassandra.cqlsh`:

  ```
  Connected to Test Cluster at 127.0.0.1:9042
  [cqlsh 6.2.0 | Cassandra 5.0.4 | CQL spec 3.4.7 | Native protocol v5]
  Use HELP for help.
  cqlsh> use multitest;
  cqlsh:multitest> select * from ttt;

  message
  ---------
    hello
    world

  (2 rows)
  ```

8. Cassandra cluster is successfully deployed and accessible.

### Exposing Client Interface

While the `listen_address` parameter corresponds to node-to-node Cassandra connections, `rpc_address` parameter corresponds to the client connections (e.g. cqlsh) and is limited to localhost by default. Cassandra documentation warns about exposing of this interface, but for testing purposes it can be done by setting `rpc_address` to the public ip or `0.0.0.0`.

## Cassandra Management API

[Cassandra Management API from K8ssandra](https://github.com/k8ssandra/management-api-for-apache-cassandra) allows managing Cassandra node / cluster with the REST API. This tool consists of two parts:

1. Management API Cassandra plugin  
  It should be enabled by adding `JVM_OPTS="$JVM_OPTS -javaagent:/snap/charmed-cassandra/current/opt/mgmt-api/libs/datastax-mgmtapi-agent.jar"` line to `/var/snap/charmed-cassandra/current/etc/cassandra/cassandra-env.sh` file or with `make enable-mgmtapi`.
2. Management API server  
  It manages database service and communicates with node through Management API Cassandra plugin.

When Management API is enabled, Cassandra instance should be run only by starting `mgmt-server` service: `sudo snap start charmed-cassandra.mgmt-server`.

## License

The Apache Cassandra Snap is free software, distributed under the Apache Software License, version 2.0. See [LICENSE](https://github.com/canonical/charmed-cassandra-snap/LICENSE) for more information.

## Trademark Notice

Apache Cassandra and the Apache Cassandra logo are trademarks of the Apache Software Foundation. All other trademarks are the property of their respective owners.
