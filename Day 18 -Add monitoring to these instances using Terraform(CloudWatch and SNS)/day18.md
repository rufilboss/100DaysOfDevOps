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

```sh
# cloudwatch_cpu_usage.tf
resource "aws_cloudwatch_metric_alarm" "cpu-utilization" {
  alarm_name                = "high-cpu-utilization-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]
dimensions {
    InstanceId = "${aws_instance.my_instance.*.id[count.index}"
  }
}
```

* Then,
    * Setup an alarm name
    * This field is self explanatory,supported operators GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold.
    * evaluation_period: The number of periods over which data is compared to the specified threshold
    * metric_name: Please check the link below list of services that publish cloudwatch metrics
    * namespace: The namespace for the alarm's associated metric(Check the second column of the link below)
    * period: period in second(I am using 120 sec or 2min but again it completly depend upon your requirements)
    * statistic: The statistic to apply to the alarm's associated metric, supported value: SampleCount, Average, Sum, Minimum, Maximum
    * threshold: The value against which the specified statistic is compared.(I set it up as 80% i.e when CPU utilization goes above 80%)
    * alarm_actions: The list of actions to execute when this alarm transitions into an ALARM state from any other state. Please note, each action is specified as an Amazon Resource Name (ARN)
    * dimensions: The dimensions for the alarm's associated metric. Again check the below mentioned link for supported dimensions

* So what this is doing this code is going to send an email using SNS notification when CPU Utilization is more than 80%.
* Now look at the other part is to perform system and instance failure and send an email using SNS notification

```sh
resource "aws_cloudwatch_metric_alarm" "instance-health-check" {
  alarm_name                = "instance-health-check"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]
dimensions {
    InstanceId = "${aws_instance.my_instance.*.id[count.index}"
  }
}
```
* Most of this code is almost similar, only difference is metric _name here is StatusCheckFailed


* Final EC2 code with CloudWatch Monitoring and SNS topic enabled look like this