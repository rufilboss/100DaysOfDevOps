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

* It’s is very important to choose an instance depending upon the I/O that application is going to perform whether it’s going to perform small or higher Input/Output(I/O) read/write.

* That why in some case even with provisioned IOPS we will get the same performance and in those cases, we need to choose EBS optimized instance which prioritizes EBS traffic(Figure below shows some EBS Optimized instances)

###### NOTE: AWS measure IOPS in 256KB chunks(so 768KB is equivalent to 3 IOPS)

* Types of EBS Volumes

    * General Purpose SSD
    * Provisioned IOPS
    * Magnetic

![XampleImage](https://miro.medium.com/max/1400/1*06j6Lo0XA4gj0AV2eXWbbQ.png)

* Ephemeral Storage: These are physically attached to the host computer that is running the instance. Data on the volume only exists for the duration of the life of the instance

    * Stopped/Shutdown: Data erased
    * Rebooted: Data remained

###### Buying Options in EC2 Cloud

* On the right-hand side of the EC2 dashboard, you will see the different AWS Instances

* On-Demand: As the name suggests we can provision/terminate instance any time(on-demand).
    * The most important aspect is billed by the hour(when the instance is running)
    * Most expensive purchasing option but the most flexible one
* Reserved: Allow us to purchase an instance for a set time period(1 to 3 year)
    * Less expensive as compare to on-demand but once purchased we are completely responsible for the entire price regardless of how often we use
    * Comes with different pay options(upfront,partial-upfront,no upfront)
* Spot: We can even bid for an instance and we can only pay when the spot price is equal to or below our bid price
    * Generally used in the non-production scenario as the instance will be automatically terminate when the spot price is equal to or less than our bid
    * It allows Amazon to sell the unused instance for a short amount of time at a substantial discount prize

* Elastic IP Address(EIP): It’s a public IPv4 address designed for dynamic cloud mapping. We can attach our instance to EIP that was created only with a private IP address. The advantage of EIP that in the case of any instance failure we can detach it and attach it to the new instance.

* User-Data: Using user-data we can add our own custom script during EC2 instance creation.

* Now to view User-data and Instance Meta-Data use

    ```sh
    # curl http://169.254.169.254/latest/meta-data/
    # curl http://169.254.169.254/latest/user-data/
    ```

* For eg:

```sh
# curl http://169.254.169.254/latest/meta-data/
ami-id
ami-launch-index
ami-manifest-path
block-device-mapping/
hostname
instance-action
instance-id
instance-type
local-hostname
local-ipv4
mac
metrics/
network/
placement/
profile
public-hostname
public-ipv4
public-keys/
reservation-id
security-groups
#To get specific information(eg:ami)
# curl http://169.254.169.254/latest/meta-data//ami-id
ami-6f68cf0f
```
###### EC2 Key Pairs

* EC2 key pair has two parts

    * Public Key: AWS store the public key
    * Private Key: As an administrator, we are responsible for Private Key(it’s available in the form of pem key and make sure permission must be set to 400)

* We use this keypair to login to an instance(Linux) via ssh

    ```sh
    ssh -i <keypair.pem> ec2-user@aws-hostname
    ```

* At the time of instance creation, it will ask you

    * Choose an existing key pair
    * Create a new key pair

###### EBS Snapshots

* Snapshots are point-in-time backups of EBS volumes that are stored in S3 and incremental in nature.

    * It only stores the change since the most recent backup and thus helps us to reduce cost
    * Using snapshot we can restore the EBS volumes and even in cases where the original snapshot is deleted data is still available in all the other snapshots
    * While taking a snapshot it degrades the performance of EBS volumes, so it should be taken during the non-peak hour

* To create a snapshot, just click on the left bar of EC2 console
* Now as mentioned above we can use these snapshot to restore EBS volumes. As you can see we can in the pic below(just right-click on that snapshot)

    * Create Volume
    * Create Image
    * Modify Permission

