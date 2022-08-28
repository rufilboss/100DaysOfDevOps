* What is AWS S3 Intelligent-Tiering (S3 INT)?

    * S3 Intelligent Tiering is the new storage class, AWS launched during AWS re:invent 2018.
    * Now we can choose Intelligent-Tiering while uploading any object to S3 bucket
    * Use Machine Learning under the hood(monitoring access pattern over our data) to move objects that are not been accessed from 30 days.
    * There are no retrieval fees in moving the object back to S3 Standard tier in case we access the object in an infrequent tier.
    Comes with additional cost.

* What is the use case or problem this is going to solve?

    * Currently, if we want to move data from one storage class to another, we have two options

        * LifeCycle Policies: We can transition from Standard to Standard-IA, One Zone-IA, or Glacier based on their creation date
        * Now we have the new choice of intelligent tiering(besides choosing it during upload)
        * Storage Class Analytics: Other options we have is by using Storage Class Analytics. This will help us to find out if the data stored in S3 Standard class is suited for S3 Infrequent access.

###### Reference: [**here**](https://docs.aws.amazon.com/AmazonS3/latest/dev/analytics-storage-class.html)

* Issues

    * Access pattern of data is irregular
    * You don’t have time to use Storage Class Analytics
