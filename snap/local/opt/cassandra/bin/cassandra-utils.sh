#!/bin/sh

max_heap_size_mb()
{
	val="$(snapctl get max-heap-size-mb)"
	if [ -z "$val" ]; then
		set_max_heap_size_mb ""
	fi

	echo "$val"
}

set_max_heap_size_mb()
{
    snapctl set max-heap-size-mb="$1"
}

heap_new_size_mb()
{
	val="$(snapctl get heap-new-size-mb)"
	if [ -z "$val" ]; then
		set_heap_new_size_mb ""
	fi
	
	echo "$val"	
}

set_heap_new_size_mb()
{
	snapctl set heap-new-size-mb="$1"
}

detect_running_daemon() {
    daemon_active=$(snapctl services charmed-cassandra.daemon | awk '/charmed-cassandra.daemon/ { print $3 }')
    mgmt_active=$(snapctl services charmed-cassandra.mgmt-server | awk '/charmed-cassandra.mgmt-server/ { print $3 }')

    if [ "$daemon_active" = "active" ] && [ "$mgmt_active" = "active" ]; then
        echo "Both daemons are running"
    elif [ "$daemon_active" = "active" ]; then
        echo "daemon"
    elif [ "$mgmt_active" = "active" ]; then
        echo "mgmt-server"
    else
        echo "No daemons are running"
    fi
}
