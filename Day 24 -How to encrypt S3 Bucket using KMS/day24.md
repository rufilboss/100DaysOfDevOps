Before I am going to define how to encrypt S3 bucket using KMS, let get this thing out of the way S3 doesn’t encrypt buckets, objects are encrypted and the setting are defined at an object level.

Earlier it was not possible to define encryption at a bucket level and there are many use cases to prevent uploads of unencrypted objects to an Amazon S3 bucket

To upload an object to S3, you use a Put request, regardless if called via the console, CLI, or SDK. The Put request looks similar to the following.

