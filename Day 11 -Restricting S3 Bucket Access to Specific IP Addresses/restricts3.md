#### Problem:
* Restrict S3 bucket access(Get/Put Operation from specific IP)

#### Solution:
* This can be done using the S3 bucket policies

###### S3 Bucket policies come under Resource Policies that control who has access to the specific resource.

# Uisng AWS Management Console
### Step1:
* Go to S3 console [**here**](https://s3.console.aws.amazon.com/s3/home?region=us-west-2) → Specific Bucket → Permissions → Bucket Policy → Policy

### Step2:

* Fill all the details

```sh
* Effect: Allow
* Principal: *
* AWS Service: Amazon S3
* Action: Select GetObject and PutObject
* Amazon Resource Name(ARN): <arn of your S3 bucket>/* <--Don't forget to Put /* at the end
Add Conditions
* Condition: IpAddress
* Key: aws:SourceIp
* Value: 192.168.0.2/24 (Specify your IP Address)
```

* Final Policy will look like this

```sh
{
  "Id": "Policy1550810272864",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1550810271230",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::mytests3bucketforpermissionboundaries/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "67.164.4.229"
        }
      },
      "Principal": "*"
    }
  ]
}
```

### Step3:

* Copy paste this policy to the Bucket Policy Editor and save it

### Step4:

* Test it

# AWS CLI

* Create a json file bucketpolicy.json
* aws s3api put-bucket-policy --bucket my-test-bucket --policy [**here**](file://bucketpolicy.json)

# Using Terraform

Check the terraform file...