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
