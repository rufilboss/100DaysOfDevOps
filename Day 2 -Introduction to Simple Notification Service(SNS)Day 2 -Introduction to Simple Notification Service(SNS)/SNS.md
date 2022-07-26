# Using the AWS Console

## Step1: Create a topic
1. In the Amazon SNS console, choose Create topic.
2. Create topic.

## Step2: Subscribe to a Topic
1. Choose to Create a subscription.
2. The Create Subscription dialog box appears.
3. Then go to your email and confirm subscription.

## Step3: Publish to the topic
1. Choose the Publish to the topic button.
2. The Publish a Message page appears.

# Using AWS CLI

## Create a Topic
```sh
$ aws sns create-topic --name "example-sns-topic"
{
"TopicArn": "arn:aws:sns:us-west-2:1234556667:example-sns-topic"
}
```

## Subscribe to a Topic
```sh
$ aws sns subscribe --topic-arn arn:aws:sns:us-west-2:123456667:example-sns-topic --protocol email --notification-endpoint example@gmail.com
{
"SubscriptionArn": "Pending confirmation"
}
```

## Publish to a Topic
```sh
$ aws sns publish --topic-arn arn:aws:sns:us-west-2:1234567:example-sns-topic --message "Hello from sns"
{
"MessageId": "d651b7d5-2d66-58c8-abe4-e30822a3aa3e"
}
```

## To list all the subscriptions
```sh
$ aws sns list-subscriptions
{
    "Subscriptions": [
        {
            "Owner": "123456789012",
            "Endpoint": "example@gmail.com",
            "Protocol": "email",
            "TopicArn": "arn:aws:sns:us-west-2:1234567899:example",
            "SubscriptionArn": "arn:aws:sns:us-west-2:1234567899:example-sns-topic:f28124be-850b-4a2e-8d3e-a3dc4f7cca1a"
        }
    ]
}
```

## Unsubscribe from a Topic
```sh
$ aws sns unsubscribe --subscription-arn arn:aws:sns:us-west-2:1234567899:example-sns-topic:f28124be-850b-4a2e-8d3e-a3dc4f7cca1a
```

## Delete a topic
```sh
$ aws sns delete-topic --topic-arn arn:aws:sns:us-west-2:1234567788:my-demo-sns-topic
```

## List a topic
```sh
$ aws sns list-topics
{
"Topics": [
{
"TopicArn": "arn:aws:sns:us-west-2:1234567899:example"
}
]
}
```

# Using Terraform

Check the terraform files...