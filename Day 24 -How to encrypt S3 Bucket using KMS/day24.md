* To upload an object to S3, you use a Put request, regardless if called via the console, CLI, or SDK. The Put request looks similar to the following.

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

```sh
PUT /example-object HTTP/1.1
Host: myBucket.s3.amazonaws.com
Date: Wed, 8 Jun 2016 17:50:00 GMT
Authorization: authorization string  
Content-Type: text/plain
Content-Length: 11434
x-amz-meta-author: Janet
Expect: 100-continue
x-amz-server-side-encryption: AES256
[11434 bytes of object data]
```

* In order to enforce object encryption, create an S3 bucket policy that denies any S3 Put request that does not include the x-amz-server-side-encryption header. There are two possible values for the x-amz-server-side-encryption header: AES256, which tells S3 to use S3-managed keys, and aws:kms, which tells S3 to use AWS KMS–managed keys.

Bucket Policy will look like this;

```sh

 {
     "Version": "2012-10-17",
     "Id": "PutObjPolicy",
     "Statement": [
           {
                "Sid": "DenyIncorrectEncryptionHeader",
                "Effect": "Deny",
                "Principal": "*",
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::<bucket_name>/*",
                "Condition": {
                        "StringNotEquals": {
                               "s3:x-amz-server-side-encryption": "AES256"
                         }
                }
           },
           {
                "Sid": "DenyUnEncryptedObjectUploads",
                "Effect": "Deny",
                "Principal": "*",
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::<bucket_name>/*",
                "Condition": {
                        "Null": {
                               "s3:x-amz-server-side-encryption": true
                        }
               }
           }
     ]
 }
 ```

 * Now if we try to upload the object to S3 bucket without encryption it should fail

```sh
$ aws s3 cp testingbucketencryption s3://mytestbuclet-198232055
upload failed: ./testingbucketencryption to s3://mytestbuclet-198232055/testingbucketencryption An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
```

* Let try it with encryption enabled

```sh
$ aws s3 cp testingbucketencryption s3://mytestbuclet-198232055 --sse AES256
upload: ./testingbucketencryption to s3://mytestbuclet-198232055/testingbucketencryption
```

* [**How To Prevent Uploads Of Unencrypted Objects To S3 On AWS**](https://aws.amazon.com/blogs/security/how-to-prevent-uploads-of-unencrypted-objects-to-amazon-s3/)

* If you want to deny via UI i.e if you want everyone to access your bucket via https

```sh
{
    "Version": "2012-10-17",
    "Id": "Policy1504640911349",
    "Statement": [
        {
            "Sid": "Stmt1504640908907",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
```

* There are two ways to use AWS KMS with AWS S3

    * Server Side Encryption(I am only going to discuss this)
    * Client Side Encryption

###### Server Side Encryption

* We can protect data at rest in Amazon S3 using three different modes of server-side encryption: SSE-S3, SSE-C, or SSE-KMS

    * SSE-S3 requires that Amazon S3 manage the data and master encryption keys.
    * SSE-C requires that you manage the encryption key.
    * SSE-KMS requires that AWS manage the data key but you manage the master key in AWS KMS.


* Go to S3 console --> [**here**](https://s3.console.aws.amazon.com/s3) --> Particular bucket

