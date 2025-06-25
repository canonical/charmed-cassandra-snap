.PHONY: connect-interfaces enable-mgmtapi sysctl-tuning

connect-interfaces:
	sudo snap connect charmed-cassandra:process-control
	sudo snap connect charmed-cassandra:system-observe
	sudo snap connect charmed-cassandra:mount-observe
	sudo snap connect charmed-cassandra:hardware-observe

# See: https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/install/installRecommendSettings.html#Setuserresourcelimits
sysctl-tuning:
	@echo "\nApplying recommended sysctl settings for Cassandra..."
	sudo sysctl -w vm.max_map_count=1048575
	sudo sysctl -w vm.swappiness=0

