### Problem Statement
Whenever anyone deletes any object in S3 bucket you will get the notification
Solution
This can be achieved via in one of the three ways

### AWS Console
Terraform
NOTE: This is not the complete list and there are more ways to achieve the same
# Using AWS Maagement Console

### What is S3 Event?

The Amazon S3 notification feature enables you to receive notifications(SNS/SQS/Lambda) when certain events(mentioned below)happen in your bucket.


### To Configure S3 events

* First, go to the SNS topic [**here**](https://us-west-2.console.aws.amazon.com/sns/v2/home?region=us-west-2#/home)
* Click on Topics → Actions → Edit topic policy
