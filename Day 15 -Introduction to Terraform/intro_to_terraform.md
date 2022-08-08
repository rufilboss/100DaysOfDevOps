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

* This is required as we need to make changes to AWS account