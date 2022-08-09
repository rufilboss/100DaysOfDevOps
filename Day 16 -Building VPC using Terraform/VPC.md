##### What is VPC?

Without going to all the nitty-gritty details of VPC, first, let’s try to understand VPC in the simplest term. Before the cloud era, we use to have datacenters where we deploy all of our infrastructures. You can think of VPC as your datacentre in a cloud but rather than spending months or weeks to set up that datacenter it’s now just a matter of minutes(API calls). It’s the place where you define your network which closely resembles your own traditional data centers with the benefits of using the scalable infrastructure provided by AWS.

* Today we are going to build the first half of the equation i.e VPC
* Once we create the VPC using AWS Console, these things created for us by-default
    * Network Access Control List(NACL)
    * Security Group
    * Route Table
* We need to take care of
    * Internet Gateways
    * Subnets
    * Custom Route Table

But the bad news is as we are creating this via terraform we need to create all these things manually but this is just one time task, later on, if we need to build one more VPC we just need to call this module with some minor changes(eg: Changes in CIDR Range, Subnet) true Infrastructure as a Code(IAAC)

This is how my terraform VPC module structure look like
```sh
$ tree
├── main.tf
├── vpc_networking
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── outputs.tf
├── terraform.tfvars
└── variables.tf
```
* So the first step is to create a data resource, what data resource did is to query/list all the AWS available Availablity zone in a given region and then allow terraform to use those resource.

* NOw it's time  to create VPC
```sh
# VPC Creation
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "my-test-vpc"
  }
}
```