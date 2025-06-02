# cassandra-snap

### Build
`snapcraft`

### Install
`sudo snap install cassandra_5.0.4_amd64.snap --devmode`

### Setup
```
> ./setup-dev-env.sh
> sudo snap run cassandra.setup \
  --cluster-name=c123 \

```

### Start
`sudo snap start cassandra.daemon`

