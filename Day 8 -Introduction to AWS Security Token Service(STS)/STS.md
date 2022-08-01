#### Problem: 
Rather than hardcode the value of access and secret access keys inside my instance to access any aws service, I want to use some automated ways so that keys should be rotated automatically and there is no way credentials could be compromised.

#### Solution: AWS Security Token Service(STS)

###### AWS Security Token Service(STS) that enables you to request temporary, limited privilege credentials for IAM Users or Federated Users).

#### Benefits
No need to embed token in the code
Limited Lifetime(15min — 1 and 1/2 day(36 hours))

#### Use Cases
* Identity Federation(Enterprise Identity Federation[Active Directory/ADFS]/ Web Identity Federation (Google, Facebook,Amazon))
* Cross-account access(For Organization with multiple AWS accounts)
* Applications on Amazon EC2 Instances
##### Let see this in action

# Using AWS Management Console

### Step1
* Create an IAM user
* Go to AWS Console → Security, Identity, & Compliance → IAM → Users → Add user
```sh
User name: Please give some meaningful name
Access type: Only give this user Programmatic access
```
* In the next step don’t add this user to any group or attach any existing policy
* Keep everything default, Review and Create user

### Step2

* Create Roles
* Choose Another AWS account
* Attach a Policy(AmazonS3ReadOnlyAccess)
* Review and create role

### Step3:

* Update/Modify Trust Relationships
* Go to the Role we have just created and Click on Second Tab Trust relationships
```sh{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::XXXXXX:user/myteststsuser"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```
* The current trust relation only allow root account to assume this role
* Modify it with the arn of the user(myteststsuser) we have just created

### Step4

* Add inline policy to the user we have created
```sh
Service: STS
Action: AssumeRole
Resource: ARN of the role we created earlier
```
* This is making our user assume the role
