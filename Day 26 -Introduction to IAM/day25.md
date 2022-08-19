###### What is IAM?

* Identity and Access Management(IAM) is used to manage AWS, and it provide method for secure access/access-permissions to AWS resources(such as EC2,S3, etc)

    * Users
    * Groups
    * Roles
    * Api Keys
    * IAM Access Policies

* At the right hand side at the top of console you'll see Global i.e creating a user/groups/roles will apply to all regions

    * To create a new user, Just click on Users on the left navbar
    * By default any new IAM account created with NO access to any AWS services(non-explicit deny)
    * Always follow the best practice and for daily work try to use a account with least privilege(i.e non root user)

* IAM Policies: A policy is a document that formally states one or more permissions.For eg: IAM provides some pre-built policy templates to assign to users and groups

    * Administrator access: Full access to AWS resources
    * Power user access: Admin access except it doesn’t allow user/group management
    * Read only access: As name suggest user can only view AWS resources

* Default policy is explicitly deny which will override any explicitly allow policy

* Let take a look at these policies

AdministratorAccess

```sh
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```
