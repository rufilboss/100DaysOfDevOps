* How to Audit your AWS environment using tools like

    * AWS Trusted Advisor
    * Scout2

* What is AWS Trusted Advisor

    * AWS Trusted Advisor is an online tool that provides you real time guidance to help you provision your resources following AWS best practices.

#### AWS Trusted Advisor

* Go to Trusted Advisor → [**here**](https://console.aws.amazon.com/trustedadvisor)

    * Green: No issue or concern found
    * Yellow: Investigation is recommended
    * Red: Critical action recommended

* If you further expand the Trusted Advisor page and explore the details, anything which is not in red will list the criteria for details and recommended actions
* Open the security group, which is highlighted in red
* Change the Port 21 to only listen to your company IP range
* Refresh the security advisor and as you can see port 21 is no longer appear

###### NOTE: You can only refresh the status every 5 min, so if the refresh button is greyed out please wait for 5 min.

* This is the simple example of how you can use Trusted Advisor to fix security issues.

* Similarly, you can look for other security recommendation and fixed it.

#### Scout2

One other tool I will highly recommend everyone to use is Scout2 as it gives you much more detailed information for auditing purpose.

* Installation is pretty straightforward

    ```sh
    pip install awsscout2
    ```

* Export your keys

    ```sh
    export AWS_ACCESS_KEY_ID=" "
    export AWS_SECRET_ACCESS_KEY=" "
    ```

* Run it,

```sh
# Scout2
Fetching IAM config...
groups           policies              roles              users  credential_report    password_policy
3/3              48/48              40/40                2/2                1/1                1/1
Fetching Route53Domains config...
domains
1/1
Fetching SES config...
regions         identities
3/3                0/0
Fetching RDS config...
regions   parameter_groups          instances          snapshots    security_groups      subnet_groups
14/14                2/2                0/0                0/0              14/14                1/1
Fetching CloudTrail config...
regions             trails
14/14              57/57
Fetching ELB config...
regions               elbs
14/14                0/0
Fetching EFS config...
regions       file_systems
6/6                0/0
Fetching ELBV2 config...
regions                lbs       ssl_policies
14/14                1/1                7/7
Fetching CloudWatch config...
regions             alarms
14/14                2/2
Fetching Lambda config...
regions          functions
14/14                3/3
Fetching RedShift config...
regions   parameter_groups           clusters    security_groups
14/14                0/0                0/0                0/0
Fetching S3 config...
buckets
Failed to get encryption configuration for cloudwatch-to-s3-logs: 'S3' object has no attribute 'get_bucket_encryption'
1/11Failed to get encryption configuration for mytests3bucketforcloudtrail: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for s3-event-notification-topic-mydemo-bucket: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for my-tf-test-bucket-terraform-12345676: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for s3-cloudtrail-bucket-with-terraform-code: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for config-bucket-349934551430: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for mys3bucket-withkms-serverside-encryption: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for mytestcloudtrailbucketforevent: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for mys3kmsbuckettestforencryption: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for testingcloudtraillogfilevalidationbucket: 'S3' object has no attribute 'get_bucket_encryption'
Failed to get encryption configuration for mytestkmsbuckettest: 'S3' object has no attribute 'get_bucket_encryption'
11/11
Fetching CloudFormation config...
regions             stacks
14/14                1/1
Fetching SQS config...
regions             queues
14/14                0/0
Fetching EC2 config...
regions          instances          snapshots network_interfaces            volumes    security_groups
14/14                4/4              38/38              11/11                7/7              30/30
Fetching VPC config...
regions            subnets       route_tables       vpn_gateways               vpcs  customer_gateways       network_acls    vpn_connections          flow_logs peering_connections
14/14              48/48              18/18                0/0              16/16                0/0              16/16                0/0                2/2                0/0
Fetching EMR config...
regions           clusters
14/14                0/0
Fetching Direct Connect config...
regions        connections
14/14                0/0
Fetching ElastiCache config...
regions           clusters    security_groups
14/14                0/0                0/0
Fetching Route53 config...
hosted_zones
2/2
Fetching SNS config...
regions             topics      subscriptions
14/14                5/5                4/4
Processing CloudTrail config...
Matching EC2 instances and IAM roles...
'subnets'
Path: ['services', u'vpc', u'regions', u'us-west-2', u'flow_logs']
Key = flow_logs
Value = fl-03eca4e646e3ce517
Path = []
Saving data to scout2-report/inc-awsconfig/aws_config.js
Saving config...
File 'scout2-report/inc-awsconfig/aws_config.js' already exists. Do you want to overwrite it (y/n)? y
Saving data to scout2-report/inc-awsconfig/exceptions.js
Saving config...
File 'scout2-report/inc-awsconfig/exceptions.js' already exists. Do you want to overwrite it (y/n)? y
Creating scout2-report/report.html ...
File 'scout2-report/report.html' already exists. Do you want to overwrite it (y/n)? y
Opening the HTML report...
```

* In the end, you will get the nice UI interface

* For eg: If I click on EC2 and further drill down, similar to Trusted Advisor(you will see Green, Orange and Red)

* If you further drill down it will give you the detailed information
