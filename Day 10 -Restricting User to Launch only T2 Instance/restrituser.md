#### Problem: 
I want to limit user in my Dev Account to only launch instance type which is t2.*

#### Solution: This is possible by using IAM managed policy

### Step1:
* Go to IAM console [**here**](https://console.aws.amazon.com/iam/home?region=us-west-2#/home) → Policies → Create policy

### Step2:
* Under Service, Search for ec2

### Step3:
* Under Action, Select List and Read(User can’t do much damage with just list and read)
* Under the Filter actions search for run and select RunInstances(I need to give a user permission to launch instances)

### Step4:
* Resources(EC2 actually validates a bunch of resources), we can put a fine grain control but for the time being I am selecting any.

### Step5:
* Request Conditions: This is where we are going to specify that the user can only launch t2 instance type
* Add condition
```sh
* Condition key: Select ec2:InstanceType
* Qualifier: Default
* Operator: StringLike(As I have star in the Value)
* Value: t2.*
```