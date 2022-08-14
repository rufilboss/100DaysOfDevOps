* What Is Amazon Relational Database Service (Amazon RDS)?

Amazon Relational Database Service (Amazon RDS) is a web service that makes it easier to set up, operate, and scale a relational database in the cloud. It provides cost-efficient, resizable capacity for an industry-standard relational database and manages common database administration tasks.

#### Step1: Create a DB subnet group

* In order to create a new MySql database we first need to create a subnet group and assign at least two subnets to it.

```sh

resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = ["${var.rds_subnet1}","${var.rds_subnet2}"]
}
```

#### Step2: Create a Security Group to allow mysql port 3306

```sh

resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  vpc_id = "${var.vpc_id}"

}

# Ingress Security Port 3306
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = "${aws_security_group.rds-sg.id}"
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
```

#### Step3: Next step is to create MySQL resource

```sh
resource "aws_db_instance" "my_test_mysql" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "${var.db_instance}"
  name                        = "myrdstestmysql"
  username                    = "admin"
  password                    = "admin123"
  parameter_group_name        = "default.mysql5.7"
  db_subnet_group_name        = "${aws_db_subnet_group.rds-private-subnet.name}"
  vpc_security_group_ids      = ["${aws_security_group.rds-sg.id}"]
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = 35
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = true
  skip_final_snapshot         = true
}
```

```sh

* allocated_storage: This is the amount in GB
* storage_type: Type of storage we want to allocate(options avilable "standard" (magnetic), "gp2" (general purpose SSD), or "io1" (provisioned IOPS SSD)
* engine: Database engine(for supported values check https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html) eg: Oracle, Amazon Aurora,Postgres 
* engine_version: engine version to use
* instance_class: instance type for rds instance
* name: The name of the database to create when the DB instance is created.
* username: Username for the master DB user.
* password: Password for the master DB user
* db_subnet_group_name:  DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC
* vpc_security_group_ids: List of VPC security groups to associate.
* allows_major_version_upgrade: Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible.
* auto_minor_version_upgrade:Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Defaults to true.
* backup_retention_period: The days to retain backups for. Must be between 0 and 35. When creating a Read Replica the value must be greater than 0
* backup_window: The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window
* maintainence_window: The window to perform maintenance in. Syntax: "ddd:hh24:mi-ddd:hh24:mi".
* multi_az: Specifies if the RDS instance is multi-AZ
* skip_final_snapshot: Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier. Default is false
```

* One of the clear issues I see in the above code is that we are passing the password in the plain text inside the terraform code


* Now to encrypt that password we can use KMS
#### Step1: First Create KMS Keys

```sh
resource "aws_kms_key" "rds-key" {
    description = "key to encrypt rds password"
  tags {
    Name = "my-rds-kms-key"
  }
}

resource "aws_kms_alias" "rds-kms-alias" {
  target_key_id = "${aws_kms_key.rds-key.id}"
  name = "alias/rds-kms-key"
}
```

#### Step2: Now use that key to encrypt a secret on a command line

```sh
aws kms encrypt --key-id <kms key id> --plaintext admin123 --output text --query CiphertextBlob
```

#### Step3: Now the encoded string we got pass it as a payload in your terraform code


```sh

data "aws_kms_secret" "rds-secret" {
  "secret" {
    name = "master_password"
    payload = "payload value here"
  }
}

resource "aws_db_instance" "my_test_mysql" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "${var.db_instance}"
  name                        = "myrdstestmysql"
  username                    = "admin"
  password                    = "${data.aws_kms_secret.rds-secret.master_password}"
  parameter_group_name        = "default.mysql5.7"
  db_subnet_group_name        = "${aws_db_subnet_group.rds-private-subnet.name}"
  vpc_security_group_ids      = ["${aws_security_group.rds-sg.id}"]
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = 35
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = true
  skip_final_snapshot         = true
}
```

* Now why I didn’t put this solution in first place and the reason for that, because of the below-mentioned error and I want to present a working solution

```sh
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

aws_kms_key.rds-key: Refreshing state... (ID: 9731dd04-5859-430b-aa92-c27c517ecb10)
data.aws_kms_secret.rds: Refreshing state...
data.aws_availability_zones.available: Refreshing state...
aws_kms_alias.rds-kms-alias: Refreshing state... (ID: alias/rds-kms-key)

Error: Error refreshing state: 1 error(s) occurred:

* data.aws_kms_secret.rds: 1 error(s) occurred:

* data.aws_kms_secret.rds: data.aws_kms_secret.rds: This data source has been replaced with the `aws_kms_secrets` data source. Upgrade information is available at: https://www.terraform.io/docs/providers/aws/guides/version-2-upgrade.html#data-source-aws_kms_secret
```

