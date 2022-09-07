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

###### NOTE: As we already setup the IAM role, we don't need to hardcode the value of AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY.

* Now I am going to write a simple script which is going to sync data from your local folder to s3 bucket every minute

```sh
# cat /usr/bin/awss3sync.sh
#!/bin/bash
aws s3 sync /var/log/. s3://terraform-20190327040316452900000001
```

* Put that script in crontab so that it will execute every min

```sh
[root@ip-172-31-31-68 bin]# crontab -l
*/1 * * * * /usr/bin/awss3sync.sh
```

