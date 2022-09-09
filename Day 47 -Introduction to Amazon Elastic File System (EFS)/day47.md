* What is Amazon EFS?

    * Amazon EFS provides scalable file storage for use with Amazon EC2. You can create an EFS file system and configure your instances to mount the file system. You can use an EFS file system as a common data source for workloads and applications running on multiple instances.

###### Step1: Create a security group to access your AWS EFS Filesystem

* To enable traffic between EC2 instance and EFS Filesystem we must need to allow port 2049.
* On the EC2 client side, we must need to allow outbound access to Port 2049. As we are allowing all the outbound traffic so this pre-requisite is already met.
* On the mount target end, we must need to allow TCP Port 2049 inbound for NFS from all EC2 instances on which we want to mount the filesystem.

* Go to [**here**](https://us-west-2.console.aws.amazon.com/ec2) → NETWORK & SECURITY → Security Groups --> Create Security Group

    * Type : Should be NFS
    * Source: Rather than opening it for the entire subnet, we are only opening it for EFS Client Security Group

###### Step2: Create an Amazon EFS FileSystem

* EFS FileSystem can be mounted to multiple EC2 instances running in different availability zone with the same region. These instances use mount targets created in each Availability Zone to mount the filesystem using the standard Network File System.

###### NOTE: All the instances where we are trying to mount the Filesystem must be the part of the same VPC.

* Go to [**here**](https://us-west-2.console.aws.amazon.com/efs) → Create file system

    * Add tag to your FileSystem
    * Keep all the other values default
    * Review and create the filesystem

* If you now click on the Amazon EC2 mount instructions(from local VPC), that will give you the detailed instruction which package to install and how to mount the filesystem

