list-topics:
	docker exec -it kafka kafka-topics.sh --list --zookeeper=zookeeper:2181

 
create-topic:
    ifeq ($(topic),)
	    echo "Please provide a topic name. Example: make create-topic topic=your_topic_name"
	    exit 1
    endif
	docker exec -it kafka kafka-topics.sh --create --topic $(topic) --partitions $(if $(partitions),$(partitions),1) --replication-factor $(if $(replication_factor),$(replication_factor),1) --zookeeper zookeeper:2181
    