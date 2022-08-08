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