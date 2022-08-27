* What is the Pipeline?

    * A pipeline is typically referred to as a part of Continuous Integration and it’s mostly used to merge developer changes into code mainline.

* Why do we need a pipeline?

    * Test changes before pushing to Production
    * Another pair of eyes in terms of approval
    * Logging to see who and when someone pushed the changes
    * Separate workspace/tfstate for Development and Production Environment

* Pipeline Architecture

![Pipeline Architecture](https://miro.medium.com/max/1400/1*i8mcxAZfcSkZ_88CGAA6pw.jpeg)

* How Jenkins Terraform Pipeline Works?

    * User push their code changes to GitHub
    * Code change trigger a Git Webhooks which triggers the terraform pipeline

* Setting up Jenkins on Ubuntu 22.04

    * Update Ubuntu 22.04

    ```sh
    $ sudo apt update && sudo apt upgrade
    ```

    * Install OpenJDK

    ```sh
    $ sudo apt install default-jdk
    ```

    * Add Jenkins GPG key on Ubuntu 22.04

    ```sh
    $ sudo mkdir -p /usr/share/keyrings
    ```

    ```sh
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    ```