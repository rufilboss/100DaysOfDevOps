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

### Step6:
* In the next screen, give your policy some name
* Final policy look like this
```sh
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances",
                "ec2:GetConsoleScreenshot"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:subnet/*",
                "arn:aws:ec2:*:*:key-pair/*",
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ec2:*::snapshot/*",
                "arn:aws:ec2:*:*:launch-template/*",
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:security-group/*",
                "arn:aws:ec2:*:*:placement-group/*",
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*::image/*"
            ],
            "Condition": {
                "StringLikeIfExists": {
                    "ec2:InstanceType": "t2.*"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeSnapshots",
                "ec2:DescribeHostReservationOfferings",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeScheduledInstanceAvailability",
                "ec2:DescribeVolumes",
                "ec2:DescribeFpgaImageAttribute",
                "ec2:DescribeExportTasks",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeReservedInstancesListings",
                "ec2:DescribeCapacityReservations",
                "ec2:DescribeSpotFleetRequestHistory",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeSnapshotAttribute",
                "ec2:DescribeIdFormat",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeImportSnapshotTasks",
                "ec2:GetPasswordData",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeTransitGatewayAttachments",
                "ec2:DescribeScheduledInstances",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeFleets",
                "ec2:DescribeReservedInstancesModifications",
                "ec2:DescribeSubnets",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeFleetHistory",
                "ec2:DescribePrincipalIdFormat",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeRegions",
                "ec2:DescribeTransitGateways",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeSpotInstanceRequests",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeTransitGatewayRouteTables",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeHostReservations",
                "ec2:DescribeBundleTasks",
                "ec2:DescribeIdentityIdFormat",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeFpgaImages",
                "ec2:DescribeVpcs",
                "ec2:DescribeStaleSecurityGroups",
                "ec2:DescribeAggregateIdFormat",
                "ec2:DescribeVolumesModifications",
                "ec2:GetHostReservationPurchasePreview",
                "ec2:DescribeByoipCidrs",
                "ec2:DescribePlacementGroups",
                "ec2:DescribeInternetGateways",
                "ec2:SearchTransitGatewayRoutes",
                "ec2:GetLaunchTemplateData",
                "ec2:DescribeSpotDatafeedSubscription",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeReservedInstances",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeRouteTables",
                "ec2:DescribeEgressOnlyInternetGateways",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeReservedInstancesOfferings",
                "ec2:GetTransitGatewayAttachmentPropagations",
                "ec2:DescribeFleetInstances",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribePrefixLists",
                "ec2:GetReservedInstancesExchangeQuote",
                "ec2:DescribeInstanceCreditSpecifications",
                "ec2:DescribeVpcClassicLink",
                "ec2:GetTransitGatewayRouteTablePropagations",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeElasticGpus",
                "ec2:DescribeVpnGateways",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeDhcpOptions",
                "ec2:GetConsoleOutput",
                "ec2:DescribeSpotPriceHistory",
                "ec2:DescribeNetworkInterfaces",
                "ec2:GetTransitGatewayRouteTableAssociations",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:DescribeTags",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:DescribeImportImageTasks",
                "ec2:DescribeNatGateways",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeSpotFleetRequests",
                "ec2:DescribeHosts",
                "ec2:DescribeImages",
                "ec2:DescribeSpotFleetInstances",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribePublicIpv4Pools",
                "ec2:DescribeTransitGatewayVpcAttachments",
                "ec2:DescribeConversionTasks"
            ],
            "Resource": "*",
            "Condition": {
                "StringLikeIfExists": {
                    "ec2:InstanceType": "t2.*"
                }
            }
        }
    ]
}
```

### Step7:
* Attach this policy to the user you want to test
* Go to the particular user
* Click on Add permissions

### Step8:
* Logout and logged in as that particular user and try to launch instance type as t2.micro
##### NOTE: If you are getting this error
* You might need to add one more policy to give your user permission to create keys and attach it to the user.
###### OR Security Group error

* After adding all these policies you will see something like this
* Now let me try to launch some other instance type
* You will see some messages

* If you want to decode this message, you will see an explicit deny in trying to launch a specific resource.