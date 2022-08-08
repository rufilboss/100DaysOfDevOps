### What is terraform?
    Terraform is a tool for provisioning infrastructure(or managing Infrastructure as Code). It supports multiple providers(eg, AWS, Google Cloud, Azure, OpenStack..)

#### Installing Terraform
    Installing terraform is pretty straightforward, download it from terraform download page and select the appropriate package based on your operating system.

###### NOTE: I'm using Ubuntu system which has same installation has debian.

###### Requirements: Install wget and curl tools, commands:

```sh
# Debian / Ubuntu systems
sudo apt update
sudo apt install wget curl unzip

# RHEL based systems
sudo yum install curl wget unzip
```

* Then, run the following command:

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

* The first command we are going to run to setup our instance is terraform init, what this will do is going to download code for a provider(aws) that we are going to use

```sh
$ terraform init
Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (1.29.0)...
The following providers do not have any version constraints in configuration,
so the latest version was installed.
To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.
* provider.aws: version = "~> 1.29"
Terraform has been successfully initialized!
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

* Next command we are going to run is “terraform plan”, this will tell what terraform actually do before making any changes
* This is good way of making any sanity check before making actual changes to env
* Output of terraform plan command looks similar to Linux diff command
    * (+ sign): Resource going to be created

    * (- sign): Resources going to be deleted

    * (~ sign): Resource going to be modified

```sh
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
------------------------------------------------------------------------
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
+ create
Terraform will perform the following actions:
+ aws_instance.ec2_instance
id:                                    <computed>
ami:                                   "ami-28e07e50"
associate_public_ip_address:           <computed>
availability_zone:                     <computed>
cpu_core_count:                        <computed>
cpu_threads_per_core:                  <computed>
ebs_block_device.#:                    <computed>
ephemeral_block_device.#:              <computed>
get_password_data:                     "false"
instance_state:                        <computed>
instance_type:                         "t2.micro"
ipv6_address_count:                    <computed>
ipv6_addresses.#:                      <computed>
key_name:                              "${aws_key_pair.example.id}"
network_interface.#:                   <computed>
network_interface_id:                  <computed>
password_data:                         <computed>
placement_group:                       <computed>
primary_network_interface_id:          <computed>
private_dns:                           <computed>
private_ip:                            <computed>
public_dns:                            <computed>
public_ip:                             <computed>
root_block_device.#:                   <computed>
security_groups.#:                     <computed>
source_dest_check:                     "true"
subnet_id:                             <computed>
tags.%:                                "1"
tags.Name:                             "first-ec2-instance"
tenancy:                               <computed>
volume_tags.%:                         <computed>
vpc_security_group_ids.#:              <computed>
+ aws_key_pair.example
id:                                    <computed>
fingerprint:                           <computed>
key_name:                              "example-key"
public_key:                            "XXX"
+ aws_security_group.examplesg
id:                                    <computed>
arn:                                   <computed>
description:                           "Managed by Terraform"
egress.#:                              <computed>
ingress.#:                             "1"
ingress.2541437006.cidr_blocks.#:      "1"
ingress.2541437006.cidr_blocks.0:      "0.0.0.0/0"
ingress.2541437006.description:        ""
ingress.2541437006.from_port:          "22"
ingress.2541437006.ipv6_cidr_blocks.#: "0"
ingress.2541437006.protocol:           "tcp"
ingress.2541437006.security_groups.#:  "0"
ingress.2541437006.self:               "false"
ingress.2541437006.to_port:            "22"
name:                                  <computed>
owner_id:                              <computed>
revoke_rules_on_delete:                "false"
vpc_id:                                <computed>
Plan: 3 to add, 0 to change, 0 to destroy.
------------------------------------------------------------------------
Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

* To apply these changes, run terraform apply

