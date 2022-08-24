###### What is VPC Peering?

* Let say two VPC want to communicate with each other or share service between them, the best way to do that with the help of VPC Peering
* VPC Peering connection is a networking connection between two VPCs that allow us to route traffic between them using private IPv4 addresses.
* Instances in either VPC can communicate with each other as if they are part of the same network
* AWS uses the existing infrastructure of a VPC to create a VPC peering connection
* It’s neither a gateway nor a VPN connection and doesn’t rely on a separate piece of physical hardware
* There is no single point of failure or a bandwidth bottleneck i.e bandwidth between instances in peered VPC is no different than bandwidth between instances in the same VPC.

