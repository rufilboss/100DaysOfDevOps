#### Problem: How to take a snapshot of our EBS Volumes everyday

#### Solution: There are multiple ways to achieve this, I am just focussing on two

* CloudWatch Events
* EBS LifeCycle Manager

###### What is EBS Snapshots?

* Snapshots are a point in time backups of EBS Volumes that are stored in S3.
* They are incremental in nature i.e first snapshot is the complete backup of your Volume but all the subsequent snapshot is just an incremental change.
* We can use snapshots to create an AMI
* Mostly used for a backup purpose to fully restore your EBS Volumes.
* The recommendation is to frequently take snapshots depending upon your Recovery Time Objective(RTO)
* For data consistency, it’s good to stop any write operation before performing snapshots.

# Using AWS Management Console

### CloudWatch Events
* Go to AWS Console [**here**](https://us-west-2.console.aws.amazon.com/cloudwatch) → Management Tools → CloudWatch → Events → Create rule
    * Under Event Source, Choose Schedule 
    * Choose the Schedule based on your requirement(for eg: I want this Process to be triggered 1.25 am everyday
    * In the Targets section, Choose EC2 CreateSnapshot API call and give your Volume ID
    * For CloudWatch Event to interact with EBS Volume it need an IAM role, Choose any existing one or create new one

##### NOTE: All scheduled events use UTC time zone, so might need to change based on your timezone

* On the next screen give your Snapshot some name and Description
* Now go to the EC2 console [**here**](https://us-west-2.console.aws.amazon.com/ec2/)
* Under ELASTIC BLOCK STORE, click on Snapshots

* One of the major limitations, I see in this approach, is I don't see any option to delete snapshot after n number of days(eg: After 30 days)

### Data Life Cycle Manager

* This is probably the easiest way, where using single service we can Create and Manage(deleting it after ’n’ number of days) EBS snapshots
* Go to AWS → Compute → EC2 → Elastic Block Store → Lifecycle Manager → Create Snapshot Lifecycle Policy
    * Description: Add a description to your policy to help you identify what it is intended for.
    * Target volumes with tags: Add the Volume 
    * Create snapshots every: 12 or 24 hour
    * Snapshot creation start time: 5:00(Timing is in UTC)
    * Retention rule: 30(Depending upon your requirement)
    * Keep all the other values as default

###### NOTE: Snapshot creation start time hh:mm UTC — The time of day when policy runs are scheduled to start. The policy runs start within an hour after the scheduled time