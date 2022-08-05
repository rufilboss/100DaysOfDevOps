#### Problem:

* Ensures users can’t turn off the Cloudtrail

#### Solutions:

* IAM Policy
* CloudWatch Events
* Lambda

We all understand the importance of CloudTrail, it records each action taken by a user, role, or an AWS service. Events include actions taken in the AWS Management Console, AWS Command Line Interface, and AWS SDKs and APIs.

# Using AWS Management Console

### Solution 1: IAM Policy

* If we add this simple deny policy to the user he/she will not be able to disable CloudTrail
```sh
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Deny",
            "Action": "cloudtrail:StopLogging",
            "Resource": "arn:aws:cloudtrail:us-west-2:123456789:trail/mytestcloudtrail"
        }
    ]
}
```

### Solution2: CloudWatch Events

* Go to CloudWatch → Events → Rules
* This is just the subset of what we are going to do in Solution 3
* What this will do, if now any user tries to disable CloudTrail, you will receive an email notification

### Solution3: Using Lambda

## Step1:
* Create IAM Role so that Lambda can interact with CloudWatch Events
```sh
Go to IAM Console https://console.aws.amazon.com/iam/home?region=us-west-2#/home --> Roles --> Create role
```

* In the next screen, select Create Policy

```sh
* Service: Search for CloudWatch Logs
* Action: Select CreateLogGroup, CreateLogStream and PutLogEvents
* Resource: Select Any
```
* Review and give your policy some name
* Final policy look like this
```sh
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:*:*:log-group:*:*:*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        }
    ]
}
```

* Add this newly created policy to the role and add one more policy to it(AWSCloudTrailFullAccess), so that Lambda will respond to any CloudTrail event.
