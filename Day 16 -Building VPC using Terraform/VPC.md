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

```sh
# Ingress Security Port 22
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.test_sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.test_sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
```

* This is how our variables file look like

```sh
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_cidrs" {
  type = "list"
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_cidrs" {
  type = "list"
  default = ["10.0.3.0/24","10.0.4.0/24"]
}
```

* Now let’s test it
* Initialize a Terraform working directory

```sh
$ terraform init

Initializing modules...

- module.vpc_networking

Getting source "./networking"

Initializing provider plugins...

- Checking for available provider plugins on https://releases.hashicorp.com...

- Downloading plugin for provider "aws" (1.51.0)...

The following providers do not have any version constraints in configuration,

so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking

changes, it is recommended to add version = "..." constraints to the

corresponding provider blocks in configuration, with the constraint strings

suggested below.

* provider.aws: version = "~> 1.51"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see

any changes that are required for your infrastructure. All Terraform commands

should now work.

If you ever set or change modules or backend configuration for Terraform,

rerun this command to reinitialize your working directory. If you forget, other

commands will detect it and remind you to do so if necessary.
```

* Execute terraform plan
* Generate and show an execution plan

```sh

$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_availability_zones.available: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + module.vpc_networking.aws_default_route_table.private_route
      id:                                         <computed>
      default_route_table_id:                     "${aws_vpc.main.default_route_table_id}"
      owner_id:                                   <computed>
      route.#:                                    <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-private-route-table"
      vpc_id:                                     <computed>

  + module.vpc_networking.aws_internet_gateway.gw
      id:                                         <computed>
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-igw"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_route_table.public_route
      id:                                         <computed>
      owner_id:                                   <computed>
      propagating_vgws.#:                         <computed>
      route.#:                                    "1"
      route.~966145399.cidr_block:                "0.0.0.0/0"
      route.~966145399.egress_only_gateway_id:    ""
      route.~966145399.gateway_id:                "${aws_internet_gateway.gw.id}"
      route.~966145399.instance_id:               ""
      route.~966145399.ipv6_cidr_block:           ""
      route.~966145399.nat_gateway_id:            ""
      route.~966145399.network_interface_id:      ""
      route.~966145399.transit_gateway_id:        ""
      route.~966145399.vpc_peering_connection_id: ""
      tags.%:                                     "1"
      tags.Name:                                  "my-test-public-route"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_route_table_association.private_subnet_assoc[0]
      id:                                         <computed>
      route_table_id:                             "${aws_default_route_table.private_route.id}"
      subnet_id:                                  "${aws_subnet.private_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_route_table_association.private_subnet_assoc[1]
      id:                                         <computed>
      route_table_id:                             "${aws_default_route_table.private_route.id}"
      subnet_id:                                  "${aws_subnet.private_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_route_table_association.public_subnet_assoc[0]
      id:                                         <computed>
      route_table_id:                             "${aws_route_table.public_route.id}"
      subnet_id:                                  "${aws_subnet.public_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_route_table_association.public_subnet_assoc[1]
      id:                                         <computed>
      route_table_id:                             "${aws_route_table.public_route.id}"
      subnet_id:                                  "${aws_subnet.public_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_security_group.test_sg
      id:                                         <computed>
      arn:                                        <computed>
      description:                                "Managed by Terraform"
      egress.#:                                   <computed>
      ingress.#:                                  <computed>
      name:                                       "my-test-sg"
      owner_id:                                   <computed>
      revoke_rules_on_delete:                     "false"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_security_group_rule.all_outbound_access
      id:                                         <computed>
      from_port:                                  "0"
      protocol:                                   "-1"
      security_group_id:                          "${aws_security_group.test_sg.id}"
      self:                                       "false"
      source_security_group_id:                   <computed>
      to_port:                                    "0"
      type:                                       "egress"

  + module.vpc_networking.aws_security_group_rule.ssh_inbound_access
      id:                                         <computed>
      from_port:                                  "22"
      protocol:                                   "tcp"
      security_group_id:                          "${aws_security_group.test_sg.id}"
      self:                                       "false"
      source_security_group_id:                   <computed>
      to_port:                                    "22"
      type:                                       "ingress"

  + module.vpc_networking.aws_subnet.private_subnet[0]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2a"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.3.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "false"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-private-subnet.1"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_subnet.private_subnet[1]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2b"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.4.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "false"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-private-subnet.2"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_subnet.public_subnet[0]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2a"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.1.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "true"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-public-subnet.1"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_subnet.public_subnet[1]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2b"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.2.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "true"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-public-subnet.2"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_vpc.main
      id:                                         <computed>
      arn:                                        <computed>
      assign_generated_ipv6_cidr_block:           "false"
      cidr_block:                                 "10.0.0.0/16"
      default_network_acl_id:                     <computed>
      default_route_table_id:                     <computed>
      default_security_group_id:                  <computed>
      dhcp_options_id:                            <computed>
      enable_classiclink:                         <computed>
      enable_classiclink_dns_support:             <computed>
      enable_dns_hostnames:                       "true"
      enable_dns_support:                         "true"
      instance_tenancy:                           "default"
      ipv6_association_id:                        <computed>
      ipv6_cidr_block:                            <computed>
      main_route_table_id:                        <computed>
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-vpc"


Plan: 15 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

* Final step terraform apply’
* Builds or changes the infrastructure
```sh
$ terraform apply
data.aws_availability_zones.available: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + module.vpc_networking.aws_default_route_table.private_route
      id:                                         <computed>
      default_route_table_id:                     "${aws_vpc.main.default_route_table_id}"
      owner_id:                                   <computed>
      route.#:                                    <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-private-route-table"
      vpc_id:                                     <computed>

  + module.vpc_networking.aws_internet_gateway.gw
      id:                                         <computed>
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-igw"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_route_table.public_route
      id:                                         <computed>
      owner_id:                                   <computed>
      propagating_vgws.#:                         <computed>
      route.#:                                    "1"
      route.~966145399.cidr_block:                "0.0.0.0/0"
      route.~966145399.egress_only_gateway_id:    ""
      route.~966145399.gateway_id:                "${aws_internet_gateway.gw.id}"
      route.~966145399.instance_id:               ""
      route.~966145399.ipv6_cidr_block:           ""
      route.~966145399.nat_gateway_id:            ""
      route.~966145399.network_interface_id:      ""
      route.~966145399.transit_gateway_id:        ""
      route.~966145399.vpc_peering_connection_id: ""
      tags.%:                                     "1"
      tags.Name:                                  "my-test-public-route"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_route_table_association.private_subnet_assoc[0]
      id:                                         <computed>
      route_table_id:                             "${aws_default_route_table.private_route.id}"
      subnet_id:                                  "${aws_subnet.private_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_route_table_association.private_subnet_assoc[1]
      id:                                         <computed>
      route_table_id:                             "${aws_default_route_table.private_route.id}"
      subnet_id:                                  "${aws_subnet.private_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_route_table_association.public_subnet_assoc[0]
      id:                                         <computed>
      route_table_id:                             "${aws_route_table.public_route.id}"
      subnet_id:                                  "${aws_subnet.public_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_route_table_association.public_subnet_assoc[1]
      id:                                         <computed>
      route_table_id:                             "${aws_route_table.public_route.id}"
      subnet_id:                                  "${aws_subnet.public_subnet.*.id[count.index]}"

  + module.vpc_networking.aws_security_group.test_sg
      id:                                         <computed>
      arn:                                        <computed>
      description:                                "Managed by Terraform"
      egress.#:                                   <computed>
      ingress.#:                                  <computed>
      name:                                       "my-test-sg"
      owner_id:                                   <computed>
      revoke_rules_on_delete:                     "false"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_security_group_rule.all_outbound_access
      id:                                         <computed>
      cidr_blocks.#:                              "1"
      cidr_blocks.0:                              "0.0.0.0/0"
      from_port:                                  "0"
      protocol:                                   "-1"
      security_group_id:                          "${aws_security_group.test_sg.id}"
      self:                                       "false"
      source_security_group_id:                   <computed>
      to_port:                                    "0"
      type:                                       "egress"

  + module.vpc_networking.aws_security_group_rule.ssh_inbound_access
      id:                                         <computed>
      cidr_blocks.#:                              "1"
      cidr_blocks.0:                              "0.0.0.0/0"
      from_port:                                  "22"
      protocol:                                   "tcp"
      security_group_id:                          "${aws_security_group.test_sg.id}"
      self:                                       "false"
      source_security_group_id:                   <computed>
      to_port:                                    "22"
      type:                                       "ingress"

  + module.vpc_networking.aws_subnet.private_subnet[0]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2a"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.3.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "false"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-private-subnet.1"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_subnet.private_subnet[1]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2b"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.4.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "false"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-private-subnet.2"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_subnet.public_subnet[0]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2a"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.1.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "true"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-public-subnet.1"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_subnet.public_subnet[1]
      id:                                         <computed>
      arn:                                        <computed>
      assign_ipv6_address_on_creation:            "false"
      availability_zone:                          "us-west-2b"
      availability_zone_id:                       <computed>
      cidr_block:                                 "10.0.2.0/24"
      ipv6_cidr_block:                            <computed>
      ipv6_cidr_block_association_id:             <computed>
      map_public_ip_on_launch:                    "true"
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-public-subnet.2"
      vpc_id:                                     "${aws_vpc.main.id}"

  + module.vpc_networking.aws_vpc.main
      id:                                         <computed>
      arn:                                        <computed>
      assign_generated_ipv6_cidr_block:           "false"
      cidr_block:                                 "10.0.0.0/16"
      default_network_acl_id:                     <computed>
      default_route_table_id:                     <computed>
      default_security_group_id:                  <computed>
      dhcp_options_id:                            <computed>
      enable_classiclink:                         <computed>
      enable_classiclink_dns_support:             <computed>
      enable_dns_hostnames:                       "true"
      enable_dns_support:                         "true"
      instance_tenancy:                           "default"
      ipv6_association_id:                        <computed>
      ipv6_cidr_block:                            <computed>
      main_route_table_id:                        <computed>
      owner_id:                                   <computed>
      tags.%:                                     "1"
      tags.Name:                                  "my-test-vpc"


