# Jenkins

Jenkins installation with master and one slave-node. The pipelines download, build and deploy applications [hello](https://github.com/morion-devops/hello) and [cpu-load](https://github.com/morion-devops/cpu-load) to [Kubrernetes](https://github.com/morion-devops/kubernetes) cluster. Pipelines runs automatically when a new commit pushes in the master branch (via Github-webhooks).

Part of my [devops portfolio](https://morion-devops.github.io/).

## How to provisioning:
1. Select provisionin way: GCP or Vagrant
1. `cp .env.example .env`
1. Setup variables in `.env` until Jenkins section (this section you will setup later)
1. Apply it: `source .env`
1. Run `terraform apply` or `vagrant up` in appropriate directory depending on your provisioning way
1. Check `ansible/ansible.cfg` file and uncomment lines for GCP or Vagrant
1. Run `ansible-playbook playbook-1-install.yaml` in ansible directory

## Configure after provisioning:

*To setup Jenkins after provisioning, follow this instructions:*

1. Go to Jenkins ip-address in browser and activate it. Adm password stored in `/var/lib/jenkins/secrets/initialAdminPassword` file on master-node.

1. Do not install any plugins.

1. Create token for your user.

1. Fill Jenkins-section in `.env`-file

1. Apply it: `source .env`

1. Run: `ansible-playbook playbook-2-configure.yaml`
   
   There are some intructions in playbook (it will wait until configure credentials), so follow this instructions