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

Then, run the following command

```sh
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
```

