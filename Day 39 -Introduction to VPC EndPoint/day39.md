#### What is VPC EndPoint?

* A VPC endpoint enables you to privately connect your VPC to supported AWS services and VPC endpoint services powered by PrivateLink without requiring an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection. Instances in your VPC do not require public IP addresses to communicate with resources in the service. Traffic between your VPC and the other service does not leave the Amazon network.

* Endpoints are virtual devices. They are horizontally scaled, redundant, and highly available VPC components that allow communication between instances in your VPC and services without imposing availability risks or bandwidth constraints on your network traffic.

#### There are two types of VPC endpoints:

* Interface endpoints(using private links): An interface endpoint is an elastic network interface with a private IP address that serves as an entry point for traffic destined to a supported service

* Supported Services

    * Amazon API Gateway
    * AWS CloudFormation
    * Amazon CloudWatch
    * Amazon CloudWatch Events
    * Amazon CloudWatch Logs
    * AWS CodeBuild
    * AWS Config
    * Amazon EC2 API
    * Elastic Load Balancing API
    * Amazon Elastic Container Registry
    * Amazon Elastic Container Service
    * AWS Key Management Service
    * Amazon Kinesis Data Streams
    * Amazon SageMaker and Amazon SageMaker Runtime
    * Amazon SageMaker Notebook Instance
    * AWS Secrets Manager
    * AWS Security Token Service
    * AWS Service Catalog
    * Amazon SNS
    * Amazon SQS
    * AWS Systems Manager
    * Endpoint services hosted by other AWS accounts
    * Supported AWS Marketplace partner services

* Gateway endpoints: A gateway endpoint is a gateway that is a target for a specified route in your route table, used for traffic destined to a supported AWS service

* Supported Services

    * Amazon S3
    * DynamoDB

###### Scenario1: I want to push logs from EC2 private instance(running on Private IP)to CloudWatch Logs.

* To setup VPC Endpoint
    * Go to [**here**](https://us-west-2.console.aws.amazon.com/vpc) --> EndPoints
* Once the endpoint is created you will see an elastic network interface with a private IP address which acts as an entry point for traffic destined to a supported service

* Terraform Code

Check out: [**vpc_logs_endpoint.tf**]()

###### Scenario2: I want to push logs from EC2 private instance(running on Private IP)to AWS S3.

