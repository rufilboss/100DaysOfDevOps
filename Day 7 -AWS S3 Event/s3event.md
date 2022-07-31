### Problem Statement
Whenever anyone deletes any object in S3 bucket you will get the notification
Solution
##### This can be achieved via in one of the two ways
AWS Console
Terraform

NOTE: This is not the complete list and there are more ways to achieve the same
# Using AWS Maagement Console

### What is S3 Event?

The Amazon S3 notification feature enables you to receive notifications(SNS/SQS/Lambda) when certain events(mentioned below)happen in your bucket.


### To Configure S3 events

* First, go to the SNS topic [**here**](https://us-west-2.console.aws.amazon.com/sns/v2/home?region=us-west-2#/home)
* Click on Topics → Actions → Edit topic policy
* Paste this json policy(We still need permission on SNS topic to allow S3 event system to deliver events to it)
```sh
{
 "Effect": "Allow",
 "Principal": {
  "AWS": "*"
 },
 "Action": "SNS:Publish",
 "Resource": "arn:aws:sns:us-west-2:XXXXXX:alarms-topic", <--SNS Arn
 "Condition": {
  "ArnLike": {
   "aws:SourceArn": "arn:aws:s3:::s3-cloudtrail-bucket-with-terraform-code" <---Bucket name
  }
 }
}
```
* Go to S3 console [**here**](https://s3.console.aws.amazon.com/s3/home?region=us-east-1)
* Your bucket → Properties → Events
```sh
* Give your event a name
* Event type I want to get a notification is (All object delete events) i.e I want to recieve notification when object is deleted from this topic.
* Send to SNS Topic
* SNS(Choose the SNS topic you created earlier)
```
* Now if you try to delete an object from the bucket
### NOTE: Delivery of these events happens in almost real-time with no cost involved.

# Using Terraform
Check the s3event.tf file.....