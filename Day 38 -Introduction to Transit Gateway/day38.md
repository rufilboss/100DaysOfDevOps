* What is Transit Gateway?

    * AWS Transit Gateway is a service that enables customers to connect their Amazon Virtual Private Clouds (VPCs) and their on-premises networks to a single gateway

* Features of Transit Gateway

    * Connect thousands of Amazon Virtual Private Clouds (VPCs) and on-premises networks using a single gateway
    * Hub and Spoke Network Topology
    * Scales up to 5000 VPCs
    * Spread traffic over many VPN connections (Scale horizontally eg: Now two VPN connection combined together give 2.5GBPS(1.25GBPS + 1.25GBPS)
    * Max throughput AWS tested so far is 50GBPS
    * Direct Connect is still not supported(In AWS 2019 Roadmap)
    * Under the hood, to make this happen AWS is using a technology called [**Hyperplane**](https://twitter.com/awsreinvent/status/935740155499040768?lang=en)
    * Transit gateway each route table support 10000 routes(in case of VPC default route table limit is still 100)
    * Difference between Transit VPC vs Transit gateway
    * Transit Gateway is available under VPC console

##### Step1: Build TGW

* Go to [**link**](https://us-west-2.console.aws.amazon.com/vpc) → Transit Gateways → Transit Gateways --> Create Transit Gateway

    * Name tag and Description: Give some meaningful name to your Transit Gateway and Description
    * Amazon side ASN: Autonomous System Number (ASN) of your Transit Gateway. You can use an  existing ASN assigned to your network. If you don't have one, you can  use a private ASN in the 64512-65534 or 4200000000-4294967294 range.
    * DNS Support: Enable Domain Name System resolution for VPCs attached to this Transit Gateway(If you have multiple VPC, this will enable hostname resolution between two VPC)
    *VPN ECMP support: Equal-cost multi-path routing for VPN Connections that are attached to this Transit Gateway.Equal Cost Multipath (ECMP) routing support between VPN connections. If connections advertise the same CIDRs, the traffic is distributed equally between them.
    * Default route table association: Automatically associate Transit Gateway attachments with this Transit Gateway's default route table.
    * Default route table propagation: Automatically propagate Transit Gateway attachments with this Transit Gateway's default route table
    * Auto accept shared attachments: Automatically accept cross account attachments that are attached to this Transit Gateway.In case if you are planning to spread your TGW across multiple account.

##### Step2: Attach your VPC

* Go to Transit Gateways --> Transit Gateway Attachments --> Create Transit Gateway Attachment

    * Select your TGW created in Step1
    * Give your VPC attachment some name
    * Enable DNS support
    * Select your first VPC 

* Perform the same step for VPC2

###### NOTE: When you attach a VPC or create a VPN connection on a transit gateway, the attachment is associated with the default route table of the transit gateway.

##### Step3: Update Route Table

* If you click on the Transit Gateway Route Table, you will see we have the patch from Transit Gateway to our VPC

* We need a return path(i.e from our VPC to TGW), VPC1 route table needs to be updated to point to TGW to route to the second VPC and vice-versa(i.e 10.0.0.0/16 to tgw on the second VPC)

* Some Key Terms

    * associations — Each attachment is associated with exactly one route table. Each route table can be associated with zero to many attachments.
    * route propagation — A VPC or VPN connection can dynamically propagate routes to a transit gateway route table.

##### Step4

* Try to create Instance on VPC1 and VPC2
* ssh to the instance on VPC1(using its Public IP)
* Also, copy your Public ssh key to an instance in VPC1
* Now try to ssh to an instance in VPC2, using its Private IP
