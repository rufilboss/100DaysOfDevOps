provider "aws" {
  region = "us-west-2"
}
resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = "XXXX"
}
resource "aws_security_group" "examplesg" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "ec2_instance" {
  ami             = "ami-28e07e50"
  instance_type   = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.examplesg.id}"]
  key_name        = "${aws_key_pair.example.id}"
  tags {
    Name = "first-ec2-instance"
  }
}