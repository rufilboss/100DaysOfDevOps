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
