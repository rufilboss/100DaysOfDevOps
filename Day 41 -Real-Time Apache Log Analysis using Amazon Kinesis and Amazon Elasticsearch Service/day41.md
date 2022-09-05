#### Scenario: To analyze Apache logs using Kinesis Firehose, and ElasticSearch Service

![**Xample**](https://miro.medium.com/max/700/1*8sWVykRRIga2R8YnXdNeWA.jpeg)

* Step1: Setup ElasticSearch Cluster

* Step2: Setup firehose delivery Pipeline, this will continuously insert logs to ElasticSearch Cluster

* Step3: Send data to Firehose Delivery Stream

* Step4: Visualize the data using Kibana

* What is Amazon Kinesis

    * Amazon Kinesis is the streaming service provided by AWS which makes it easy to collect, process, and analyze real-time, streaming data so you can get timely insights and react quickly to new information.

* What is AWS ElasticSearch Service

    * AWS ElasticSearch Service is a cost-effective managed service that makes it easy to deploy, manage, and scale open source Elasticsearch for log analytics, full-text search and more.

###### Step1: Setup ElasticSearch Cluster

* Go to [**here**](https://us-west-2.console.aws.amazon.com/es/) --> Create a new domain
