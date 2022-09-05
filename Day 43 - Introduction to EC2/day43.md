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

* Another way to check is via lscpu command

```sh
# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                36
On-line CPU(s) list:   0-35
Thread(s) per core:    1
Core(s) per socket:    18
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 63
Model name:            Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz
Stepping:              2
CPU MHz:               2297.377
BogoMIPS:              4594.20
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              46080K
NUMA node0 CPU(s):     0-8,18-26
NUMA node1 CPU(s):     9-17,27-35
```

* Paravirtual Machine(PVM): In case if your hardware doesn’t support virtualization(verified under /proc/cpuinfo and lscpu) we can use PV AMI. In the past PV guests had better performance than HVM but because of enhancement in HVM Virtualization and the availability of PV drivers in HVM AMI this is no longer true.

###### NOTE: Nowadays most of Amazon AMI is HVM based

* Instance Type: Instance types comprise varying combinations of CPU, memory, storage, and networking capacity and give us the flexibility to choose the appropriate mix of resources for your applications
* Storage: Generally comes with two options

* Elastic Block Storage(EBS): Provide Persistent Storage and they are network attached storage.
    * They can only be attached to one EC2 instance at a time
    * The Main benefit is they can be backed up into a snapshot, which we can use later to restore into a new EBS volume.
