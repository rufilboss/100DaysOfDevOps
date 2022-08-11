* Adding monitoring piece can be achieved via two ways, we can add separate cloudwatch and SNS module and then call it in our EC2 module
* We can call the Cloudwatch and SNS terraform code directly in EC2 terraform module, I prefer this approach as we want all our EC2 instance comes up with monitoring enabled
* First, let start with SNS topic, which is required to send out a notification via Email, SMS when an event occurs.

```sh
#sns_topic.tf
resource "aws_sns_topic" "alarm" {
  name = "alarms-topic"

  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
}
```

* Here I am trying to create an SNS topic resource
* give your SNS topic, some name
* After that I am using a default policy

###### NOTE: As with SNS, someone needs to confirm the email subscription that why I am using local-exec provisioners with terraform.

* Now let’s take a look at terraform code for CloudWatch.

* This code is divided into two parts

##### Setup CPU Usage Alarm using the Terraform
