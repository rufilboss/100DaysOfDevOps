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

###### Step1: Build TGW

* Go to [**link**](https://us-west-2.console.aws.amazon.com/vpc) → Transit Gateways → Transit Gateways --> Create Transit Gateway