Plan: 15 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.vpc_networking.aws_vpc.main: Creating...
  arn:                              "" => "<computed>"
  assign_generated_ipv6_cidr_block: "" => "false"
  cidr_block:                       "" => "10.0.0.0/16"
  default_network_acl_id:           "" => "<computed>"
  default_route_table_id:           "" => "<computed>"
  default_security_group_id:        "" => "<computed>"
  dhcp_options_id:                  "" => "<computed>"
  enable_classiclink:               "" => "<computed>"
  enable_classiclink_dns_support:   "" => "<computed>"
  enable_dns_hostnames:             "" => "true"
  enable_dns_support:               "" => "true"
  instance_tenancy:                 "" => "default"
  ipv6_association_id:              "" => "<computed>"
  ipv6_cidr_block:                  "" => "<computed>"
  main_route_table_id:              "" => "<computed>"
  owner_id:                         "" => "<computed>"
  tags.%:                           "" => "1"
  tags.Name:                        "" => "my-test-vpc"
module.vpc_networking.aws_vpc.main: Creation complete after 3s (ID: vpc-04ab0547e37f673e4)
module.vpc_networking.aws_internet_gateway.gw: Creating...
  owner_id:  "" => "<computed>"
  tags.%:    "0" => "1"
  tags.Name: "" => "my-test-igw"
  vpc_id:    "" => "vpc-04ab0547e37f673e4"
