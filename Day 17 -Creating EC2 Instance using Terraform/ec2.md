* In order to deploy EC2 instance we need a bunch of resources:
    * AMI
    * Key Pair
    * EBS Volumes Creation
    * User data

* The first step in deploying EC2 instance is choosing correct AMI and in terraform, there are various ways to do that
    * We can hardcode the value of AMI
    * We can use data resource(similar to what we used for Availability Zone in VPC section) to query and filter
    * AWS and get the latest AMI based on the region, as the AMI id is different in a different region.

```sh
# To get the latest Centos7 AMI
data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
```
###### NOTE: Use of data resource is not ideal and each and every used case, eg: In the case of Production we might want to use a specific version of CentOS.

* The above code will help us to get the latest Centos AMI, the code is self-explanatory but one important parameter we used is owners
* owners - (Optional) Limit search to specific AMI owners. Valid items are the numeric account ID, amazon, or self.
* most_recent - (Optional) If more than one result is returned, use the most recent AMI.This is to get the latest Centos AMI as per our use case.

* Other ways to find the AMI ID
```sh
Go to https://us-west-2.console.aws.amazon.com/ec2 --> Instances --> Launch Instances --> Search for centos 
```

* Same thing you can do using AWS CLI
```sh
aws --region us-west-2 ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce
```