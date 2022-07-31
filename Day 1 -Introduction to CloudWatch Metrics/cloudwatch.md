# Setup a CPU Usage Alarm using the AWS Management Console.

1. Open the CloudWatch console at [**here**](https://console.aws.amazon.com/cloudwatch/)
2. In the navigation pane, choose Alarms, Create Alarm.
3. Go to Metric → Select metric → EC2 → Per-Instance-Metrics → CPU Utilization → Select metric

## Define the Alarm as follows
* Type the unique name for the alarm(eg: HighCPUUtilizationAlarm)
* Description of the alarm
* Under whenever,choose >= and type 70, for type 2. This specify that the alarm is triggered if the CPU usage is above 70% for two consecutive sampling period
* Under Additional settings, for treat missing data as, choose bad(breaching threshold), as missing data points may indicate that the instance is down
* Under Actions, for whenever this alarm, choose state is alarm. For Send notification to, select an exisiting SNS topic or create a new one 
* To create a new SNS topic, choose new list, for send notification to, type a name of SNS topic(for eg: HighCPUUtilizationThreshold) and for Email list type a comma-seperated list of email addresses to be notified when the alarm changes to the ALARM state.
* Each email address is sent to a topic subscription confirmation email. You must confirm the subscription before notifications can be sent.
* Click on Create Alarm.

# Setup CPU Usage Alarm using the AWS CLI

1. Create an alarm using the put-metric-alarm command

```sh
$ aws cloudwatch put-metric-alarm --alarm-name cpu-mon --alarm-description "Alarm when CPU exceeds 70 percent" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold  --dimensions "Name=InstanceId,Value=i-12345678" --evaluation-periods 2 --alarm-actions arn:aws:sns:us-east-1:111122223333:MyTopic --unit Percent
```

2. Using the command line, we can test the Alarm by forcing an alarm state change using a set-alarm-state command

3. Change the alarm-state from INSUFFICIENT_DATA to OK

```sh
$ aws cloudwatch set-alarm-state --alarm-name "cpu-monitoring" --state-reason "initializing" --state-value OK
```

4. Change the alarm-state from OK to ALARM

```sh
$ aws cloudwatch set-alarm-state --alarm-name "cpu-monitoring" --state-reason "initializing" --state-value ALARM
```

5. Lastly, check if you have received an email notification about the alarm.

# Setup CPU Usage Alarm using the Terraform

Create a new file named cloudwatch.tf
```sh
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
    InstanceId = "${aws_instance.my_instance.id}"
  }
}
```