module.vpc_networking.aws_security_group.test_sg: Creating...
  arn:                    "" => "<computed>"
  description:            "" => "Managed by Terraform"
  egress.#:               "" => "<computed>"
  ingress.#:              "" => "<computed>"
  name:                   "" => "my-test-sg"
  owner_id:               "" => "<computed>"
  revoke_rules_on_delete: "" => "false"
  vpc_id:                 "" => "vpc-04ab0547e37f673e4"
module.vpc_networking.aws_default_route_table.private_route: Creating...
  default_route_table_id: "" => "rtb-0c580b031e83f41f8"
  owner_id:               "" => "<computed>"
  route.#:                "" => "<computed>"
  tags.%:                 "" => "1"
  tags.Name:              "" => "my-private-route-table"
  vpc_id:                 "" => "<computed>"
module.vpc_networking.aws_subnet.public_subnet[0]: Creating...
  arn:                             "" => "<computed>"
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "us-west-2a"
  availability_zone_id:            "" => "<computed>"
  cidr_block:                      "" => "10.0.1.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "true"
  owner_id:                        "" => "<computed>"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "my-test-public-subnet.1"
  vpc_id:                          "" => "vpc-04ab0547e37f673e4"
module.vpc_networking.aws_subnet.public_subnet[1]: Creating...
  arn:                             "" => "<computed>"
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "us-west-2b"
  availability_zone_id:            "" => "<computed>"
  cidr_block:                      "" => "10.0.2.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "true"
  owner_id:                        "" => "<computed>"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "my-test-public-subnet.2"
  vpc_id:                          "" => "vpc-04ab0547e37f673e4"
