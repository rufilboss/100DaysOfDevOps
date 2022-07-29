# Using AWS Management Console

## Step1: Create an AWS Access key and Secret Key

* Go to IAM console https://console.aws.amazon.com/iam/home?region=us-west-2#/home
* Click on Users → Particular user → Security Credentials
* Click on Create Access Key
* Save the Access Key and Secret Key as we'll need them later while configuring Lambda function.

## Step2: Create an IAM Role

* Go to IAM console https://console.aws.amazon.com/iam/home?region=us-west-2#/home
* Roles → Create role → AWS service → Lambda
* Search for AWSLambdaBasicExecutionRole
* Give it a name
* Click on create Role
* Copy the role arn, we need it for future configuration.

## Step3: Deploy the Lambda Function

* For the purpose of this demo, we'll be using Public GitHub Repo
```sh
Step 1:
$ git clone https://github.com/assertible/lambda-cloudwatch-slack.git
Cloning into 'lambda-cloudwatch-slack'...
remote: Enumerating objects: 244, done.
remote: Total 244 (delta 0), reused 0 (delta 0), pack-reused 244
Receiving objects: 100% (244/244), 668.48 KiB | 3.56 MiB/s, done.
Resolving deltas: 100% (120/120), done.
Step 2:
$ cd lambda-cloudwatch-slack/
Step 3:
cp .env.example .env
```
* Now we need to perform some configuration at Slack End
* Go to Slack, Apps section and click on Add apps
* Search for incoming-webhook
* Enter the channel name where you want to send a notification, also note down Webhook URL
* Under .env file,enter the following info
```sh
#ENCRYPTED_HOOK_URL= you can use ENCRYPTED_HOOK_URL if you want
UNENCRYPTED_HOOK_URL=Step3
AWS_FUNCTION_NAME=cloudwatch-to-slack
AWS_REGION=us-west-2
AWS_ROLE="Step2"

# You can get AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY here: https://console.aws.amazon.com/iam/home#/users
# Click on user -> Security credentials -> Access keys -> Create access key
AWS_ACCESS_KEY_ID= Step1
AWS_SECRET_ACCESS_KEY= Step1
```
