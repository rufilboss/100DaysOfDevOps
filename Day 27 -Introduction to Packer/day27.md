###### What is Packer?

* Packer is easy to use and automates the creation of any type of machine image.

    * It integrates natively with a bunch of configuration management systems eg: Ansible, Puppet.
    * Packer is cross-platform(Linux/Window)
    * Packer uses a JSON template file and lets you define immutable infrastructure.
    * It’s written in the GO language.

* Packer Template

    * Divided into three parts and each of them is a json array so you can have as many as you want in each section.

* Builders

    * Use to generate an image and it’s provider-specific. For e.g. if you are creating an image for AWS your builder will tell the packer which AMI to start with and what region to create that AMI.

```sh
#packer_builder.json

  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "us-east-1",
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu",
    "ami_name": "packer-example {{timestamp}}"
  }]

```

* Provisioners

    * It let you customize your images
    * These can be scripts(bash or PowerShell)or your existing configuration management system(eg: chef, puppet, salt stack, and Ansible) or files where can upload a file to the running instance for capturing things eg: config files, binaries, etc.

```sh
#packer_provision.json
    "provisioners": [
        {
            "type": "shell",
            "script": "./example.sh"
        }
    ]

```

