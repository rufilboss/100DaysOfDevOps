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

```sh
name: The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. If not specified, Terraform will autogenerate a name beginning with tf-lb (This part is important as Terraform auto
internal: If true, the LB will be internal.
load_balancer_type: The type of load balancer to create. Possible values are application or network. The default value is application.
ip_address_type: The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack
subnets: A list of subnet IDs to attach to the LB.In this case I am attaching two public subnets we created during load balancer creation
enable_deletion_protection: If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false.
tags: A mapping of tags to assign to the resource.
```

##### Step2: 
* Define the target group: This is going to provide a resource for use with Load Balancer.

```sh
resource "aws_lb_target_group" "my-alb-tg" {
  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  name        = "my-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"
}
```
