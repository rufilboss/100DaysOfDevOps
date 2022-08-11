* Adding monitoring piece can be achieved via two ways, we can add separate cloudwatch and SNS module and then call it in our EC2 module
* We can call the Cloudwatch and SNS terraform code directly in EC2 terraform module, I prefer this approach as we want all our EC2 instance comes up with monitoring enabled
* First, let start with SNS topic, which is required to send out a notification via Email, SMS when an event occurs.

