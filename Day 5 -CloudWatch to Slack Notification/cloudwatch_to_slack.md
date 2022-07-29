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
* After making these changes, execute the following command on the terminal
```sh
$ npm install
added 136 packages in 4.039s
╭─────────────────────────────────────╮
│                                     │
│   Update available 5.6.0 → 5.8.0    │
│     Run npm i -g npm to update      │
│                                     │
╰─────────────────────────────────────╯
```
* Finally, deploy it
```sh
$ npm run deploy
> lambda-cloudwatch-slack@0.3.0 deploy /Users/plakhera/Documents/lambda-cloudwatch-slack
> ./scripts/deploy.sh
Warning!!! You are building on a platform that is not 64-bit Linux (darwin.x64).
If any of your Node dependencies include C-extensions, they may not work as expected in the Lambda environment.
=> Moving files to temporary directory
=> Running npm install --production
=> Zipping deployment package
=> Zipping repo. This might take up to 30 seconds
=> Reading zip file to memory
=> Reading event source file to memory
=> Uploading zip file to AWS Lambda us-west-2 with parameters:
{ FunctionName: 'cloudwatch-to-slack',
Code: { ZipFile: <Buffer 50 4b 03 04 14 00 08 00 08 00 20 10 4a 4e 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 2e 65 6e 76 6d 90 5d 4f 83 30 18 85 ef f9 15 8d bb 5c 18 9b ... > },
Handler: 'index.handler',
Role: 'arn:aws:iam::XXXXXX:role/cloudwatch-to-lambda',
Runtime: 'nodejs8.10',
Description: 'Better Slack notifications for AWS CloudWatch',
MemorySize: 128,
Timeout: 60,
Publish: false,
VpcConfig: { SubnetIds: [], SecurityGroupIds: [] },
Environment: { Variables: { UNENCRYPTED_HOOK_URL: 'https://hooks.slack.com/services/XXXXXXXX' } },
KMSKeyArn: '',
DeadLetterConfig: { TargetArn: null },
TracingConfig: { Mode: null } }
^C
╭─────────────────────────────────────╮
│                                     │
│   Update available 5.6.0 → 6.7.0    │
│     Run npm i -g npm to update      │
│                                     │
╰─────────────────────────────────────╯
```