```sh
$ terraform apply
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
+ create
Terraform will perform the following actions:
+ aws_instance.ec2_instance
id:                                    <computed>
ami:                                   "ami-28e07e50"
associate_public_ip_address:           <computed>
availability_zone:                     <computed>
cpu_core_count:                        <computed>
cpu_threads_per_core:                  <computed>
ebs_block_device.#:                    <computed>
ephemeral_block_device.#:              <computed>
get_password_data:                     "false"
instance_state:                        <computed>
instance_type:                         "t2.micro"
ipv6_address_count:                    <computed>
ipv6_addresses.#:                      <computed>
key_name:                              "${aws_key_pair.example.id}"
network_interface.#:                   <computed>
network_interface_id:                  <computed>
password_data:                         <computed>
placement_group:                       <computed>
primary_network_interface_id:          <computed>
private_dns:                           <computed>
private_ip:                            <computed>
public_dns:                            <computed>
public_ip:                             <computed>
root_block_device.#:                   <computed>
security_groups.#:                     <computed>
source_dest_check:                     "true"
subnet_id:                             <computed>
tags.%:                                "1"
tags.Name:                             "first-ec2-instance"
tenancy:                               <computed>
volume_tags.%:                         <computed>
vpc_security_group_ids.#:              <computed>
+ aws_key_pair.example
id:                                    <computed>
fingerprint:                           <computed>
key_name:                              "example-key"
public_key:                            "XXXX"
+ aws_security_group.examplesg
id:                                    <computed>
arn:                                   <computed>
description:                           "Managed by Terraform"
egress.#:                              <computed>
ingress.#:                             "1"
ingress.2541437006.cidr_blocks.#:      "1"
ingress.2541437006.cidr_blocks.0:      "0.0.0.0/0"
ingress.2541437006.description:        ""
ingress.2541437006.from_port:          "22"
ingress.2541437006.ipv6_cidr_blocks.#: "0"
ingress.2541437006.protocol:           "tcp"
ingress.2541437006.security_groups.#:  "0"
ingress.2541437006.self:               "false"
ingress.2541437006.to_port:            "22"
name:                                  <computed>
owner_id:                              <computed>
revoke_rules_on_delete:                "false"
vpc_id:                                <computed>
Plan: 3 to add, 0 to change, 0 to destroy.
Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.
Enter a value: yes <-----(Make sure to type yes if your satisfied with your changes, note there is no rollback from here)
aws_key_pair.example: Creating...
fingerprint: "" => "<computed>"
key_name:    "" => "example-key"
public_key:  "" => "XXXX"
aws_security_group.examplesg: Creating...
arn:                                   "" => "<computed>"
description:                           "" => "Managed by Terraform"
egress.#:                              "" => "<computed>"
ingress.#:                             "" => "1"
ingress.2541437006.cidr_blocks.#:      "" => "1"
ingress.2541437006.cidr_blocks.0:      "" => "0.0.0.0/0"
ingress.2541437006.description:        "" => ""
ingress.2541437006.from_port:          "" => "22"
ingress.2541437006.ipv6_cidr_blocks.#: "" => "0"
ingress.2541437006.protocol:           "" => "tcp"
ingress.2541437006.security_groups.#:  "" => "0"
ingress.2541437006.self:               "" => "false"
ingress.2541437006.to_port:            "" => "22"
name:                                  "" => "<computed>"
owner_id:                              "" => "<computed>"
revoke_rules_on_delete:                "" => "false"
vpc_id:                                "" => "<computed>"
aws_key_pair.example: Creation complete after 0s (ID: example-key)
aws_security_group.examplesg: Creation complete after 2s (ID: sg-f34d6a83)
aws_instance.ec2_instance: Creating...
ami:                             "" => "ami-28e07e50"
associate_public_ip_address:     "" => "<computed>"
availability_zone:               "" => "<computed>"
cpu_core_count:                  "" => "<computed>"
cpu_threads_per_core:            "" => "<computed>"
ebs_block_device.#:              "" => "<computed>"
ephemeral_block_device.#:        "" => "<computed>"
get_password_data:               "" => "false"
instance_state:                  "" => "<computed>"
instance_type:                   "" => "t2.micro"
ipv6_address_count:              "" => "<computed>"
ipv6_addresses.#:                "" => "<computed>"
key_name:                        "" => "example-key"
network_interface.#:             "" => "<computed>"
network_interface_id:            "" => "<computed>"
password_data:                   "" => "<computed>"
placement_group:                 "" => "<computed>"
primary_network_interface_id:    "" => "<computed>"
private_dns:                     "" => "<computed>"
private_ip:                      "" => "<computed>"
public_dns:                      "" => "<computed>"
public_ip:                       "" => "<computed>"
root_block_device.#:             "" => "<computed>"
security_groups.#:               "" => "<computed>"
source_dest_check:               "" => "true"
subnet_id:                       "" => "<computed>"
tags.%:                          "" => "1"
tags.Name:                       "" => "first-ec2-instance"
tenancy:                         "" => "<computed>"
volume_tags.%:                   "" => "<computed>"
vpc_security_group_ids.#:        "" => "1"
vpc_security_group_ids.76457633: "" => "sg-f34d6a83"
aws_instance.ec2_instance: Still creating... (10s elapsed)
aws_instance.ec2_instance: Still creating... (20s elapsed)
aws_instance.ec2_instance: Still creating... (30s elapsed)
aws_instance.ec2_instance: Still creating... (40s elapsed)
aws_instance.ec2_instance: Still creating... (50s elapsed)
aws_instance.ec2_instance: Still creating... (1m0s elapsed)
aws_instance.ec2_instance: Still creating... (1m10s elapsed)
aws_instance.ec2_instance: Creation complete after 1m15s (ID: i-0f0cd1c7d727ef8fb)
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

What terraform is doing here is reading code and translating it to api calls to providers(aws in this case)
W00t you have deployed your first EC2 server using terraform

* Go back to the EC2 console to verify your first deployed server


* Let say after verification you realize that I need to give more meaningful tag to this server, so the rest of the code remain the same and you modified the tag parameter

```sh
tags {
  Name = "first-webserver"
}
```

* Run terraform plan command again, as you can see
tags.Name: “first-ec2-instance” => “first-webserver”

```sh
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
aws_key_pair.example: Refreshing state... (ID: example-key)
aws_security_group.examplesg: Refreshing state... (ID: sg-f34d6a83)
aws_instance.ec2_instance: Refreshing state... (ID: i-0f0cd1c7d727ef8fb)
------------------------------------------------------------------------
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
~ update in-place
Terraform will perform the following actions:
~ aws_instance.ec2_instance
tags.Name: "first-ec2-instance" => "first-webserver"
Plan: 0 to add, 1 to change, 0 to destroy.
------------------------------------------------------------------------
Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
Now if we can think about it, how does terraform knows that there only change in the tag parameter and nothing else
Terraform keep track of all the resources it already created in .tfstate files, so its already aware of the resources that already exist
$ ls -la
total 40
drwxr-xr-x     7 plakhera  wheel    224 Jul 28 11:25 .
drwx------+ 1349 plakhera  wheel  43168 Jul 28 09:37 ..
drwxr-xr-x     6 plakhera  wheel    192 Jul 28 11:24 .idea
drwxr-xr-x     3 plakhera  wheel     96 Jul 28 10:45 .terraform
-rw-r--r--     1 plakhera  wheel    983 Jul 28 11:24 main.tf
-rw-r--r--     1 plakhera  wheel   7228 Jul 28 11:23 terraform.tfstate
-rw-r--r--     1 plakhera  wheel   7134 Jul 28 11:23 terraform.tfstate.backup
If you notice at the top it says “Refreshing Terraform state in-memory prior to plan…”
If I refresh my webbrowser after running terraform apply
$ terraform apply
aws_key_pair.example: Refreshing state... (ID: example-key)
aws_security_group.examplesg: Refreshing state... (ID: sg-f34d6a83)
aws_instance.ec2_instance: Refreshing state... (ID: i-0f0cd1c7d727ef8fb)
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
~ update in-place
Terraform will perform the following actions:
~ aws_instance.ec2_instance
tags.Name: "first-ec2-instance" => "first-webserver"
Plan: 0 to add, 1 to change, 0 to destroy.
Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.
Enter a value: yes
aws_instance.ec2_instance: Modifying... (ID: i-0f0cd1c7d727ef8fb)
tags.Name: "first-ec2-instance" => "first-webserver"
aws_instance.ec2_instance: Modifications complete after 3s (ID: i-0f0cd1c7d727ef8fb)
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

