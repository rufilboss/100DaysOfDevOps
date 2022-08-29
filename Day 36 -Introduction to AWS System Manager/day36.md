* What Is AWS Systems Manager?

    * AWS Systems Manager is a collection of capabilities for configuring and managing your Amazon EC2 instances, on-premises servers and virtual machines, and other AWS resources at scale.

* Pre-requisites: There are two pre-requisites on setting up System Manager

    * Setting up IAM Role for System Manager

    * To use system manager you need to set up two roles

        * One role authorizes the user to use System Manager
        * First one assign AmazonSSMFullAccess policy to the user
        * Other authorizes systems to be authorized by the system manager
        * Create a new role and assign AmazonEc2Rolefor SSM
        * Attach the role, we've created earlier to an existing instance or during instance creation

