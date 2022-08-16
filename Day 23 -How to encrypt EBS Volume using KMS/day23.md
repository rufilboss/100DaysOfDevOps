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

* To summarize how it works

    * When you create an encrypted EBS volume, Amazon EBS sends a GenerateDataKeyWithoutPlaintext request to AWS KMS, specifying the CMK that you choose for EBS volume encryption.
    * AWS KMS generates a new data key, encrypts it under the specified CMK, and then sends the encrypted data key to Amazon EBS to store with the volume metadata.
    * When you attach the encrypted volume to an EC2 instance, Amazon EC2 sends the encrypted data key to AWS KMS with a Decrypt request.
    * AWS KMS decrypts the encrypted data key and then sends the decrypted (plaintext) data key to Amazon EC2.
    * Amazon EC2 uses the plaintext data key in hypervisor memory to encrypt disk I/O to the EBS volume. The plaintext data key persists in memory as long as the EBS volume is attached to the EC2 instance.

#### NOTE:

* All the snapshots created from this volume are all encrypted.
* The plaintext data key persists in Hypervisor memory.

## Using Terrform

Terraform Code [**here**]()

```sh
# Some changes
* encrypted: This is required to encrypt the disk
* kms_key_id: The ARN for the KMS encryption key
```

#### NOTE: encrypted parameter is mandatory to set, else you will run into this error

```sh
* aws_ebs_volume.my-test-kms-ebs: Error creating EC2 volume: InvalidParameterDependency: The parameter [KmsKeyId] requires the parameter Encrypted to be set.
status code: 400, request id: feeb7131-82ea-48d2-854e-84e4fbb7e5e1
```