* In most of the cases we are working in team where we want to share this code with rest of team members and the best way to share code is by using GIT
    * git add main.tf
    * git commit -m "first terraform EC2 instance"
    * vim .gitignore
    * git add .gitignore
    * git commit -m "Adding gitignore file for terraform repository"

* Via .gitignore we are telling terraform to ignore(.terraform folder(temporary directory for terraform)and all *.tfstates file(as this file may contain secrets))
    * $ cat .gitignore
    * .terraform
    * *.tfstate
    * *.tfstate.backup

* Create a shared git repository
```sh
git remote add origin https://github.com/<user name>/terraform.git
```
###### NOTE: Git did not support https on terminal anymore, you expected to use ssh
* Push the code
```sh
$ git push -u origin master
```

* To Perform cleanup whatever we have created so far, run terraform destroy

```sh
$ terraform destroy
aws_security_group.examplesg: Refreshing state... (ID: sg-154d6a65)
aws_key_pair.example: Refreshing state... (ID: example-key)
aws_instance.ec2_instance: Refreshing state... (ID: i-06d3d45b6102ecc3f)
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
- destroy
Terraform will perform the following actions:
- aws_instance.ec2_instance
- aws_key_pair.example
- aws_security_group.examplesg
Plan: 0 to add, 0 to change, 3 to destroy.
Do you really want to destroy?
Terraform will destroy all your managed infrastructure, as shown above.
There is no undo. Only 'yes' will be accepted to confirm.
Enter a value: yes
aws_instance.ec2_instance: Destroying... (ID: i-06d3d45b6102ecc3f)
aws_instance.ec2_instance: Still destroying... (ID: i-06d3d45b6102ecc3f, 10s elapsed)
aws_instance.ec2_instance: Still destroying... (ID: i-06d3d45b6102ecc3f, 20s elapsed)
aws_instance.ec2_instance: Still destroying... (ID: i-06d3d45b6102ecc3f, 30s elapsed)
aws_instance.ec2_instance: Still destroying... (ID: i-06d3d45b6102ecc3f, 40s elapsed)
aws_instance.ec2_instance: Still destroying... (ID: i-06d3d45b6102ecc3f, 50s elapsed)
aws_instance.ec2_instance: Destruction complete after 52s
aws_key_pair.example: Destroying... (ID: example-key)
aws_security_group.examplesg: Destroying... (ID: sg-154d6a65)
aws_key_pair.example: Destruction complete after 0s
aws_security_group.examplesg: Destruction complete after 0s
Destroy complete! Resources: 3 destroyed.
```


