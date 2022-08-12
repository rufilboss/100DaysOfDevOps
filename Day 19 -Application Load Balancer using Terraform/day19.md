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

* Reference: [**here**](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)

###### Step1: 

* Define the load balancer

```sh
# lb_define.tf
resource "aws_lb" "my-test-lb" {
  name               = "my-test-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  subnets            = ["${var.subnet_id1}", "${var.subnet_id2}"]

  enable_deletion_protection = true

  tags {
    Name = "my-test-alb"
  }
}
```

