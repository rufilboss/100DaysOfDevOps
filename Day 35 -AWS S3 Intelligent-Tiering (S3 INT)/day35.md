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

* S3 Intelligent-Tiering

    * If you are facing the above two problems then S3 Intelligent Tiering is here for your rescue.
    * It incorporates two access tier(Standard and Standard Infrequent Access)
    * As mentioned above, it monitors access patterns and moves objects that have not been accessed for 30 consecutive days to the infrequent access tier.
    * If the data is accessed later, it is automatically moved back to the frequent access tier with no additional cost.
    * It can be specified while uploading objects OR during LifeCycle Policy.
    * Comes with additional cost
    * There are no additional fees while retrieving data back from S3 Infrequent to S3 Standard.
    * Supports all S3 features cross-region replication, encryption, object tagging, and inventory.

* Some points to consider before using S3 Intelligent Tiering Class

    * An object smaller than 128KB will never be transitioned to S3 Infrequent access and will be billed usually.
    * Not fit for an object which lives less than 30 days, all objects will be billed with a minimum of 30 days.

* Final Word

    * S3 Intelligent Tiering comes with an additional cost, if that is less than what you are paying right now, then this class is for you
    * It looks promising, as AWS is using Machine Learning Model under the hood, to fed trillions of objects and millions of requests to predict future access patterns for each object. The results were then used to inform storage of your S3 objects in the most cost-effective way possible.

