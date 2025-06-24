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
