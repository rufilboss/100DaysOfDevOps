# Setup a CPU Usage Alarm using the AWS Management Console.

1. Open the CloudWatch console at https://console.aws.amazon.com/cloudwatch/.
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

