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

## Using AWS Management Console 

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

* We can create our own custom policy using policy generator or written from scratch

    So Custom Policy where everything denies for EC2 resources

    ```sh
    {
    “Version”: “2012–10–17”,
    “Statement”: [
    {
    “Sid”: “Stmt1491718191000”,
    “Effect”: “Deny”,
    “Action”: [
    “ec2:*”
    ],
    “Resource”: [
    “*”
    ]
    }
    ]
    }
    ```

* More than one policy can be attached to a user or group at the same time
* Policy cannot be directly attached to AWS resources(eg: EC2 instance)
* There is a really nice tool [**link**](https://policysim.aws.amazon.com) which we can use to test and troubleshoot IAM and resource based policies

## Using Terraform

* Let’s create IAM user using terraform

```sh
resource "aws_iam_user" "example" {
  name = "rufilboy"
}
```

* Now if I want to create more than one IAM user

* One way to achieve the same is copy paste the same piece of code but that defeats the whole purpose of DRY.

* Terraform provides meta parameters called count to achieve the same i.e to do certain types of loops.The count is a meta parameter which defines how many copies of the resource to create.

```sh
resource "aws_iam_user" "example" {
  count = 3
  name = "rufilboy"
}
```

* One problem with this code is that all three IAM users would have the same name, which would cause an error since usernames must be unique

* To accomplish the same thing in Terraform, you can use count.index to get the index of each “iteration” in the “loop”:

```sh
resource “aws_iam_user” “example” {
 count = 3
 name = “rufilboy.${count.index}”
}
```

* If we run the plan again we will see terraform want to create three IAM user, each with a different name(rufilboy.0, rufilboy.1, rufilboy.2)

    Think of a real-world scenario, we are hardly going to see names like rufilboy.0–2

* The solution for this issue, If we combine count.index with interpolation functions built into Terraform, you can customize each “iteration” of the “loop” even more. To achieve this we need two interpolation functions length and element. [**Link**](https://www.terraform.io/docs/configuration/interpolation.html)


    element(list, index) — Returns a single element from a list at the given index. If the index is greater than the number of elements, this function will wrap using a standard mod algorithm. This function only works on flat lists.

OR

* The element function returns the item located at INDEX in the given LIST

    length(list) — Returns the number of members in a given list or map, or the number of characters in a given string.

OR

* The length function returns the number of items in LIST (it also works with strings and maps)

    ```sh
    #variables.tf
    variable "username" {
    type = "list"
    default = ["rufilboy","aishruffy","ajhisope"]
    }
    #main.tf
    resource "aws_iam_user" "example" {
    count = "${length(var.username)}"
    name = "${element(var.username,count.index )}"
    }
    ```

* Now when you run the plan command, you’ll see that Terraform wants to create three IAM users, each with a unique name

* You'll notice that once we use count on a resource, it becomes the list of resources rather than just a single resource.

* For example, if you wanted to provide the Amazon Resource Name (ARN) of one of the IAM users as an output variable, you would need to do the following:

```sh
# outputs.tf
output “user_arn” {
 value = “${aws_iam_user.example.0.arn}”
}
```

* If you want the ARNs of all the IAM users, you need to use the splat character, “*”, instead of the index:

```sh
# outputs.tf
output “user_arn” {
 value = “${aws_iam_user.example.*.arn}”
}
```

* Terraform provides a handy data source called the aws_iam_policy_document that gives you a more concise way to define the IAM policy

```sh
data "aws_iam_policy_document" "example" {
  statement {
    actions = [
      "ec2:Describe*"]
    resources = [
      "*"]
  }
}
```

    * IAM Policy consists of one or more statements
    * Each of which specifies an effect (either “Allow” or “Deny”). Default policy is deny.
    * One or more actions (e.g., “ec2:Describe*” allows all API calls to EC2 that start with the name “Describe”). Here ec2 is the service and Describe is the Action which is specific to that service.
    * One or more resources (e.g., “*” means “all resources”)

* To create a new IAM managed policy from this document, we need to use aws_iam_policy resource

```sh
resource “aws_iam_policy” “example” {
 name = “ec2-read-only”
 policy = “${data.aws_iam_policy_document.example.json}”
}
```

* This code uses the count parameter to “loop” over each of your IAM users and the element interpolation function to select each user’s ARN from the list returned by aws_iam_user.example.*.arn.

```sh
resource “aws_iam_user_policy_attachment” “test-attach” {
 count = “${length(var.username)}”
 user = “${element(aws_iam_user.example.*.name,count.index )}”
 policy_arn = “${aws_iam_policy.example.arn}”
}
```

* IAM Roles are used to granting the application access to AWS Services without using permanent credentials.

* IAM Role is one of the safer ways to give permission to your EC2 instances.

* We can attach roles to an EC2 instance, and that allows us to give permission to EC2 instance to use other AWS Services eg: S3 buckets

