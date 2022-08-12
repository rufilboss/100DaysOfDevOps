* What is Application Load Balancer?

The Application Load Balancer is a feature of ElasticLoad Balancing that allows a developer to configure and route incoming end-user traffic to applications based in the Amazon Web Services (AWS) public cloud.

* Features
    * Layer7 load balancer(HTTP and HTTPs traffic)
    * Support Path and Host-based routing(which let you route traffic to different target group)
    * Listener support IPv6

* Target types:
    * Instance types: Route traffic to the Primary Private IP address of that Instance
    * IP: Route traffic to a specified IP address
    * Lambda function

* Health Check
    * Determines whether to send traffic to a given instance
    * Each instance must pass its a health check
    * Sends HTTP GET request and looks for a specific response/success code