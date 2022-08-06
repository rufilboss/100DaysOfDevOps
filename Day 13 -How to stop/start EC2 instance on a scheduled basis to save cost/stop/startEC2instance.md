#### Problem:
* Shutdown all EC2 instance in AWS DEV account at 6pm and bring it back next day at 9am(Monday to Friday)

#### Solution:
* Using Lambda function in combination of CloudWatch events.

* One of the major challenge in implementing this what would be the case if Developer is working late and he wants his instance to be run beyond 6 pm or if there is an urgent patch he needs to implement and need to work on the weekend?
* One common solution we come out is manually specifying the list of an instance in Python Code(Lambda Function) and in case of exception it goes through change management process where we need to remove developer instance manually(Agree not an ideal solution but so far works great)

# Using AWS Management Console

## Step1:
* Create IAM Role so that Lambda can interact with CloudWatch Events
* Go to IAM Console [**here**](https://console.aws.amazon.com/iam/home?region=us-west-2#/home) --> Roles --> Create role
* In the next screen, select Create Policy, IAM Policy will look like this
```sh
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    }
  ]
}
```
* Add this newly created policy to the role.

## Step2:

* Create Lambda function
* Go to Lambda [**here**](https://us-west-2.console.aws.amazon.com/lambda/home?region=us-west-2#/home)
* Select Create Function
    * Select Author from scratch
    * Name: Give your Lambda function any name
    * Runtime: Select Python2.7 as runtime
    * Role: Choose the role we create in first step
    * Click on Create function

* In this scenario, we need to create Function one to stop instance and others to start an instance
* To stop the instance, the code will look like this

```sh
import boto3
# Enter the region your instances are in. Include only the region without specifying Availability Zone; e.g., 'us-east-1'
region = 'XX-XXXXX-X'
# Enter your instances here: ex. ['X-XXXXXXXX', 'X-XXXXXXXX']
instances = ['X-XXXXXXXX']

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name=region)
    ec2.stop_instances(InstanceIds=instances)
    print 'stopped your instances: ' + str(instances)
```

    * Change the Value of region
    * In the instance field specify instance id
* Keep all the settings as default, just change the timeout value to 10sec
* Now we need to perform the same steps for starting the instance
```sh
import boto3
# Enter the region your instances are in. Include only the region without specifying Availability Zone; e.g.; 'us-east-1'
region = 'XX-XXXXX-X'
# Enter your instances here: ex. ['X-XXXXXXXX', 'X-XXXXXXXX']
instances = ['X-XXXXXXXX']

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name=region)
    ec2.start_instances(InstanceIds=instances)
    print 'started your instances: ' + str(instances)
```

## Step2:
* Create the CloudWatch event to trigger this Lambda function
* Open the Amazon CloudWatch console.
* Choose Events, and then choose Create rule.
* Choose Schedule under Event Source.
    * Under Cron expression choose * 18 * * ? * (If you want to shutdown your instance at 6pm everyday)
    * Choose Add target, and then choose Lambda function that you created earlier to stop the instance
* Same steps need to be repeated for Starting the instance
    * Only difference is different time schedule
    * Under target different Lambda function(to start the instance)
##### NOTE: One very important point to note is that all scheduled event is in UTC timezone, so you need to customize it based on your timezone.
* Once the event is triggered, go to your
    * Lambda function --> Monitoring --> View logs in CloudWatch
* For stopping the instance, you will see something like this
* For starting the instance
* The simple automation system is ready in stopping/starting the instance and to save some company money.