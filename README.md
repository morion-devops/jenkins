# Jenkins

Jenkins installation with master and one slave-node. The pipelines download, build and deploy applications [hello](../hello) and [cpu-load](../cpu-load) to [Kubrernetes](../k8s) cluster. Pipelines runs automatically when a new commit pushes in the master branch (via Github-webhooks).

Installation and configure take place in three stages:

1. Create VMs via Vagrant. Run `vagrant up` (*Soon, perhaps, Terraform will replase Vagrant*).
1. Provisioning via Ansible. Run `ansible-playbook playbook.yaml` to install Jenkins and all nedeed packages into machines.
1. Manually configure for instructions below (*Soon, perhabs, there will more automation for it*).

## Configure after provisioning:

*To prepare Jenkins after Ansible, follow this instruction:*

1. [Follow this link](http://192.168.121.102:8080) and activate Jenkins:

    Get adm password:
    ```sh
    vagrant ssh jenkins-master << EOF
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    EOF
    ```
1. Do not install any plugins.

1. Create token for your user.

1. Export variables:

    ```bash
    export JENKINS_USER_ID=<user>
    export JENKINS_API_TOKEN=<token>
    ```

1. Download CLI:

    - `wget http://192.168.121.102:8080/jnlpJars/jenkins-cli.jar`

1. Install plugins:

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ install-plugin ssh-credentials ws-cleanup git github ssh-slaves -restart`

1. Create templates for credentials:

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ -webSocket create-credentials-by-xml system::system::jenkins _ < credentials/ssh-key-github.xml`

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ -webSocket create-credentials-by-xml system::system::jenkins _ < credentials/ssh-key-node1.xml`

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ -webSocket create-credentials-by-xml system::system::jenkins _ < credentials/registry.xml`

1. Follow links and configure credentials:

    - [For github](http://192.168.121.102:8080/credentials/store/system/domain/_/credential/ssh-key-github/update)
    - [For node1](http://192.168.121.102:8080/credentials/store/system/domain/_/credential/ssh-key-node1/update) (To get key: `cat .vagrant/machines/jenkins-node1/libvirt/private_key`)
    - [For registry](http://192.168.121.102:8080/credentials/store/system/domain/_/credential/registry/update)

1. Create node:

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ create-node node1 < nodes/node1.xml`

1. Create tasks:

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ create-job hello-build < jobs/hello-build.xml`

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ create-job hello-deploy < jobs/hello-deploy.xml`

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ create-job cpu-load-build < jobs/cpu-load-build.xml`

    - `java -jar jenkins-cli.jar -s http://192.168.121.102:8080/ create-job cpu-load-deploy < jobs/cpu-load-deploy.xml`

## TODO

1. Consider pipelines
1. Use Ansible for automation that is possible