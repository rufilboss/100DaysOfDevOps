* What is AWS S3 Intelligent-Tiering (S3 INT)?

    * S3 Intelligent Tiering is the new storage class, AWS launched during AWS re:invent 2018.
    * Now we can choose Intelligent-Tiering while uploading any object to S3 bucket
    * Use Machine Learning under the hood(monitoring access pattern over our data) to move objects that are not been accessed from 30 days.
    * There are no retrieval fees in moving the object back to S3 Standard tier in case we access the object in an infrequent tier.
    Comes with additional cost.