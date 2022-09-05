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

##### Step1: Setup ElasticSearch Cluster

* Go to [**here**](https://us-west-2.console.aws.amazon.com/es/) --> Create a new domain

    * Choose Development and testing or based on your requirement
    * Give your Elasticsearch domain name(I need to change it to hundreddaysofdevops as numeral 100 is not accepted by AWS) 
    * Choose all the default options
    * This is my test cluster and that why I am choosing these wide open options, these are definitely not recommended for PRD environment
    * Network configuration(Public access for your environment choose particular VPC)
    * Access policy: Your policy must be restricted

##### Step2: Setup firehose delivery Pipeline, this will continuously insert logs to ElasticSearch Cluster

* Go to [**here**](https://us-west-2.console.aws.amazon.com/firehose) --> Create Delivery Stream

* Give your Delivery stream some name and keep all the options as default

###### To see all the Lambda blueprints for Kinesis Data Firehose, with examples in Python and Node.js

* Sign in to the AWS Management Console and open the AWS Lambda console at [**link**](https://console.aws.amazon.com/lambda/).
* Choose to Create function, and then choose Blueprints.
* Search for the keyword “kinesis-firehose-apachelog-to-json-python" to find the Kinesis Data Firehose Lambda Blueprints

    * Source record transformation: Enabled and Choose the lambda function
    * Select Destination: Choose Amazon ElasticSearch Service
    * Domain: Should be auto-populated with ElasticSearch Name
    * Index: Give your index some name(eg: mytestindex)
    * Type(eg: apache)
    * Backup mode: Create a new S3 bucket
    ###### NOTE: Backup Mode is to prevent any data loss,firehose store the data in S3 bucket
    * In the next screen, keep all the setting default, just click on Create or choose new IAM role and create one
    * This role will be auto-populated
    * Click Next and Create Delivery Stream

##### Step3: Send data to Firehose Delivery Stream

* Installing Kinesis Agent

    ```sh
    $ sudo yum install –y https://s3.amazonaws.com/streaming-data-agent/aws-kinesis-agent-latest.amzn1.noarch.rpm
    $ cat /etc/aws-kinesis/agent.json
    $ service aws-kinesis-agent start
    ```

##### Step4: Visualize the data using Kibana

* To create the line chart:

    * Click on Visualize in the navigation bar, and choose Line chart.

    * Choose From a new search. To configure your chart, you first need to tell Kibana what data to use for the y-axis:

    * In the metrics section, click the arrow next to Y-Axis to configure this.

    * Under Aggregation, choose Sum.

    * Under Field, choose STATUSCOUNT.

    * Now you need to configure the x-axis: f. In the buckets section, select X-Axis under Select buckets type.

    * Under Aggregation, choose Date Histogram.

