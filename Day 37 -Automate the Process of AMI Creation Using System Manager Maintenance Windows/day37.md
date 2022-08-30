* AWS Systems Manager Maintenance Windows

    * AWS Systems Manager Maintenance Windows let you define a schedule for when to perform potentially disruptive actions on your instances such as patching an operating system, updating drivers, or installing software or patches. Each Maintenance Window has a schedule, a maximum duration, a set of registered targets (the instances that are acted upon), and a set of registered tasks. You can add tags to your Maintenance Windows when you create or update them.

* Configuring access to Maintenance Window

    * This can be done with the help of IAM role so that System Manager can act on our behalf in creating and performing maintenance window

    * Go to IAM Role [**here**](https://console.aws.amazon.com/iam/) → Create role → EC2 → Choose AmazonSSMMaintenanceWindowRole
    * Give your role name and create it
    * Now click on the role you have just created and click on Trust relationship


