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

* Post-Processors

    * Let’s integrate with other services like Docker. For e.g. it will let you upload an image to dockerhub.

```sh
#post-procesor.json

{
  "post-processors": [
    [
      "compress",
      { "type": "upload", "endpoint": "http://example.com" }
    ]
  ]
}

```

* Learnt how to install packer

* Let's create a Basic Packer Template

```sh
{
"builders": [
{
    "type": "amazon-ebs",
    "region": "us-west-2",
    "source_ami": "ami-0721c9af7b9b75114",
    "instance_type": "t2.micro",
    "ssh_username": "ec2-user",
    "ami_name": "amazon-linux-packer-ami-1.0"
}
]
}
* type: Each Builder has a mandatory type field, as we are building this image on AWS we are going to use amazon-ebs type filed
* region: Where we want to build this image, as AMI ID differ based on region
* source_ami: This is image going to be launched on AWS and our image is based on this(In this example I am using AWS AMI)
* instance_type: I am using t2.micro as it comes under AWS free tier
* ssh_username: We need to tell packer which ssh username to utilize, as we are using AWS AMI, username is ec2-user
* ami_name: Now we need to tell packer AMI it need to create
```

