#### Problem: 
How to share resources in different AWS accounts i.e User in Account B(Developer) should have Read-Only Access to S3 Bucket in Account A(Production).

Solution: By setting up cross-account access using IAM roles.

#### Advantage

We don't need to set up individual IAM user in each account
The user doesn’t need to sign out of one account and sign into another account to access resources.

#### Pre-requisites
You need two AWS accounts(Account A(PROD)) and Account B(Developer))
An AWS S3 bucket created in Production Account A.

# Using AWS Management Console

### Step1: 
* Create an IAM Role in Account A(This is to establish the trust between the two accounts)

* Go to IAM console [**here**](https://console.aws.amazon.com/iam/home?region=us-west-2#/home)
* Click on Roles, Create role
* This time, select Another AWS account and enter Account ID of Account B
* To get the account id(Click on the IAM user on the top of the console and click on My Account)
* In next screen click on Create Policy and paste the below mentioned(Change the bucket name with the name of the bucket you want to share with Development Account) OR Choose S3ReadOnlyPolicy
```sh
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
       ],
      "Resource": "arn:aws:s3:::bucket name"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::bucket name/*"
    }
  ]
}
```
* Click Next and give your Role name
* Note down the Role ARN, we need it later.

### Step2:
* Grant Access to the role(This will allow users in Account B permissions to allow switching to the role)
* Go to the Role we have just created
* Click on Trust relationships → Edit trust relationships
* As you can see only root user has access to AssumeRole, change it with the arn of the user you want to assume this role

### Step3:
* Test access by Switching the role
* Again go back to the Account Tab but this time click on Switch Role
* Fill all the details
```sh
* Account: This is Prod/Account A ID
* Role: Role we created in Step1: S3ReadOnlyAccesstoDevAccount(Dont give full arn here just the Role name)
* Display Name: Any display name
* Switch Role
```
* Now go to S3 console and try to access S3 bucket which is present in Account A.

###### NOTE: You cannot switch to a role when you are signed in as the AWS account root user.