#Create New Project
oc new-project myproject

# Operator Install : Provided By Red Hat    :: AMQ Streams 2.6.0 in "openshift operators"
# Operator Install : Provided By Community  :: Prometheus in "myproject"

# Create the cluster with [ZooKeeper, Kafka, Kafka Exporter, Entity Operator, Prometheus Metrics]
# Adjust pv sizes to be smaller (the default is 100 GB)
oc apply -f ocp-install-examples/amq-streams-2.6.0/kafka/kafka-with-metrics-install.yaml

###Prometheus
#
oc create secret generic additional-scrape-configs --from-file=ocp-install-examples/amq-streams-2.6.0/prometheus/prometheus-additional.yaml
#
oc apply -f ocp-install-examples/amq-streams-2.6.0/prometheus/strimzi-pod-monitor.yaml
#
oc apply -f ocp-install-examples/amq-streams-2.6.0/prometheus/prometheus-rules.yaml
#
oc apply -f ocp-install-examples/amq-streams-2.6.0/prometheus/prometheus-install.yaml


#Install grafana dashboard
oc apply -f ocp-install-examples/amq-streams-2.6.0/grafana/grafana-install.yaml
oc expose svc grafana

#Configure Grafana
#Login to the grafana dashboard using the route created (admin/admin)
#Check the Route on the Developer Console
#Create a prometheus datasource using http://prometheus-operated:9090, Save and Test.

#On the top left, hover on the "+" icon, and select "Import" and import the following files, one at a time
#select prometheus as the source when prompted.
grafana/dashboards/strimzi-kafka-exporter.json
grafana/dashboards/strimzi-kafka.json
grafana/dashboards/strimzi-zookeeper.json

#Create a topic
oc apply -f ocp-install-examples/amq-streams-2.6.0/kafka/topics/demo-topic-config.yaml

# The Strimzi kafka exporter dashboard will not show any metrics until you create a producer and a consumer
# Run the producer and Consumer
oc apply -f ocp-install-examples/amq-streams-2.6.0/kafka/workloads/java-producer.yaml
oc apply -f ocp-install-examples/amq-streams-2.6.0/kafka/workloads/java-consumer.yaml