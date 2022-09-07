###### Step1: Need to assign IAM Role to the instance, so that has permission to write to S3 bucket

* Check out: [Xample]()

###### Step2: Create VPC endpoint for S3 bucket, so that data never leaves the AWS network

* Check out: [Xample]()

###### Step3: Create an S3 bucket and assigned it a LifeCycle Policy so that data after 30 days move to Standard IA storage class and after 60 days to Glacier.

* Check out: [Xample]()

###### Step4: Login to host and install epel-release, this is required as we need pip to install aws cli


```sh
# yum -y install epel-release
```

* Next step is to install pip

```sh
# yum -y install python2-pip.noarch
```
Then aws cli
```sh
# pip install awscli
```

* Test your access to S3 bucket

```sh
# aws s3 cp wtmp s3://terraform-20190327040316452900000001
upload: ./wtmp to s3://terraform-20190327040316452900000001/wtmp
```