* What is AWS S3?

    AWS Simple Storage Service(S3) provides secure, durable and highly scalable object storage. S3 is easy to use and we can store and retrieve any amount of data from anywhere on the web.

* Let’s create S3 bucket using terraform

```sh
provider "aws" {
  region = "us-west-2"
}
resource "aws_s3_bucket" "example" {
  bucket = "my-test-s3-terraform-bucket"
  acl = "private"
  versioning {
    enabled = true
  }
  tags {
    Name = "my-test-s3-terraform-bucket"
  }
}
```

    bucket: name of the bucket, if we ommit that terraform will assign random bucket name
    acl: Default to Private(other options public-read and public-read-write)
    versioning: Versioning automatically keeps up with different versions of the same object.

