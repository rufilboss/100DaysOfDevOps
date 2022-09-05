##### Elastic Compute Cloud(EC2) is the virtual server in the AWS cloud.

* EC2 virtual server also referred to as an instance and EC2 comes with different instance type [**here**](https://aws.amazon.com/ec2/instance-types)
* It’s important to choose the correct instance type so that it will handle your application load properly.
* Linux/Windows are commonly run a flavor of Operating System

###### Some Key Terms

* Amazon Machine Image(AMI)

    We can think of it as an operating system or preconfigured package(template) require to launch an EC2 instance

* AMI has two virtualization type

    * Hardware Virtual Machine(HVM): Under this OS runs directly on top of Virtual Machine without any modification, it’s similar to running on the bare metal. It also takes advantage of hardware extension that provides fast access to the underlying hardware on the host system.


* To find out If CPU Support Intel VT or AMD-V Virtualization Support

    secure virtual machine(svm) for AMD
    virtual machine extension(vmx) for Intel CPU

```sh
$ egrep -i — color “svm|vmx” /proc/cpuinfo
```
