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
* As you can see:
    * in var.my_public_key set the location as /tmp/id_rsa.pub
    * To refer to this file, we need to use the file function

* After AMI and Keys out of our way, let start building EC2 instance

```sh
resource "aws_instance" "test_instance" {
  count = "${var.instance_count}"
  ami = "${data.aws_ami.centos.id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.mytest-key.id}"
  vpc_security_group_ids = ["${var.security_group}"]
  subnet_id = "${element(var.subnet_mask, count.index )}"
  
  tags {
    Name = "my-test-server.${count.index + 1}"
  }
}
```

* Most of these parameters I already discussed in the first section, but let's quickly review it and check the new one
    * count: The number of instance, we want to create
    * ami: This time we are pulling ami using data resource
    * instance_type: Important parameter in AWS Realm, the type of instance we want to create
    * key_name: Resource we create earlier and we are just referencing it here
* Below two ones are special, because both of these resource we created during the vpc section, so now what we need to do is to output it during VPC module and use there output as the input to this module. I will discuss more about it later
    * tags: Tags are always helpful to assign label to your resources.

* If you notice the above code, one thing which is interesting here is vpc_security_group_ids and subnet_id
* The interesting part, we already created these as a part of VPC code, so we just need to call in our EC2 terraform and the way to do it using outputs.tf

```sh
output "public_subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "security_group" {
  value = "${aws_security_group.test_sg.id}"
}
```

* After calling these values here, we just need to define as the part of main module and the syntax of doing that is
    module.<module name>.<output variable>
    subnet_id      = "${module.vpc_networking.public_subnets}"                         security_group = "${module.vpc_networking.security_group}"

* Final module code for EC2 instance look like this:

```sh
module "ec2_instance" {
  source         = "./ec2_instance"
  instance_count = "${var.instance_count}"
  my_public_key  = "${var.my_public_key}"
  instance_type  = "${var.instance_type}"
  subnet_id      = "${module.vpc_networking.public_subnets}"
  security_group = "${module.vpc_networking.security_group}"
  alarm_actions  = "${module.sns.sns_topic}"
}
```

* Let’s create two EBS volumes and attach it to two EC2 instances we created earlier

```sh
resource "aws_ebs_volume" "my-test-ebs" {
  count             = 2
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  size              = 10
  type              = "gp2"
}

resource "aws_volume_attachment" "my-test-ebs-attachment" {
  count       = 2
  device_name = "/dev/xvdh"
  instance_id = "${aws_instance.test_instance.*.id[count.index]}"
  volume_id   = "${aws_ebs_volume.my-test-ebs.*.id[count.index]}"
}
```
* So,
    * To create EBS Volumes, I am using ebs_volume resource and to attach it use aws_volume_attachment
    * We are creating two Volumes here
    * AS Volume is specific to Availibility Zone, I am using aws_availibility_zone data resource
    * Size of the Volume is 10GB
    * Type is gp2(other available options "standard", "gp2", "io1", "sc1" or "st1" (Default: "standard"))

* Next step is to define user data resource, what this will do, during the instance building process it’s going to attach EBS Volumes we created in earlier step.

```sh
data "template_file" "user-init" {
  template = "${file("${path.module}/userdata.tpl")}"
}
```
```sh
#!/bin/bash
mkfs.ext4 /dev/xvdh
mount /dev/xvdh /mnt
echo /dev/xvdh /mnt defaults,nofail 0 2 >> /etc/fstab
```
* Also,
    * Special parameter in this is path.module which is going to refer to exisiting module path in our case ec2_instance

* The last step is to refer user_data resource back in your terraform code
    user_data = "${data.template_file.user-init.rendered}"

```sh
resource "aws_instance" "test_instance" {
  count = "${var.instance_count}"
  ami = "${data.aws_ami.centos.id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.mytest-key.id}"
  vpc_security_group_ids = ["${var.security_group}"]
  subnet_id = "${element(var.subnet_mask, count.index )}"
  user_data = "${data.template_file.user-init.rendered}"
  tags {
    Name = "my-test-server.${count.index + 1}"
  }
}
```





