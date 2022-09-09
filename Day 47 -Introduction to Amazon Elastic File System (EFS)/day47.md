* What is Amazon EFS?

    * Amazon EFS provides scalable file storage for use with Amazon EC2. You can create an EFS file system and configure your instances to mount the file system. You can use an EFS file system as a common data source for workloads and applications running on multiple instances.

###### Step1: Create a security group to access your AWS EFS Filesystem

* To enable traffic between EC2 instance and EFS Filesystem we must need to allow port 2049.
* On the EC2 client side, we must need to allow outbound access to Port 2049. As we are allowing all the outbound traffic so this pre-requisite is already met.
