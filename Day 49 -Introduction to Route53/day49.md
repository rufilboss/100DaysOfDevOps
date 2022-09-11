#### What is AWS Route53?

* Amazon Route 53 is a highly available and scalable Domain Name System (DNS) web service. You can use Route 53 to perform three main functions in any combination:

    * Domain Registration
    * DNS Routing
    * Health Checking

##### Key DNS Terms

* A Record

    * A record is used to translate human-friendly domain names such as “www.example.com" into IP-addresses such as 192.168.0.1 (machine friendly numbers).

* CNAME Record

    * A Canonical Name record (abbreviated as CNAME record) is a type of resource record in the Domain Name System (DNS) which maps one domain name (an alias) to another (the Canonical Name.)

* NameServer Record

    * NS-records identify the DNS servers responsible (authoritative) for a zone.

    * Amazon Route 53 automatically creates a name server (NS) record that has the same name as your hosted zone. It lists the four name servers that are the authoritative name servers for your hosted zone. Do not add, change, or delete name servers in this record.

        ns-2048.awsdns-64.com
        ns-2049.awsdns-65.net
        ns-2050.awsdns-66.org
        ns-2051.awsdns-67.co.uk

* SOA Record

    * A Start of Authority record (abbreviated as SOA record) is a type of resource record in the Domain Name System (DNS) containing administrative information about the zone, especially regarding zone transfers

##### AWS Specific DNS Terms

* Alias Record

    Amazon Route 53 alias records provide a Route 53–specific extension to DNS functionality. Alias records let you route traffic to selected AWS resources, such as CloudFront distributions and Amazon S3 buckets. They also let you route traffic from one record in a hosted zone to another record.

    Unlike a CNAME record, you can create an alias record at the top node of a DNS namespace, also known as the zone apex. For example, if you register the DNS name example.com, the zone apex is example.com. You can’t create a CNAME record for example.com, but you can create an alias record for example.com that routes traffic to www.example.com.

* AWS Route53 Health Check

    * Amazon Route 53 health checks monitor the health and performance of your web applications, web servers, and other resources. Each health check that you create can monitor one of the following:

        * The health of a specified resource, such as a web server
        * The status of other health checks
        * The status of an Amazon CloudWatch alarm

###### Step1: Create a hosted zone

* Go to [**here**](https://console.aws.amazon.com/route53) --> Hosted zones --> Create Hosted Zone

    * Domain Name: You must need to purchase this domain either from your Domain Registrar or you can purchase from Amazon
    * Comment: Add some comment
    * Type: Public Hosted Zone(if purchased by a domain registrar) OR you can set Private Hosted Zone for Amazon VPC

* The moment you create a hosted zone four NS and SOA record will be created for you.

##### NOTE: Please don’t change or alter these record.

###### Step2: Create A record

* Name : www
* Type: A-IPv4 address
* Alias: No
* TTL: Select +1m(60second)
* Value: Public IP of your EC2 instance
* Routing Policy: Simple


### Using Terraform

Check out [**here**](https://github.com/rufilboy/100DaysOfDevOps/blob/main/Day%2049%20-Introduction%20to%20Route53/route53.tf)

[**Reference**](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating.html)