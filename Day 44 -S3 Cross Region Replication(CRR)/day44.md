* What is Cross-Region Replication

    * Cross-region replication (CRR) enables automatic, asynchronous copying of objects across buckets in different AWS Regions. Buckets configured for cross-region replication can be owned by the same AWS account or by different accounts.

* Features and Limitations

    * It only replicates the object at the point of enabling replication, all the object before that can’t be replicated.
    * Cross region replication by default only replicates un-encrypted objects or objects which encrypted using SSE-S3(Server-Side Encryption with Amazon S3-Managed Keys)
    * SSE-C(Server-Side Encryption with Customer-Provided Keys) are not supported and SSE-KMS requires some extra configuration.
    * By default ownership and ACL are replicated and maintained but we can always customize it.
    The storage class is maintained by default.
    * Lifecycle events are not replicated
    * When the bucket owner has no permissions, objects are not replicated.
    * Cross region replication is uni-directional i.e from source to destination, not the other way i.e if I delete the file at the destination it will not be deleted at Source.

* Create a source and destination bucket in two different regions under the same account

    * Versioning must be enabled in both the bucket to configure Cross Region Replication
    * Any object that resides in the bucket before versioning is enabled will not be replicated.

###### Step1: Create Source Bucket

* Go to AWS Console --> [**here**](https://console.aws.amazon.com/s3) --> Create bucket

    * Give your bucket some name
    * Choose Region as US East(N. Virginia)

* Once the bucket is created

###### Step2: Enable versioning

* Click on the bucket --> Properties --> Versioning --> Enable versioning

###### Step3: Create a destination bucket

* Everything will be same, except Bucket name will be my-destination-s3-bucket-to-test-crr
* Region: US West(Oregon)
* Enabled Versioning

###### Step4: Enabled Cross Region Replication

* Go to your Source Bucket --> Management --> Replication --> Get started
* Select Entire bucket
* Select the destination Bucket
* Select new IAM role
* Give your Role name
* Review your settings and save it

###### Step5 : Test

* Go back to your Source S3 bucket(my-source-s3-bucket-to-test-crr) and try to upload some files
* Wait for a few mins, you will see the same file replicated to the destination bucket


##### Terraform code to automate the above setup

Check out: [**here**](https://github.com/rufilboy/100DaysOfDevOps/blob/main/Day%2044%20-S3%20Cross%20Region%20Replication(CRR)/aws_s3_cross_region.tf)
