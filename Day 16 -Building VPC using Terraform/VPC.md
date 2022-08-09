#### What is VPC?

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

* Now it's time  to create VPC
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

* enable_dns_support - (Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults true. Amazon provided DNS server(AmazonProvidedDNS) can resolve Amazon provided private DNS hostnames, that we specify in a private hosted zones in Route53.
* enable_dns_hostnames - (Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false. This will ensure that instances that are launched into our VPC receive a DNS hostname.

* Next step is to create an internet gateway
    * Internet gateway is a horizontally scaled, redundant and highly avilable VPC component.
    * Internet gateway serves one more purpose, it performs NAT for instances that have been assigned public IPv4 addresses.

```sh
# Creating Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "my-test-igw"
  }
}
```

* Next step is to create Public Route Table
* Route Table: Contains a set of rules, called routes, that are used to determine where network traffic is directed.

```sh
# Public Route Table

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "my-test-public-route"
  }
}
```

* Now it’s time to create Private Route Table. If the subnet is not associated with any route by default it will be associated with Private Route table

```sh
# Private Route Table

resource "aws_default_route_table" "private_route" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags {
    Name = "my-private-route-table"
  }
}
```

* Next step is to create Public Subnet
```sh
# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = 2
  cidr_block              = "${var.public_cidrs[count.index]}"
  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "my-test-public-subnet.${count.index + 1}"
  }
}
```

* Private Subnet
```sh

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = 2
  cidr_block        = "${var.private_cidrs[count.index]}"
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "my-test-private-subnet.${count.index + 1}"
  }
}
```

* Next step is to create a route table association

```sh
# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = "${aws_subnet.public_subnet.count}"
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  depends_on     = ["aws_route_table.public_route", "aws_subnet.public_subnet"]
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = "${aws_subnet.private_subnet.count}"
  route_table_id = "${aws_default_route_table.private_route.id}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  depends_on     = ["aws_default_route_table.private_route", "aws_subnet.private_subnet"]
}
```

* Network Access Control List(NACL) A network access control list (ACL) is an optional layer of security for your VPC that acts as a firewall for controlling traffic in and out of one or more subnets.
* Security Group acts as a virtual firewall and is used to control the traffic for its associated instances.
* Difference between NACL and Security Group

![diff](https://miro.medium.com/max/1400/1*JuCWpsP4XRgACDHu3XU5Fw.png)