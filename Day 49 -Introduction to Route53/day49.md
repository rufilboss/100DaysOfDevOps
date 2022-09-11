###### What is AWS Route53?

* Amazon Route 53 is a highly available and scalable Domain Name System (DNS) web service. You can use Route 53 to perform three main functions in any combination:

    * Domain Registration
    * DNS Routing
    * Health Checking

###### Key DNS Terms

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

