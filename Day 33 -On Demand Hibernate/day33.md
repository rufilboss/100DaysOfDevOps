* Why do we need On Demand Hibernate

    * EC2 Instance can be up in a matter of a second, but booting OS and Application sometimes take several minutes
    * Warming up cache can take several minutes
    * Hibernate stores the in-memory state of the instance(along with Private and Elastic IP)
    * Pick up exactly where you left off
    * Supported instance type(M3, M4, M5, C3, C4, C5, R3, R4, and R5)
    * Supported OS(Amazon Linux 1)
    * Amazon Linux 2(work in progress), No support for Centos family :(. (Coming soon: Amazon Linux 2, Ubuntu, Windows Server 2008 R2, Windows Server 2012, Windows Server 2012 R2, Windows Server 2016, along with the SQL Server variants of the Windows AMIs)
    * Support for on-demand and reserved instance

* How it works

    * When we instruct instance to hibernate it will write it’s in-memory data to the mounted EBS Volume and then shut down itself
    * AMI as well as both EBS Volume need to be encrypted
    * Encryption ensures proper protection for sensitive data when it is copied from memory to the EBS volume
    * To test this feature, I need to do some reverse engineering

#### Step1: Create the snapshot of root volume and then use copy option, which enables encryption option.

* Create an AMI out of this volume(which is encrypted by default)
* Choose the supported instance type and make sure hibernation is enabled
* Also, make sure /root has sufficient space to hold in-memory data
* I can use uptime command to see that the instance has not been rebooted, but has continued from where it left off

[Learn More](https://aws.amazon.com/blogs/aws/new-hibernate-your-ec2-instances/)