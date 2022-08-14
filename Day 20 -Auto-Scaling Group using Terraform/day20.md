* What is Auto Scaling?

    What auto-scaling will do, it ensures that we have a correct number of EC2 instances to handle the load of your applications.

* How Auto Scaling works

    * It all started with the creation of the Auto Scaling group which is the collection of EC2 instances.
    * We can specify a minimum number of instances and AWS EC2 Auto Scaling ensures that your group never goes below this size.
    * The same way we can specify the maximum number of instances and AWS EC2 Auto Scaling ensures that your group never goes above this size.
    * If we specify the desired capacity, AWS EC2 Auto Scaling ensures that your group has this many instances.
    * Configuration templates(launch template or launch configuration): Specify Information such as AMI ID, instance type, key pair, security group
    * If we specify scaling policies then AWS EC2 Auto Scaling can launch or terminate instances as demand on your application increased or decreased. For eg: We can configure a group to scale based on the occurrence of specified conditions(dynamic scaling) or on a schedule.

* Reference: [**here**](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)

* In the above example, Auto Scaling has

    * A minimum size of one instance.
    * Desired Capacity of two instances.
    * The maximum size of four instances.
    * Scaling policies we define adjust the minimum or a maximum number of instances based on the criteria we specify.

##### Step1:

* The first step in creating the AutoScaling Group is to create a launch configuration, which specifies how to configure each EC2 instance in the autoscaling group.

```sh
# aws_launch_config.tf
resource "aws_launch_configuration" "asg-config" {
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.asg-sg.id}"]
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "asg-sg" {
  name   = "my-test-sg"
  vpc_id = "${var.vpc_id}"
}

# Ingress Security Port 22
resource "aws_security_group_rule" "http_inbound_access" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.asg-sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.asg-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
```

* Most of the parameters look similar to EC2 configuration except lifecycle parameter which is required for using a launch configuration with an ASG

* One of the available lifecycle settings are create_before_destroy, which, if set to true, tells Terraform to always create a replacement resource before destroying the original resource. For example, if you set create_before_destroy to true on an EC2 Instance, then whenever you make a change to that Instance, Terraform will first create a new EC2 Instance, wait for it to come up, and then remove the old EC2 Instance.

* The catch with the create_before_destroy the parameter is that if you set it to true on resource X, you also have to set it to true on every resource that X depends on (if you forget, you’ll get errors about cyclical dependencies). In the case of the launch configuration, that means you need to set create_before_destroy to true on the security group

##### Step:

```sh
data "aws_availability_zones" "all" {}
resource "aws_autoscaling_group" "test-asg" {
  launch_configuration    = "${aws_launch_configuration.asg-config.id}"
  availability_zones      = ["${data.aws_availability_zones.all.names}"]
  target_group_arns       = ["${var.target_group_arn}"]
  health_check_type       = "ELB"
  min_size                = "1"
  max_size                = "2"
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "my-terraform-asg-example"
  }
}
```

* Next step is to create an auto-scaling group using the aws_autoscaling_group resource.
* This autoscaling group will spin a minimum of 1 instance and a maximum of 2 instances OR completely based on your requirement.
* It’s going to use the launch configuration we created in the earlier step.
* We are using an aws_availibity_zone resource which will make sure instance will be deployed in different Availability Zone.
* A list of aws_alb_target_group ARNs, for use with Application Load Balancing, this is created During Day 19 when we created Application Load Balancer. If you are still not sure about the Value, in the outputs.tf file put this entry

```sh
output "target_group_arn" {
  value = "${aws_lb_target_group.my-alb-tg.arn}"
}
```
and then run terraform apply command, you will see something like this;

```sh
Outputs:

target_group_arn = arn:aws:elasticloadbalancing:us-west-2:XXXXXX0:targetgroup/my-alb-tg/85a23209f9c37964
```

