# Using the AWS Console

## To create a trail

Go to AWS Console --> Management & Governance --> CloudTrail --> Trails --> Create trail

* Trail name: Give your trail name
* Apply trail to all regions: You have an option to choose all regions or specific region.
* Read/Write events: You have the option to filter the events
* Data events: Data events provide insights into the resource operations performed on or within a resource
S3: You can record S3 object-level API activity (for example, GetObject and  PutObject) for individual buckets, or for all current and future buckets  in your AWS account
Lambda:You can record Invoke API operations for individual functions, or for all current and future functions in your AWS account.
* Storage Locations: Where to store the logs, we can create new bucket or use existing bucket
* Log file prefix: We have the option to provide prefix, this will make it easier to browse log file
* Encrypt log file with SSE-KMS: Default SSE-S3 Server side encryption(AES-256) or we can use KMS
* Enable log file validation: To determine whether a log file was modified, deleted, or unchanged after CloudTrail delivered it, you can use CloudTrail log file integrity validation
* Send SNS notification for every log file delivery:SNS notification of log file delivery allow us to take action immediately


### NOTE:

There is always a delay between when the event occurs vs displayed on CloudTrail dashboard. On top of that, there is an additional delay when that log will be transferred to S3 bucket.
Delivered every 5(active) minutes with up to 15-minute delay
All CloudEvents are JSON structure you will see something like this when you try to view any event.

# Using AWS CLI
## Create Trail(Single Region)

