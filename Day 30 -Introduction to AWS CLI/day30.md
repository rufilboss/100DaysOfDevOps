###### What is AWS CLI?

* The AWS Command Line Interface (AWS CLI) is a unified tool that provides a consistent interface for interacting with all parts of AWS.

* The AWS CLI is an open source tool built on top of the AWS SDK for Python (Boto) that provides commands for interacting with AWS services. With minimal configuration, you can start using all of the functionality provided by the AWS Management Console from your favorite terminal program.

* Install Command line interface on Linux

* Requirements

    * Python 2 version 2.6.5+ or Python 3 version 3.3+
    * Windows, Linux, macOS, or Unix
    * We can install aws command line interface and its dependencies with the help of pip(package manager for python)
    * To install pip, we first need to install EPEL(Extra Package for Enterprise Linux) [**here**](https://fedoraproject.org/wiki/EPEL)

```sh
$ apt -y install epel-release
```

* Followed by python-pip installation
```sh
$ apt -y install python2-pip
```

* Now install awscli

```sh
#CMD
$ pip install awscli
#Output
Collecting awscli
Downloading https://files.pythonhosted.org/packages/c2/1e/f70d1125f5bf6383d2ee7a76aea72bed6ba103c1bb9dd4ca051787552d2b/awscli-1.15.24-py2.py3-none-any.whl (1.3MB)
100% |████████████████████████████████| 1.3MB 1.1MB/s
Requirement already satisfied (use --upgrade to upgrade): docutils>=0.10 in /usr/lib/python2.7/site-packages (from awscli)
Requirement already satisfied (use --upgrade to upgrade): PyYAML<=3.12,>=3.10 in /usr/lib64/python2.7/site-packages (from awscli)
Collecting botocore==1.10.24 (from awscli)
Downloading https://files.pythonhosted.org/packages/65/98/12aa979ca3215d69111026405a9812d7bb0c9ae49e2800b00d3bd794705b/botocore-1.10.24-py2.py3-none-any.whl (4.2MB)
100% |████████████████████████████████| 4.2MB 339kB/s
Requirement already satisfied (use --upgrade to upgrade): s3transfer<0.2.0,>=0.1.12 in /usr/lib/python2.7/site-packages (from awscli)
Requirement already satisfied (use --upgrade to upgrade): rsa<=3.5.0,>=3.1.2 in /usr/lib/python2.7/site-packages (from awscli)
Requirement already satisfied (use --upgrade to upgrade): colorama<=0.3.9,>=0.2.5 in /usr/lib/python2.7/site-packages (from awscli)
Requirement already satisfied (use --upgrade to upgrade): jmespath<1.0.0,>=0.7.1 in /usr/lib/python2.7/site-packages (from botocore==1.10.24->awscli)
Requirement already satisfied (use --upgrade to upgrade): python-dateutil<3.0.0,>=2.1; python_version >= "2.7" in /usr/lib/python2.7/site-packages (from botocore==1.10.24->awscli)
Requirement already satisfied (use --upgrade to upgrade): futures<4.0.0,>=2.2.0; python_version == "2.6" or python_version == "2.7" in /usr/lib/python2.7/site-packages (from s3transfer<0.2.0,>=0.1.12->awscli)
Requirement already satisfied (use --upgrade to upgrade): pyasn1>=0.1.3 in /usr/lib/python2.7/site-packages (from rsa<=3.5.0,>=3.1.2->awscli)
Requirement already satisfied (use --upgrade to upgrade): six>=1.5 in /usr/lib/python2.7/site-packages (from python-dateutil<3.0.0,>=2.1; python_version >= "2.7"->botocore==1.10.24->awscli)
Installing collected packages: botocore, awscli
Found existing installation: botocore 1.10.11
Uninstalling botocore-1.10.11:
Successfully uninstalled botocore-1.10.11
Successfully installed awscli-1.15.24 botocore-1.10.24
```
* To upgrade cli

```sh
$ pip install awscli --upgrade
```
* To verify aws cli installed sucessfully
```sh
$ aws --version
aws-cli/1.15.24 Python/2.7.5 Linux/3.10.0-693.el7.x86_64 botocore/1.10.24
```

* Diving into AWS world using command line tool and the first command we are going to use is aws configure which is going to configure settings that aws command line interface uses when interacting with aws(this include security credentials and default region)

* Before using aws configure we must need to sign up for aws account and download security credentials. If we don’t have access keys we can generate it from aws management console, go to IAM(under Security, Identity & Compliance)

