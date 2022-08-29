* What Is AWS Systems Manager?

    * AWS Systems Manager is a collection of capabilities for configuring and managing your Amazon EC2 instances, on-premises servers and virtual machines, and other AWS resources at scale.

* Pre-requisites: There are two pre-requisites on setting up System Manager

    * Setting up IAM Role for System Manager

    * To use system manager you need to set up two roles

        * One role authorizes the user to use System Manager
        * First one assign AmazonSSMFullAccess policy to the user
        * Other authorizes systems to be authorized by the system manager
        * Create a new role and assign AmazonEc2Rolefor SSM
        * Attach the role, we've created earlier to an existing instance or during instance creation

* Installing SSM Agent

    ```sh

    # SSM Agent Installation

    sudo apt install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

    # Checking the status of System Manager

    $ sudo systemctl status amazon-ssm-agent

    # Enabling it so that it will start on reboot
    $ sudo systemctl enable amazon-ssm-agent
    ```

* This is installed on the instance end and let instance to communicate with System Manager
* Once installed go to System Manager home page [**here**](https://us-west-2.console.aws.amazon.com/systems-manager) → Shared Resources → Managed Instances

* Go to Actions → Run Command → AWS-RunShellScript → Commands → Type any Linux command eg: ls -l → Target Instance(Select the instance)
* You can also check the output under view output tab


###### To execute the same command via aws cli

```sh

$ aws ssm send-command --document-name "AWS-RunShellScript" --parameters commands=["ls -l"] --targets "Key=instanceids,Values=i-0219d24ebd3fc7b14"
{
    "Command": {
        "MaxErrors": "0", 
        "Parameters": {
            "commands": [
                "ls -l"
            ]
        }, 
        "DocumentName": "AWS-RunShellScript", 
        "OutputS3BucketName": "", 
        "OutputS3KeyPrefix": "", 
        "StatusDetails": "Pending", 
        "RequestedDateTime": 1552850042.208, 
        "Status": "Pending", 
        "TargetCount": 0, 
        "NotificationConfig": {
            "NotificationArn": "", 
            "NotificationEvents": [], 
            "NotificationType": ""
        }, 
        "InstanceIds": [], 
        "ErrorCount": 0, 
        "MaxConcurrency": "50", 
        "ServiceRole": "", 
        "CloudWatchOutputConfig": {
            "CloudWatchLogGroupName": "", 
            "CloudWatchOutputEnabled": false
        }, 
        "DocumentVersion": "", 
        "CompletedCount": 0, 
        "Comment": "", 
        "ExpiresAfter": 1552857242.208, 
        "DeliveryTimedOutCount": 0, 
        "CommandId": "e4d54b52-5138-4436-a53d-f9ed4dd03cf6", 
        "Targets": [
            {
                "Values": [
                    "i-0219d24ebd3fc7b14"
                ], 
                "Key": "instanceids"
            }
        ]
    }
}
```

* What is AWS Systems Manager State Manager

    * AWS Systems Manager State Manager is a secure and scalable configuration management service that automates the process of keeping your Amazon EC2 and hybrid infrastructure in a state that you define.
    * One of the use case I found out of AWS System Manager State Manager is to run the command on a scheduled basis(eg: SnapShot Creation)

###### But I believe there is a much better way to achieve this eg: EBS LifeCycle Manager

##### AWS Systems Manager Parameter Store

* AWS System Manager Parameter store provides secure, hierarchical storage for configuration data management and secrets management. We can store data such as,

    * passwords
    * database strings
    * license codes

* Which we can then be programmatically accessed via the SSM API.
* Parameter store is offered at no additional charge

* Go to AWS Systems Manager [**here**](https://us-west-2.console.aws.amazon.com/systems-manager) → Parameter store  → Create Parameter

###### Now to retrieve this value via command line

```sh
$ aws ssm get-parameters --names "examplepass"
{
"InvalidParameters": [],
"Parameters": [
{
"Name": "examplepass",
"LastModifiedDate": 1552923749.085,
"Value": "example123",
"Version": 1,
"Type": "String",
"ARN": "arn:aws:ssm:us-west-2:XXXXXXX:parameter/examplepass"
}
]
}
```

##### How to store a secure string

* When we store a secure string in the EC2 parameter store, the data is encrypted by the KMS key associated with the account.

[**Learn more**](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)

* You can access it via command line

```sh
$ aws ssm get-parameters --names "mysecurestring" --with-decryption
{
"InvalidParameters": [],
"Parameters": [
{
"Name": "mysecurestring",
"LastModifiedDate": 1552923877.289,
"Value": "test123",
"Version": 1,
"Type": "SecureString",
"ARN": "arn:aws:ssm:us-west-2:349934551430:parameter/mysecurestring"
}
]
}
```