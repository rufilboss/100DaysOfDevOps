* What is AWS RDS?

    Amazon Relational Database Service (Amazon RDS) is a web service that makes it easier to set up, operate, and scale a relational database in the cloud. It provides cost-efficient, resizable capacity for an industry-standard relational database and manages common database administration tasks.

## Using AWS Management Console

* Go To AWS Console --> RDS --> Click on Get Started Now --> Select MySQL --> Choose Use Case -->  Fill in the neccesary info --> Launch DB instance

* As this is for learning Purpose

    DB instance class(db.t2.micro)
    Skip MultiAZ deployment for the time being
    Gave all the info like(DB instance identifier, Master username, Master password)

* Mainly you need to fill

    Database name(Don’t confuse it DB instance identifier)
    Backup retention period(0 days, for the time being)

* Then click on Launch DB instance

* Wait for few mins 5–10min(or depend upon your instance type and size) and check Instance Status(It should be available)

* We need to create a replica

* Create read replica option will not be highlighted yet because;

    * We don’t have a snapshot
    * We don’t have an automated backups

* Read replica is always created from a snapshot or the latest backup

* Take the snapshot of the running database

* Once the snapshot creation is done, let’s try to convert this into multi-AZ. Go to Instance actions and click on Modify

* These are the things I modified

    * Multi-AZ set to Yes
    * Under settings you need to enter the password again
    * I am enabling backup and set it to 1 day

* On the final screen, you have the option

    * Apply during the next scheduled maintenance window
    * Apply immediately(This will cause a downtime)

* Now, we can restore a database from the snapshot, just give DB Instance Identifier or any other setting you want to modify while restoring

* To Verify if Multi-AZ is enabled, Click on the particular DB

* Now let’s try to create read-replica again, as you can see Create read replica tab is now enabled

* The Important thing to remember we can create read replica in any other region

* Under the Settings tab, give it a unique name

### Using Terraform

Check: [**RDS.tf**](https://github.com/rufilboy/100DaysOfDevOps/blob/main/Day%2029%20-Introduction%20to%20RDS_MySQL/RDS.tf)