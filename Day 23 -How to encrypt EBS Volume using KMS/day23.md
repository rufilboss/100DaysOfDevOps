## Using AWS Management Console

* Encrypt EBS Volume using KMS Key

```sh
AWS Console --> EC2 --> ELASTIC BLOCK STORE --> Volumes --> Create Volume
```

* One important point to note here, KeyManager will tell you if this is managed by AWS(anything starts with aws is an aws managed key)or its customer Managed keys(key that is created by us)

```sh
* Check the Encryption tab
* Under Master Key(Select the KMS we just created from the drop down)
```