module.vpc_networking.aws_subnet.private_subnet[1]: Creating...
  arn:                             "" => "<computed>"
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "us-west-2b"
  availability_zone_id:            "" => "<computed>"
  cidr_block:                      "" => "10.0.4.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "false"
  owner_id:                        "" => "<computed>"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "my-test-private-subnet.2"
  vpc_id:                          "" => "vpc-04ab0547e37f673e4"
module.vpc_networking.aws_subnet.private_subnet[0]: Creating...
  arn:                             "" => "<computed>"
  assign_ipv6_address_on_creation: "" => "false"
  availability_zone:               "" => "us-west-2a"
  availability_zone_id:            "" => "<computed>"
  cidr_block:                      "" => "10.0.3.0/24"
  ipv6_cidr_block:                 "" => "<computed>"
  ipv6_cidr_block_association_id:  "" => "<computed>"
  map_public_ip_on_launch:         "" => "false"
  owner_id:                        "" => "<computed>"
  tags.%:                          "" => "1"
  tags.Name:                       "" => "my-test-private-subnet.1"
  vpc_id:                          "" => "vpc-04ab0547e37f673e4"
module.vpc_networking.aws_default_route_table.private_route: Creation complete after 1s (ID: rtb-0c580b031e83f41f8)
module.vpc_networking.aws_subnet.private_subnet[0]: Creation complete after 2s (ID: subnet-0664f3f0f932f3a51)
module.vpc_networking.aws_internet_gateway.gw: Creation complete after 2s (ID: igw-0dde53f826b2a657a)
module.vpc_networking.aws_route_table.public_route: Creating...
  owner_id:                                   "" => "<computed>"
  propagating_vgws.#:                         "" => "<computed>"
  route.#:                                    "" => "1"
  route.2452036034.cidr_block:                "" => "0.0.0.0/0"
  route.2452036034.egress_only_gateway_id:    "" => ""
  route.2452036034.gateway_id:                "" => "igw-0dde53f826b2a657a"
  route.2452036034.instance_id:               "" => ""
  route.2452036034.ipv6_cidr_block:           "" => ""
  route.2452036034.nat_gateway_id:            "" => ""
  route.2452036034.network_interface_id:      "" => ""
  route.2452036034.transit_gateway_id:        "" => ""
  route.2452036034.vpc_peering_connection_id: "" => ""
  tags.%:                                     "" => "1"
  tags.Name:                                  "" => "my-test-public-route"
  vpc_id:                                     "" => "vpc-04ab0547e37f673e4"
