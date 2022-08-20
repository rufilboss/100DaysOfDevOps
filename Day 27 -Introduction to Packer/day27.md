###### What is Packer?

* Packer is easy to use and automates the creation of any type of machine image.

    * It integrates natively with a bunch of configuration management systems eg: Ansible, Puppet.
    * Packer is cross-platform(Linux/Window)
    * Packer uses a JSON template file and lets you define immutable infrastructure.
    * It’s written in the GO language.

###### Packer Template

* Divided into three parts and each of them is a json array so you can have as many as you want in each section.
Builders

* Use to generate an image and it’s provider-specific. For e.g. if you are creating an image for AWS your builder will tell the packer which AMI to start with and what region to create that AMI.
