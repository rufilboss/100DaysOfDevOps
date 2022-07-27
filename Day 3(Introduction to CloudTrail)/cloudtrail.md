# Using the AWS Console

## To create a trail

```sh
Go to AWS Console --> Management & Governance --> CloudTrail --> Trails --> Create trail
```

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

* There is always a delay between when the event occurs vs displayed on CloudTrail dashboard. On top of that, there is an additional delay when that log will be transferred to S3 bucket.
* Delivered every 5(active) minutes with up to 15-minute delay
* All CloudEvents are JSON structure you will see something like this when you try to view any event.

## Validating CloudTrail Log File Integrity

* To determine whether a log file was modified, deleted, or unchanged after CloudTrail delivered it, you can use CloudTrail log file integrity validation.
* This feature is built using industry-standard algorithms: SHA-256 for hashing and SHA-256 with RSA for digital signing.
* This makes it computationally infeasible to modify, delete or forge CloudTrail log files without detection.
* You can use the AWS CLI to validate the files in the location where CloudTrail delivered them.
* Validation of logs can only be performed at the command line.

```sh
$ aws cloudtrail validate-logs --trail-arn arn:aws:cloudtrail:us-east-1:XXXXXXX:trail/examplecloudtrail --start-time  2018-12-27T00:09:00Z  --end-time 2018-12-27T00:10:00Z  --verbose
Validating log files for trail arn:aws:cloudtrail:us-east-1:XXXXXXX:trail/examplecloudtrail between 2018-12-27T00:09:00Z and 2018-12-27T00:10:00Z
Results requested for 2018-12-27T00:09:00Z to 2018-12-27T00:10:00Z
We can also configure a CloudTrail to send copies of logs to CloudWatch Logs(a central location which aggregates logs)
```
* Go back to the trail we have just configured and click on Configure.
```sh
In order to successfully deliver CloudTrail events to your CloudWatch  Logs log group, CloudTrail will assume the role you are creating or  specifying. Assuming the role grants CloudTrail permissions to two  CloudWatch Logs API calls:
1. CreateLogStream: Create a CloudWatch Logs log stream in the CloudWatch Logs log group you specify
2. PutLogEvents: Deliver CloudTrail events to the CloudWatch Logs log stream
 ```

 * Under CloudWatch logs, you will now see the newly created Log Groups.

# Using AWS CLI
## Create Trail(Single Region)
```sh
$ aws cloudtrail create-trail --name example-cloudtrail --s3-bucket-name example_s3bucketforcloudtrail
{
"IncludeGlobalServiceEvents": true,
"IsOrganizationTrail": false,
"Name": "example-cloudtrail",
"TrailARN": "arn:aws:cloudtrail:us-west-2:XXXXXXXXX:trail/example-cloudtrail",
"LogFileValidationEnabled": false,
"IsMultiRegionTrail": false,
"S3BucketName": "examples3bucketforcloudtrail"
}
```

## Create Trail(That applies to multi-region)

```sh
$ aws cloudtrail create-trail --name example-cloudtrail-multiregion --s3-bucket-name example_s3bucketforcloudtrail --is-multi-region-trail
{
"IncludeGlobalServiceEvents": true,
"IsOrganizationTrail": false,
"Name": "example-cloudtrail-multiregion",
"TrailARN": "arn:aws:cloudtrail:us-west-2:XXXXXXXXX:trail/example-cloudtrail-multiregion",
"LogFileValidationEnabled": false,
"IsMultiRegionTrail": true,
"S3BucketName": "example_s3bucketforcloudtrail"
}
```

## To get the status/list all the trails

```sh
$ aws cloudtrail describe-trails
{
"trailList": [
{
"IncludeGlobalServiceEvents": true,
"IsOrganizationTrail": false,
"Name": "example-cloudtrail",
"TrailARN": "arn:aws:cloudtrail:us-west-2:XXXXXXXXXX:trail/example-cloudtrail",
"LogFileValidationEnabled": false,
"IsMultiRegionTrail": false,
"HasCustomEventSelectors": false,
"S3BucketName": "example_s3bucketforcloudtrail",
"HomeRegion": "us-west-2"
},
{
"IncludeGlobalServiceEvents": true,
"IsOrganizationTrail": false,
"Name": "example-cloudtrail-multiregion",
"TrailARN": "arn:aws:cloudtrail:us-west-2:XXXXXXXXXX:trail/example-cloudtrail-multiregion",
"LogFileValidationEnabled": false,
"IsMultiRegionTrail": true,
"HasCustomEventSelectors": false,
"S3BucketName": "example_s3bucketforcloudtrail",
"HomeRegion": "us-west-2"
}
```

## Start logging for the trail
```sh
$ aws cloudtrail start-logging --name example-cloudtrail
```
### NOTE: When we create the trail using CloudTrail console, logging is turned on automatically

## To verify if logging is enabled

```sh
$ aws cloudtrail get-trail-status --name example-cloudtrail
{
"LatestDeliveryTime": 1550014519.927,
"LatestDeliveryAttemptTime": "2019-02-12T23:35:19Z",
"LatestNotificationAttemptSucceeded": "",
"LatestDeliveryAttemptSucceeded": "2019-02-12T23:35:19Z",
"IsLogging": true,
"TimeLoggingStarted": "2019-02-12T23:34:58Z",
"StartLoggingTime": 1550014498.331,
"LatestNotificationAttemptTime": "",
"TimeLoggingStopped": ""
}
```
## To enable log file validation

```sh
$ aws cloudtrail create-trail --name example-cloudtrail-multiregion-logging --s3-bucket-name examples3bucketforcloudtrail --is-multi-region-trail --enable-log-file-validation
{
"IncludeGlobalServiceEvents": true,
"IsOrganizationTrail": false,
"Name": "example-cloudtrail-multiregion-logging",
"TrailARN": "arn:aws:cloudtrail:us-west-2:349934551430:trail/example-cloudtrail-multiregion-logging",
"LogFileValidationEnabled": true,
"IsMultiRegionTrail": true,
"S3BucketName": "examples3bucketforcloudtrail"
}
```

## To delete a particular trail

```sh
$ aws cloudtrail delete-trail --name example-cloudtrail-multiregion-logging
```

## Command cheat sheet

```sh
# Create Trail(Single Region)
aws cloudtrail create-trail --name example-cloudtrail --s3-bucket-name examples3bucketforcloudtrail

# Create Trail(That applies to multi-region)
aws cloudtrail create-trail --name example-cloudtrail-multiregion --s3-bucket-name examples3bucketforcloudtrail --is-multi-region-trail

# To get the status/list all the trails
aws cloudtrail describe-trails

# Start logging for the trail
aws cloudtrail start-logging --name example-cloudtrail

# To verify if logging is enabled
aws cloudtrail get-trail-status --name example-cloudtrail

# To enable log file validation
aws cloudtrail create-trail --name example-cloudtrail-multiregion-logging --s3-bucket-name examples3bucketforcloudtrail --is-multi-region-trail --enable-log-file-validation

# To delete a particular trail
aws cloudtrail delete-trail --name example-cloudtrail-multiregion-logging
```
