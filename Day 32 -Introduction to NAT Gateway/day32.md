* What is NAT Gateway

    * NAT gateway enables instance in Private Subnet to connect to the internet or other AWS services but prevent the internet from initiating a connection with those instances.

* How NAT works

    * NAT device has an Elastic IP address and is connected to the Internet through an internet gateway.
    * When we connect an instance in a private subnet through the NAT device, which routes traffic from the instance to the internet gateway and routes any response to the instance
    * NAT maps multiple private IPv4 addresses to a single public IPv4 address.
* NAT gateway doesn’t support IPv6 traffic for that you need to use Egress only gateway.

##### NOTE: IPv6 traffic is separate from IPv4 traffic, route table must include separate routes for IPv6 traffic.

