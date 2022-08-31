* AWS Systems Manager Maintenance Windows

    * AWS Systems Manager Maintenance Windows let you define a schedule for when to perform potentially disruptive actions on your instances such as patching an operating system, updating drivers, or installing software or patches. Each Maintenance Window has a schedule, a maximum duration, a set of registered targets (the instances that are acted upon), and a set of registered tasks. You can add tags to your Maintenance Windows when you create or update them.

* Configuring access to Maintenance Window

    * This can be done with the help of IAM role so that System Manager can act on our behalf in creating and performing maintenance window

    * Go to IAM Role [**here**](https://console.aws.amazon.com/iam/) → Create role → EC2 → Choose AmazonSSMMaintenanceWindowRole
    * Give your role name and create it
    * Now click on the role you have just created and click on Trust relationship
    ```sh
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com",
            "Service": "ssm.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    ```
    * Then,
        * Add this entry("Service": "ssm.amazonaws.com")
        * Please don't forget to add comma(,) after "Service": "ec2.amazonaws.com",

* Add an inline policy to the user, also make sure that particular user also have AWSSSMFullAccess Policy attach to it

```sh
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::XXXXXX:role/MaintainenceWindowRole"
        }
    ]
}
```

* Next step is to create the Maintenance Window

    * Go to [**here**](https://us-west-2.console.aws.amazon.com/systems-manager) → Action → Maintenance Windows

    * Once the maintenance window create, choose Target → Register target

    * Click on the Tasks Tab and Choose AWS-Createimage as automation Document

    * Keep everything default, except
        * Give the instance id from where you want to create the image
        * NoReboot: set it to true else it will reboot the instance,during image creation
        * AutomationAssumeRole: Paste the arn of role we create in earlier step
