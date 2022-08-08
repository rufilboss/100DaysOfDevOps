###### What is terraform?
    Terraform is a tool for provisioning infrastructure(or managing Infrastructure as Code). It supports multiple providers(eg, AWS, Google Cloud, Azure, OpenStack..)

##### Installing Terraform
    Installing terraform is pretty straightforward, download it from terraform download page and select the appropriate package based on your operating system.

###### NOTE: I'm using Ubuntu system which has same installation has debian.

###### Requirements: Before downloading terraform we need to install wget and curl tools

```sh
# Debian / Ubuntu systems
sudo apt update
sudo apt install wget curl unzip

# RHEL based systems
sudo yum install curl wget unzip
```

Then, run the following command:

```sh
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
```

* Once the archive is downloaded, extract and move terraform binary file to the /usr/local/bin directory.

```sh
$ unzip terraform_${TER_VER}_linux_amd64.zip
Archive:  terraform_xxx_linux_amd64.zip
 inflating: terraform

$ sudo mv terraform /usr/local/bin/
```
* Moving it to /usr/local/bin/ will make the tool accessible to all user accounts.
```sh
$ which terraform
/usr/local/bin/terraform
```
* Also, don't forget to check the version of Terraform installed using this command:
```sh
$ terraform --version
Terraform v1.2.3
on linux_amd64
```

###### NOTE: To update Terraform on Linux, download the latest release and use the same process to extract and move binary file to location in your PATH.

* As mentioned above terraform support many providers, for my use case I am using AWS.

* Prerequisites
    * Existing AWS Account(OR Setup a new account)
    * IAM full access(OR at least have AmazonEC2FullAccess)
    * AWS Credentials(AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY)

* Once you have pre-requisites 1 and 2 done, the first step is to export Keys AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
    * export AWS_ACCESS_KEY_ID=”your access key id here”
    * export AWS_SECRET_ACCESS_KEY=”your secret access key id here.”

* This is required as we need to make changes to AWS account.

###### NOTE: These two variables are bound to your current shell, in case of reboot, or if open a new shell window, these changes will be lost

* With all pre-requisites in place, it’s time to write your first terraform code, but before that just a brief overview about terraform language
    * Terraform code is written in the HashiCorp Configuration Language(HCL)
    * All the code ends with the extension of .tf
    * It’s a declarative language(We need to define what infrastructure we want and terraform will figure out how to create it)
* In this first example I am going to build EC2 instance, but before creating EC2 instance go to AWS console and think what the different things we need to build EC2 instance are: 
    * Amazon Machine Image(AMI)
    * Instance Type
    * Network Information(VPC/Subnet)
    * Tags
    * Security Group
    * Key Pair

* Let break it to steps by step:
    * Amazon Machine Image(AMI): It’s an Operating System Image used to run EC2 instance. For this example I am using Red Hat Enterprise Linux 7.5 (HVM), SSD Volume Type — ami-28e07e50. We can create our own AMI using AWS console or Packer.

    * Instance Type: Type of EC2 instance to run, as every instance type provide different capabilities(CPU, Memory, I/O). For this example, I am using t2.micro(1 Virtual CPU, 1GB Memory)

    * Network Information(VPC/Subnet Id): Virtual Private Cloud(VPC) is an isolated area of AWS account that has it’s own virtual network and IP address space. For this example, I am using default VPC which is the part of new AWS account. In case if you want to set up your instance in custom VPC, you need to add two additional parameters(vpc_security_group_ids and subnet_id) to your terraform code

    * Tags: Tag we can think of a label which helps to categorize AWS resources.

    * Security Group: Security group can think like a virtual firewall, and it controls the traffic of your instance

    * Key Pair: Key Pair is used to access EC2 instance

* Let review all these parameters and see what we already have and what we need to create to spun our first EC2 instance

    * Amazon Machine Image(AMI) → ami-28e07e50
    * Instance Type → t2.micro
    * Network Information(VPC/Subnet) → Default VPC
    * Tags
    * Security Group
    * Key Pair

* So we already have AMI, Instance Type and Network Information, we need to write terraform code for rest of the parameter to spun our first EC2 instance

##### Let start with Key Pair

* Go to terraform documentation and search for aws key pair
```sh
resource "aws_key_pair" "example" {
  key_name = "example-key"
  public_key = "Copy your public key here"
}
```
* Let try to dissect this code
    * Under resource, we specify the type of resource to create, in this case we are using aws_key_pair as a resource
    * An example is an identifier which we can use throughout the code to refer back to this resource
    * key_name: Is the name of the Key
    * public_key: Is the public portion of ssh generated Key

##### The same thing we need to do for Security Group, go back to the terraform documentation and search for the security group

```sh
resource "aws_security_group" "examplesg" {
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
* Same thing let do with this code, first two parameter is similar to key pair
* ingress: refer to in-bound traffic to port 22, using protocol tcp
* cidr_block: list of cidr_block where you want to allow this traffic(This is just as an example please never use 0.0.0.0/0)

* With Key_pair and Security Group in place it’s time to create first EC2 instance.

##### Final Block: Creating your first EC2 instance
```sh
resource "aws_instance" "ec2_instance" {
  ami = "ami-28e07e50"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.examplesg.id}"]
  key_name = "${aws_key_pair.example.id}"
  tags {
    Name = "first-ec2-instance"
  }
}
```

* In this case we just need to check the doc and fill out all the remaining values
* To refer back to the security group we need to use interpolation syntax by terraform

* This look like
```sh
"${var_to_interpolate}
```
* Whenever you see a $ sign and curly braces inside the double quotes, that means terraform is going to interpolate that code specially. To get the id of the security group

```sh
"${aws_security_group.examplesg.id}"
```

* Same thing applied to key pair
```sh
"${aws_key_pair.example.id}"
```

* Our code is ready but we are missing one thing, provider before starting any code we need to tell terraform which provider we are using(aws in this case)
```sh
provider "aws" {
  region = "us-west-2"
}
```

* This tells terraform that you are going to use AWS as provider and you want to deploy your infrastructure in us-west-2 region
* AWS has datacenter all over the world, which are grouped in region and availability zones. Region is a separate geographic area(Oregon, Virginia, Sydney) and each region has multiple isolated datacenters(us-west-2a,us-west-2b..)

##### So our final code look like this
```sh
provider "aws" {
  region = "us-west-2"
}
resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = "XXXX"
}
resource "aws_security_group" "examplesg" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "ec2_instance" {
  ami             = "ami-28e07e50"
  instance_type   = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.examplesg.id}"]
  key_name        = "${aws_key_pair.example.id}"
  tags {
    Name = "first-ec2-instance"
  }
}
```

###### NOTE: Before running terraform command to spun our first EC2 instance, run terraform fmt command which will rewrite terraform configuration files to a canonical format and style
```sh
$ terraform fmt
main.tf
```