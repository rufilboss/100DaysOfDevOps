##### What Is AWS Config?

* AWS Config provides a detailed view of the configuration of AWS resources in your AWS account. This includes how the resources are related to one another and how they were configured in the past so that you can see how the configurations and relationships change over time.

* Features

    * Track state of all resources(OS level too — Windows/Linux)
    * Meet your compliance need(PCI-DSS, HIPAA)
    * Validate against AWS Config Rule

##### Setting up AWS Config

* Go to [**AWS Config**](https://us-west-2.console.aws.amazon.com/config) → Get started
    * All resources: You can check on, Record all rsources supported in this region
    OR
    Global resources like IAM
    OR
    We can even check specific resources eg: EC2
    * Amazin S3 bucket: This bucket will recieve configuration history and configuration snapshot files
    * Amazon SNS topic(Optional): We can send config changes to S3 bucket
    * AWS Config role: It give AWS config read-only access(IAM Role)to AWS resource

* Confirm and AWS Config setup for us.
* Check the status of AWS config, by click on the status icon on the top of the page
* Now click on Resource and then Instance
* Then, Click on the Configuration timeline
* Scroll down and click on changes

* Scenario: Last time we skipped the rule section, this time let add all the config rule, our task for today to make sure for an account is compliant

    * CloudTrail must be enabled
    * S3 bucket versioning must be enabled
    * EC2 instance must be a part of VPC
    * We are only using instance type as t2.micro

