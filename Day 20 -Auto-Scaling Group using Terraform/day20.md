* What is Auto Scaling?

    What auto-scaling will do, it ensures that we have a correct number of EC2 instances to handle the load of your applications.

* How Auto Scaling works

    It all started with the creation of the Auto Scaling group which is the collection of EC2 instances.
    We can specify a minimum number of instances and AWS EC2 Auto Scaling ensures that your group never goes below this size.
    The same way we can specify the maximum number of instances and AWS EC2 Auto Scaling ensures that your group never goes above this size.
    If we specify the desired capacity, AWS EC2 Auto Scaling ensures that your group has this many instances.
    Configuration templates(launch template or launch configuration): Specify Information such as AMI ID, instance type, key pair, security group
    If we specify scaling policies then AWS EC2 Auto Scaling can launch or terminate instances as demand on your application increased or decreased. For eg: We can configure a group to scale based on the occurrence of specified conditions(dynamic scaling) or on a schedule.

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

