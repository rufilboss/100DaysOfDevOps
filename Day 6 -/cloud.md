# Using the AWS Management Console

### Problem: I want to deploy a simple monitoring system when any unauthorized trying to access my servers I will notify via SNS.

### Solution: This can be achieved using CloudWatch Metric Filter in combination with SNS.

## Step1

* Install CloudWatch Agent(Make sure you are pushing /var/log/messages and /var/log/secure logs from your instance to CloudWatch log group)
* At the same time, go to CloudWatch Logs and search for Invalid user string

## Step2

* Go to Management & Governance --> CloudWatch --> Logs --> messages --> 0 fileters --> Add Metric Filter
* Filter Pattern : Type Invalid user
* Select Log Data to Test: Select the right instance
* Keep everything default and give your metric some name(Metric Name: InvalidUserlogin)

## In the next screen, click on Create Alarm

* Give your alarm Name and Description
* Set the threshold, for demo I am setting up as 1
* Select the SNS topic 
* Your simple notification system against un-authorized user is up and running.
