# RAM

Initially, a single Cassandra instance will use a slightly more than a half of the RAM available to the system. To limit the RAM usage (for example, prior running several Cassandra instances on the single machine simultaneously) you can uncomment and configure `MAX_HEAP_SIZE` and `HEAP_NEWSIZE` parameters in the `/var/snap/cassandra/current/etc/cassandra/cassandra-env.sh` file. Note that `HEAP_NEWSIZE` should be the half of a size of the `MAX_HEAP_SIZE`. For basic development environment needs `MAX_HEAP_SIZE="512M"` & `HEAP_NEWSIZE="256M"` is sufficient.

# Single Node Deployment Instruction

1. Setup the configuration files: `sudo cassandra.setup`.
2. Start a Cassandra daemon: `sudo snap start cassandra`.
3. After a while, you will be able to retrieve a cluster status via `sudo cassandra.nodetool status`.

  ```
  Datacenter: datacenter1
  =======================
  Status=Up/Down
  |/ State=Normal/Leaving/Joining/Moving
  --  Address    Load        Tokens  Owns (effective)  Host ID                               Rack 
  UN  127.0.0.1  175.73 KiB  16      100.0%            066d0481-bb65-415f-a840-292197e1fa1d  rack1
  ```

4. Cassandra cluster is successfully deployed and accessible.

# Multi Node Deployment Instruction

In this instruction, two LXC containers will be used as machines for example with `10.64.106.85` and `10.64.106.113` IP addresses for the first and second machine respectively.

1. Setup the configuration files on the first machine: `sudo cassandra.setup --node-host=10.64.106.85 --seed-hosts=10.64.106.85:7000`.

  > [!NOTE]
  > You should bind node-host to the public IP of the machine in order to make service accessible and also explicitly specify it as seed node using seed-hosts parameter.

2. Start and wait for Cassandra to initialize the cluster on the first machine: `sudo snap start cassandra` & `sudo cassandra.nodetool status`.

  ```
  Datacenter: datacenter1
  =======================
  Status=Up/Down
  |/ State=Normal/Leaving/Joining/Moving
  --  Address       Load       Tokens  Owns (effective)  Host ID                               Rack 
  UN  10.64.106.85  114.7 KiB  16      100.0%            5b3d68aa-1b31-46cb-bd4d-3679bb731ac9  rack1
  ```

3. Setup the configuration files on the second machine: `sudo cassandra.setup --seed-hosts="10.64.106.85:7000" --node-host=10.64.106.113`.
  Unlike previously, you should bind `seed-hosts` to the same value as in the first machine in order to unite both units in the same cluster.

  ```
  Datacenter: datacenter1
  =======================
  Status=Up/Down
  |/ State=Normal/Leaving/Joining/Moving
  --  Address        Load        Tokens  Owns (effective)  Host ID                               Rack 
  UN  10.64.106.85   119.84 KiB  16      100.0%            5b3d68aa-1b31-46cb-bd4d-3679bb731ac9  rack1
  UN  10.64.106.113  80.06 KiB   16      100.0%            cce923cb-63c4-4803-bac8-e89ab7eb987e  rack1
  ```

4. Cassandra cluster is successfully deployed and accessible. Both nodes are in the same cluster.
