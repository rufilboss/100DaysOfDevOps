###### What is VPC Peering?

* A VPC peering connection is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 addresses or IPv6 addresses. Instances in either VPC can communicate with each other as if they are within the same network.

    * Let say two VPC want to communicate with each other or share service between them, the best way to do that with the help of VPC Peering
    * VPC Peering connection is a networking connection between two VPCs that allow us to route traffic between them using private IPv4 addresses.
    * Instances in either VPC can communicate with each other as if they are part of the same network
    * AWS uses the existing infrastructure of a VPC to create a VPC peering connection
    * It’s neither a gateway nor a VPN connection and doesn’t rely on a separate piece of physical hardware
    * There is no single point of failure or a bandwidth bottleneck i.e bandwidth between instances in peered VPC is no different than bandwidth between instances in the same VPC.
    * VPC Peering doesn’t support transitive peering i.e VPC1 can talk to VPC 2, VPC 2 can talk to VPC3 but VPC1 can’t talk to VPC3. This is because of the security reason so if VPC1 want to communicate with VPC3 we need to establish one more peering connection between VPC1 and VPC3.
    * Once VPC Peering is established instance in two VPC can communicate with each other using Private IP(no need to communicate via Internet Gateway)
    * Inter-region VPC is supported
    * VPC Peering is even supported between two different accounts
    * Make sure there is no over-lapping IP between two VPC’s

* Go to your VPC Dashboard and look for Peering Connections → Create Peering Connection

    * Give some meaningful name to Peering connection name tag(eg: vpc-peering-test)
    * Select Requester VPC
    * As mentioned in the first part of the series, we can create VPC Peering between different account as well as between different region
    * Select Acceptor VPC(As you can see Acceptor VPC has complete different CIDR region, as overlapping CIDR is not supported)

* Even when creating VPC Peering between the same account, you still need to accept peering connection

* The final step is to update the individual VPC route table with the peering connection

###### Terraform Code

* Check the code [**here**](https://github.com/rufilboy/100DaysOfDevOps/blob/main/Day%2031%20-Introduction%20to%20VPC%20Peering/aws_vpc_peering.tf)