module.vpc_networking.aws_subnet.private_subnet[1]: Creation complete after 2s (ID: subnet-0de1fc262257c18b6)
module.vpc_networking.aws_route_table_association.private_subnet_assoc[0]: Creating...
  route_table_id: "" => "rtb-0c580b031e83f41f8"
  subnet_id:      "" => "subnet-0664f3f0f932f3a51"
module.vpc_networking.aws_route_table_association.private_subnet_assoc[1]: Creating...
  route_table_id: "" => "rtb-0c580b031e83f41f8"
  subnet_id:      "" => "subnet-0de1fc262257c18b6"
module.vpc_networking.aws_subnet.public_subnet[0]: Creation complete after 2s (ID: subnet-076a2f00f82e133e3)
module.vpc_networking.aws_subnet.public_subnet[1]: Creation complete after 2s (ID: subnet-01e4441c4d1d295b4)
module.vpc_networking.aws_security_group.test_sg: Creation complete after 2s (ID: sg-0eacdfa929e01f14e)
module.vpc_networking.aws_security_group_rule.all_outbound_access: Creating...
  cidr_blocks.#:            "" => "1"
  cidr_blocks.0:            "" => "0.0.0.0/0"
  from_port:                "" => "0"
  protocol:                 "" => "-1"
  security_group_id:        "" => "sg-0eacdfa929e01f14e"
  self:                     "" => "false"
  source_security_group_id: "" => "<computed>"
  to_port:                  "" => "0"
  type:                     "" => "egress"
module.vpc_networking.aws_security_group_rule.ssh_inbound_access: Creating...
  cidr_blocks.#:            "" => "1"
  cidr_blocks.0:            "" => "0.0.0.0/0"
  from_port:                "" => "22"
  protocol:                 "" => "tcp"
  security_group_id:        "" => "sg-0eacdfa929e01f14e"
  self:                     "" => "false"
  source_security_group_id: "" => "<computed>"
  to_port:                  "" => "22"
  type:                     "" => "ingress"
module.vpc_networking.aws_route_table_association.private_subnet_assoc[0]: Creation complete after 0s (ID: rtbassoc-08ac2368c39c4bba6)
module.vpc_networking.aws_route_table_association.private_subnet_assoc[1]: Creation complete after 0s (ID: rtbassoc-073ea97c89243f9a2)
module.vpc_networking.aws_security_group_rule.all_outbound_access: Creation complete after 1s (ID: sgrule-2840718346)
module.vpc_networking.aws_route_table.public_route: Creation complete after 1s (ID: rtb-0717178625788ad5a)
module.vpc_networking.aws_route_table_association.public_subnet_assoc[1]: Creating...
  route_table_id: "" => "rtb-0717178625788ad5a"
  subnet_id:      "" => "subnet-01e4441c4d1d295b4"
module.vpc_networking.aws_route_table_association.public_subnet_assoc[0]: Creating...
  route_table_id: "" => "rtb-0717178625788ad5a"
  subnet_id:      "" => "subnet-076a2f00f82e133e3"
module.vpc_networking.aws_route_table_association.public_subnet_assoc[0]: Creation complete after 0s (ID: rtbassoc-022283ab63796686e)
module.vpc_networking.aws_route_table_association.public_subnet_assoc[1]: Creation complete after 0s (ID: rtbassoc-0d0916273682d156d)
module.vpc_networking.aws_security_group_rule.ssh_inbound_access: Creation complete after 1s (ID: sgrule-2725048208)

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.
```

###### You can think of Terraform Module like any other language module eg: Python, it’s the same terraform file but just that after creating a module out it we can re-use that code OR Instead copy-pasting the code the same code in different places we can turn into reusable modules.

#### NOTE: Please ignore the terraform.tfstate.* files

* The syntax for the module

```sh
module "NAME" {
  source = "SOURCE"

  [CONFIG ...]
}
```
