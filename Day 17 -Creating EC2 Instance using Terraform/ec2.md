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

```sh

$ aws --region us-west-2 ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce
{
    "Images": [
        {
            "ProductCodes": [
                {
                    "ProductCodeId": "aw0evgkw8e5c1q413zgy5pjce", 
                    "ProductCodeType": "marketplace"
                }
            ], 
            "Description": "CentOS Linux 7 x86_64 HVM EBS ENA 1901_01", 
            "VirtualizationType": "hvm", 
            "Hypervisor": "xen", 
            "ImageOwnerAlias": "aws-marketplace", 
            "EnaSupport": true, 
            "SriovNetSupport": "simple", 
            "ImageId": "ami-01ed306a12b7d1c96", 
            "State": "available", 
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1", 
                    "Ebs": {
                        "SnapshotId": "snap-040d21883a90fad29", 
                        "DeleteOnTermination": false, 
                        "VolumeType": "gp2", 
                        "VolumeSize": 8, 
                        "Encrypted": false
                    }
                }
            ], 
            "Architecture": "x86_64", 
            "ImageLocation": "aws-marketplace/CentOS Linux 7 x86_64 HVM EBS ENA 1901_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-05713873c6794f575.4", 
            "RootDeviceType": "ebs", 
            "OwnerId": "679593333241", 
            "RootDeviceName": "/dev/sda1", 
            "CreationDate": "2019-01-30T23:43:37.000Z", 
            "Public": true, 
            "ImageType": "machine", 
            "Name": "CentOS Linux 7 x86_64 HVM EBS ENA 1901_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-05713873c6794f575.4"
        }, 
        {
            "ProductCodes": [
                {
                    "ProductCodeId": "aw0evgkw8e5c1q413zgy5pjce", 
                    "ProductCodeType": "marketplace"
                }
            ], 
            "Description": "CentOS Linux 7 x86_64 HVM EBS ENA 1803_01", 
            "VirtualizationType": "hvm", 
            "Hypervisor": "xen", 
            "ImageOwnerAlias": "aws-marketplace", 
            "EnaSupport": true, 
            "SriovNetSupport": "simple", 
            "ImageId": "ami-0ebdd976", 
            "State": "available", 
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1", 
                    "Ebs": {
                        "SnapshotId": "snap-0b665edcc96bbb410", 
                        "DeleteOnTermination": false, 
                        "VolumeType": "gp2", 
                        "VolumeSize": 8, 
                        "Encrypted": false
                    }
                }
            ], 
            "Architecture": "x86_64", 
            "ImageLocation": "aws-marketplace/CentOS Linux 7 x86_64 HVM EBS ENA 1803_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-8274d6ff.4", 
            "RootDeviceType": "ebs", 
            "OwnerId": "679593333241", 
            "RootDeviceName": "/dev/sda1", 
            "CreationDate": "2018-04-04T00:11:39.000Z", 
            "Public": true, 
            "ImageType": "machine", 
            "Name": "CentOS Linux 7 x86_64 HVM EBS ENA 1803_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-8274d6ff.4"
        }, 
        {
            "ProductCodes": [
                {
                    "ProductCodeId": "aw0evgkw8e5c1q413zgy5pjce", 
                    "ProductCodeType": "marketplace"
                }
            ], 
            "Description": "CentOS Linux 7 x86_64 HVM EBS ENA 1805_01", 
            "VirtualizationType": "hvm", 
            "Hypervisor": "xen", 
            "ImageOwnerAlias": "aws-marketplace", 
            "EnaSupport": true, 
            "SriovNetSupport": "simple", 
            "ImageId": "ami-3ecc8f46", 
            "State": "available", 
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1", 
                    "Ebs": {
                        "SnapshotId": "snap-0313e2ec7fa27f2e9", 
                        "DeleteOnTermination": false, 
                        "VolumeType": "gp2", 
                        "VolumeSize": 8, 
                        "Encrypted": false
                    }
                }
            ], 
            "Architecture": "x86_64", 
            "ImageLocation": "aws-marketplace/CentOS Linux 7 x86_64 HVM EBS ENA 1805_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-77ec9308.4", 
            "RootDeviceType": "ebs", 
            "OwnerId": "679593333241", 
            "RootDeviceName": "/dev/sda1", 
            "CreationDate": "2018-06-13T15:58:14.000Z", 
            "Public": true, 
            "ImageType": "machine", 
            "Name": "CentOS Linux 7 x86_64 HVM EBS ENA 1805_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-77ec9308.4"
        }, 
        {
            "ProductCodes": [
                {
                    "ProductCodeId": "aw0evgkw8e5c1q413zgy5pjce", 
                    "ProductCodeType": "marketplace"
                }
            ], 
            "Description": "CentOS Linux 7 x86_64 HVM EBS ENA 1804_2", 
            "VirtualizationType": "hvm", 
            "Hypervisor": "xen", 
            "ImageOwnerAlias": "aws-marketplace", 
            "EnaSupport": true, 
            "SriovNetSupport": "simple", 
            "ImageId": "ami-5490ed2c", 
            "State": "available", 
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1", 
                    "Ebs": {
                        "SnapshotId": "snap-012ad984270e9fede", 
                        "DeleteOnTermination": false, 
                        "VolumeType": "gp2", 
                        "VolumeSize": 8, 
                        "Encrypted": false
                    }
                }
            ], 
            "Architecture": "x86_64", 
            "ImageLocation": "aws-marketplace/CentOS Linux 7 x86_64 HVM EBS ENA 1804_2-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-55a2322a.4", 
            "RootDeviceType": "ebs", 
            "OwnerId": "679593333241", 
            "RootDeviceName": "/dev/sda1", 
            "CreationDate": "2018-05-17T09:30:44.000Z", 
            "Public": true, 
            "ImageType": "machine", 
            "Name": "CentOS Linux 7 x86_64 HVM EBS ENA 1804_2-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-55a2322a.4"
        }, 
        {
            "ProductCodes": [
                {
                    "ProductCodeId": "aw0evgkw8e5c1q413zgy5pjce", 
                    "ProductCodeType": "marketplace"
                }
            ], 
            "Description": "CentOS Linux 7 x86_64 HVM EBS 1708_11.01", 
            "VirtualizationType": "hvm", 
            "Hypervisor": "xen", 
            "ImageOwnerAlias": "aws-marketplace", 
            "EnaSupport": true, 
            "SriovNetSupport": "simple", 
            "ImageId": "ami-b63ae0ce", 
            "State": "available", 
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1", 
                    "Ebs": {
                        "SnapshotId": "snap-045714dfd4f364480", 
                        "DeleteOnTermination": false, 
                        "VolumeType": "standard", 
                        "VolumeSize": 8, 
                        "Encrypted": false
                    }
                }
            ], 
            "Architecture": "x86_64", 
            "ImageLocation": "aws-marketplace/CentOS Linux 7 x86_64 HVM EBS 1708_11.01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-95096eef.4", 
            "RootDeviceType": "ebs", 
            "OwnerId": "679593333241", 
            "RootDeviceName": "/dev/sda1", 
            "CreationDate": "2017-12-05T14:49:18.000Z", 
            "Public": true, 
            "ImageType": "machine", 
            "Name": "CentOS Linux 7 x86_64 HVM EBS 1708_11.01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-95096eef.4"
        }
    ]
}
```

* If you look at the Description field

```sh
"Description": "CentOS Linux 7 x86_64 HVM EBS 1708_11.01",
```

* Then check the Terraform code in of the filter we use “CentOS Linux 7 x86_64 HVM EBS *” and that is one of the reasons of using that

```sh
filter {
  name   = "name"
  values = ["CentOS Linux 7 x86_64 HVM EBS *"]
}
```

* As we are able to figure out the AMI part, the next step is to create and use the key pair
* Either we can hardcode the value of key pair or generate a new key via command line and then refer to this file

```sh
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/plakhera/.ssh/id_rsa): /tmp/id_rsa
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /tmp/id_rsa.
Your public key has been saved in /tmp/id_rsa.pub.
The key fingerprint is:
XXXXXXXXXXXXX
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|                 |
|                 |
|   . . .   .   . |
|. = . +.S .o. o .|
| *.= +. .oo.oo + |
|o =+=  o o+o+ * .|
|.. ++.. +..o =.+.|
|  .o+o   Eo oo+o |
+----[SHA256]-----+
```

```sh
resource "aws_key_pair" "mytest-key" {
  key_name = "my-test-terraform-key"
  public_key = "${file(var.my_public_key)}"
}
```