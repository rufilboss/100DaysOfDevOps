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

