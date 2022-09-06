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
