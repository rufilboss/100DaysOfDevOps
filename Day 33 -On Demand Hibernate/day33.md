* Why do we need On Demand Hibernate

    * EC2 Instance can be up in a matter of a second, but booting OS and Application sometimes take several minutes
    * Warming up cache can take several minutes
    * Hibernate stores the in-memory state of the instance(along with Private and Elastic IP)
    * Pick up exactly where you left off
    * Supported instance type(M3, M4, M5, C3, C4, C5, R3, R4, and R5)
    * Supported OS(Amazon Linux 1)
    * Amazon Linux 2(work in progress), No support for Centos family :(. (Coming soon: Amazon Linux 2, Ubuntu, Windows Server 2008 R2, Windows Server 2012, Windows Server 2012 R2, Windows Server 2016, along with the SQL Server variants of the Windows AMIs)
    * Support for on-demand and reserved instance
