* How to Audit your AWS environment using tools like

    * AWS Trusted Advisor
    * Scout2

* What is AWS Trusted Advisor

    * AWS Trusted Advisor is an online tool that provides you real time guidance to help you provision your resources following AWS best practices.

* Go to Trusted Advisor → [**here**](https://console.aws.amazon.com/trustedadvisor)

    * Green: No issue or concern found
    * Yellow: Investigation is recommended
    * Red: Critical action recommended

* If you further expand the Trusted Advisor page and explore the details, anything which is not in red will list the criteria for details and recommended actions

* Open the security group, which is highlighted in red
* Change the Port 21 to only listen to your company IP range
* Refresh the security advisor and as you can see port 21 is no longer appear

###### NOTE: You can only refresh the status every 5 min, so if the refresh button is greyed out please wait for 5 min.

