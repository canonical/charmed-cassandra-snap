.PHONY: connect-interfaces enable-mgmtapi sysctl-tuning

connect-interfaces:
	sudo snap connect charmed-cassandra:process-control
	sudo snap connect charmed-cassandra:system-observe

# See: https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/install/installRecommendSettings.html#Setuserresourcelimits
sysctl-tuning:
	@echo "\nApplying recommended sysctl settings for Cassandra..."
	sudo sysctl -w vm.max_map_count=1048575
	sudo sysctl -w vm.swappiness=0

enable-mgmtapi:
	@echo "\nEnabling Management API..."

	@command -v jq >/dev/null 2>&1 || { echo >&2 "Error: 'jq' is not installed. Please install jq."; exit 1; }
	@command -v curl >/dev/null 2>&1 || { echo >&2 "Error: 'curl' is not installed. Please install curl."; exit 1; }

	@rev=$$(curl --silent --unix-socket /run/snapd.socket http://localhost/v2/snaps/charmed-cassandra | jq -r '.result.revision'); \
	echo "JVM_OPTS=\"\$$JVM_OPTS -javaagent:/snap/charmed-cassandra/$${rev}/opt/mgmt-api/libs/datastax-mgmtapi-agent.jar\"" \
	| sudo tee -a /var/snap/charmed-cassandra/current/etc/cassandra/cassandra-env.sh
