* What are VPC Flow logs?

* It comprised of IP traffic information
* These logs are useful for troubleshooting network conversations and can be assigned to(Capture Points)

    ```sh
    * VPC
    * Subnet
    * Elastic Network Interface
    ```

###### NOTE: Flow logs don’t capture data, so you can’t do packet analysis even if its un-encrypted.

* Setup VPC Flow Logs

    ```sh
    Go To AWS Console --> VPC --> Select your VPC --> Flow logs --> Create flow log
    ```

```sh
* Filter: Select All(Other options Accept/Reject)
* Destination: Send to CloudWatch Logs
* Destination log group: Go to AWS Console --> CloudWatch --> Logs --> Create log group
```

* After creating flow logs, if you look for the subnet of the VPC, you will see subnet have flow logs associated with it and this is because it inherited flowlogs from VPC.

* Flow Log Record Syntax

    * A flow log record is a space-separated string that has the following format:

```sh
<version> <account-id> <interface-id> <srcaddr> <dstaddr> <srcport> <dstport> <protocol> <packets> <bytes> <start> <end> <action> <log-status>
2 123456789010 eni-abc123de 172.31.16.139 172.31.16.21 20641 22 6 20 4249 1418530010 1418530070 ACCEPT OK
```

![**SampleImage**](https://miro.medium.com/max/1400/1*dg55BLfizLIgkMbEcO8qLw.png)
