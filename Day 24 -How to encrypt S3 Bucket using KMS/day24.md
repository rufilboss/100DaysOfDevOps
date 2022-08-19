Before I am going to define how to encrypt S3 bucket using KMS, let get this thing out of the way S3 doesn’t encrypt buckets, objects are encrypted and the setting are defined at an object level.

Earlier it was not possible to define encryption at a bucket level and there are many use cases to prevent uploads of unencrypted objects to an Amazon S3 bucket

To upload an object to S3, you use a Put request, regardless if called via the console, CLI, or SDK. The Put request looks similar to the following.

```sh
PUT /example-object HTTP/1.1
Host: myBucket.s3.amazonaws.com
Date: Wed, 8 Jun 2016 17:50:00 GMT
Authorization: authorization string
Content-Type: text/plain
Content-Length: 11434
x-amz-meta-author: Janet
Expect: 100-continue
[11434 bytes of object data]
```

* To encrypt an object at the time of upload, you need to add a header called x-amz-server-side-encryption to the request to tell S3 to encrypt the object using SSE-C, SSE-S3, or SSE-KMS. The following code example shows a Putrequest using SSE-S3.

