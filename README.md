Cloud Workspace for tes
=============================
Workspace is a collection of tools and resources that can help you to build and deploy your application in the cloud. 

- [GitHub Repository](#GitHub-Repository)
  - [Repository Structure](#Repository-Structure)
    - [.github](#.github)
      - [CODEOWNERS](#CODEOWNERS)
      - [PULL_REQUEST_TEMPLATE](#PULL_REQUEST_TEMPLATE)
      - [workflows](#workflows)
    - [ci](#ci)
    - [examples](#examples)
    - [terraform](#terraform)
- [Terraform Enterprise](#Terraform-Enterprise)
  - [Workspace](#Workspace)
  - [Access](#Access)
- [Jenkins Artifacted Pipeline](#Jenkins-Artifacted-Pipeline)
  - [Development Process](#Development-Process)
- [Artifactory](#Artifactory)
- [Monitoring](#Monitoring)
- [Secret Management](#Secret-Management)
- [Required Tags](#Required-Tags)
- [Support](#Support)
  - [ServiceNow](#ServiceNow)
  - [Incidents](#Incidents)
- [Quick Links](#Quick-Link)

----------------------------------

# GitHub Repository
This github repository is owned by you. We set it up with best practices based on Lululemon standards but you are empowered to make any changes to meet your needs. Access settings of your repository and change things like branch protection to best suit your requirements.

* Do not commit sensitive information such as AWS credentials, Terrafrom Enterprise Token or your application secrets into your repository. If you did, removing them will not delete them as git will keep the history of it. Follow [this guide](https://help.github.com/en/github/authenticating-to-github/removing-sensitive-data-from-a-repository) to remove them permanently.

## Repository Structure
This repository structured like this: 
```
├── .github
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows
│       └── terraform.yml
├── .gitignore
├── README.md
├── ci
│   └── jenkins
│       └── terraform
│           └── app
│               └── Jenkinsfile
├── examples
│   ├── ...
│   └── README.md
└── terraform
    └── app
        ├── common.auto.tfvars
        ├── env
        │   ├── us-east-1-dev
        │   │   └── us-east-1-dev.auto.tfvars
        │   ├── us-east-1-qas
        │   │   └── us-east-1-qas.auto.tfvars
        │   ├── remote.tf
        │   ├── ...
        │   │   
        │   ├── us-east-1-sbx
        │   │   └── us-east-1-sbx.auto.tfvars
        ├── main.tf
        ├── outputs.tf
        ├── variables.tf
        └── vpc.tf
```

### .github
This directory holds files related to Github.

#### CODEOWNERS
you can use this file to control who owns the files in a certain path and the pull requests cannot be merged without their approvals. By default your github team owns all the files. You can modify this file to allow other teams to own part of your code. You can look at [this guide](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners) for syntax.

#### PULL_REQUEST_TEMPLATE
You can use this file to provide a template for users when they are submitting a pull request to gather some information like Jira ticket reference and a summary of changes. It is a good way to have some reference to changes for better review and auditing.

#### workflows
This directory controls [GitHub Actions](https://help.github.com/en/actions). It is a good way to run some code scanning or linting on pull requests before merging it to master. As a starting point we have included a github actions for your Terraform code.

It uses [hashicorp/setup-terraform](https://github.com/hashicorp/setup-terraform) to run `terraform fmt` command to make sure your code follows the standards. It also runs [TFSec](https://github.com/reviewdog/action-tfsec) to make sure your code follows some security practices. By default it is set to be advisory and does not block merging pull requests but you can enforce the checks by changing your branch protection settings of your repository.

### ci
This directory is meant for your continues integration configs. By default it includes a Jenkinsfile that your [Jenkins artifacted pipeline](#Jenkins-Artifacted-Pipeline) uses.

### examples
We have included some real world examples in your repository to get you started. Read the comments and make sure you change some of the arguments to meet your needs.

### terraform
This directory contains all the Terraform codes that represent your infrastructure. In this setup you use the same code to provision resources in different environment. There are different variable files for each environments. The common variables can be put in `common.auto.tfvars`. You can also use Terraform [conditional expressions](https://www.terraform.io/docs/configuration/expressions.html#conditional-expressions) to create some resources conditionally.

We recommend [VS Code](https://code.visualstudio.com/) with terraform plugin.

----------------------------------

# Terraform Enterprise
We use Terraform Enterprise to control terraform runs. It also versions and stores the terraform states.

## Workspace
Each environment has its own Terraform Enterprise Workspace. If you need to add a new environment, you can request it by creating a pull request in [this repository](https://github.com/Lululemon/sharedservices-portal/blob/master/tfe/workspaces/).

## Access
To get access to TFE, please follow [this guide](https://lululemon.atlassian.net/wiki/spaces/GSS/pages/889378525/Getting+Access+to+Terraform+Enterprise)

`tes-admin` Terraform team has been created for your project. Create a PR to add team members in [sharedservices-portal](https://github.com/Lululemon/sharedservices-portal/blob/master/tfe/workspaces/team_members.tf). This team already has admin access to all of the workspaces for your project.

```hcl

data "tfe_team" "tes-admin" {
  name         = "tes-admin"
  organization = tfe_organization.lululemon.id
}

resource "tfe_team_members" "tes-admin" {
  team_id = data.tfe_team.tes-admin.id

  usernames = [
    "<team member AD username>",
  ]
}
```

----------------------------------

# Jenkins Artifacted Pipeline
Your cloud workspace comes with an artifacted pipeline. It is a GitOps workflow with Terraform and Jenkins.

## Development Process
- Deploying in Sandbox (sbx) environment: Create a new branch -->  Make changes --> Commit and push to your branch --> Run the sandbox job --> *Make changes if needed, push and deploy again in sandbox*
- Deploying in Dev environment: Create a pull request from your branch --> Merge to master after approval from your teammates --> Run the dev job to deploy
- Deploying in higher environments: Run the deploy job for the environment (QAS, STG, PRD) by choosing the artifact to deploy

You start with developing and testing your code in the sandbox environment. Sandbox job runs from any branch and does not require any approvals. This allows quick development and iterating over your code till you are ready.

Dev environment runs from your repository master branch. After it's been successfully deployed, Jenkins will artifact your repository and Push it to your [Artifactory](#Artifactory) repository.

Higher environment jobs, allow you to view and pick which artifact you want to deploy. This ensures that you are deploying the exact code as you have deployed in dev. It also makes rolling back to other versions much easier.

We use [Vault](#Secret-Management) to dynamically provide AWS credentials for the Terraform runs in Jenkins.

For getting access to your Jenkins folder and jobs, you can use [this ServiceNow request](https://luluprod.service-now.com/sp/?id=sc_cat_item&sys_id=23cc43e61bcc0c506b3233f8cd4bcb6c&sysparm_category=b92652a21b880c506b3233f8cd4bcb15).


----------------------------------
# Artifactory
[JFrog Artifactory](https://jfrog.com/) offers a universal solution supporting all major package formats including Maven, Gradle, Docker, Go, Helm, PyPI, ...
As part of your Cloud Workspace you will get a generic Artifactory repository that you can store generic binaries and we use it to store your pipeline artifacts. A service user has also been created with permissions to publish to your generic repository.

- Your Artifactory CI User: svc-tes-ci
- Your Artifactory Generic Repository: tes

> **Note:** You can find credentials for your service user in your Jenkins folder credentials as well as your app team Vault KV so you can also use this service user in any other CI.

You can create other type of repositories for your artifacts such as docker registry, maven or helm by creating a pull request in [sharedservices-portal](https://github.com/Lululemon/sharedservices-portal/tree/master/artifactory) repo. Please look at the examples and other pull requests.

Here is an example of adding a docker registry and granting your service user to publish to it.
```hcl
resource "artifactory_local_repository" "tes-docker" {
  key                = "tes-docker"
  package_type       = "docker"
  property_sets      = ["artifactory"]
  docker_api_version = "V2"
  description        = "Docker Images for tes"
}

resource "artifactory_local_repository" "tes-helm" {
  key           = "tes-helm"
  package_type  = "helm"
  property_sets = ["artifactory"]
  description   = "Helm Charts for tes"
}

resource "artifactory_local_repository" "tes-maven-release" {
  key           = "tes-release"
  package_type  = "maven"
  property_sets = ["artifactory"]
  description   = "Maven release repository for tes"
}

resource "artifactory_permission_target" "tes-deployer" {
  name = "tes-deployer"

  repo {
    includes_pattern = ["**"]

    repositories = [
      artifactory_local_repository.tes-docker.key,
      artifactory_local_repository.tes-helm.key,
      artifactory_local_repository.tes-maven-release,
    ]

    actions {
      users {
        name        = "tes-ci"
        permissions = ["annotate", "write", "read", "delete"]
      }
    }
  }
  build {
    repositories     = ["artifactory-build-info"]
    includes_pattern = ["**"]

    actions {
      users {
        name        = "svc-tes-ci"
        permissions = ["annotate", "write", "read", "delete"]
      }
    }
  }
}
```
If you need your repositories be accessible without authentication, make sure you add them to the `public` artifactory permission target in [permission.tf](https://github.com/Lululemon/sharedservices-portal/blob/master/artifactory/permissions.tf).

For team member's access to Artifactory for managing your repositories (manually uploading to repositories or deleting artifacts) you can use [this ServiceNow request](https://luluprod.service-now.com/sp/?id=sc_cat_item&sys_id=c1e248c01b510c506b3233f8cd4bcb83&sysparm_category=b92652a21b880c506b3233f8cd4bcb15).

----------------------------------
# Monitoring
Cloud Platform team has implemented a shared [Prometheus](https://prometheus.io) server stack for collecting metrics and alerting. We also offer [Grafana](https://grafana.com/) for visualization of your metrics by creating dashboards. You can follow [this guide](https://lululemon.atlassian.net/wiki/spaces/GSS/pages/1107319930/Prometheus+at+lululemon) to leverage them.

For Grafana access you can follow [this](https://luluprod.service-now.com/sp/?id=sc_cat_item&sys_id=835247a21b8c0c506b3233f8cd4bcbb9&sysparm_category=b92652a21b880c506b3233f8cd4bcb15).

----------------------------------
# Secret Management
The pipeline already uses [Vault by HashiCorp](https://www.vaultproject.io/) AWS secret engine to provide dynamic AWS credentials for your Terraform runs. If you would like to leverage it more for sharing secrets between your team or to deliver secrets to your application, you can follow [this guide](https://lululemon.atlassian.net/wiki/spaces/GSS/pages/857408179/Hashicorp+Vault+at+lululemon).

Two [Vault KV](https://www.vaultproject.io/docs/secrets/kv/kv-v2) has been created as part of your Cloud workspace. One is `app-tes-kv` for storing static secrets such as API keys that your application need to access and `tes-kv` for your team to share secrets such as SSH keys or admin credentials.

By default you do not have access to these KVs but you can set up Vault for your project by creating a pull request in [vault-env](https://github.com/Lululemon/vault-env#vault-env) repository. You can see [this PR](https://github.com/Lululemon/vault-env/pull/571/files) as an example but always read the documentation and comments before creating your PR. Make sure you set the `group_type` to `workspace`.

----------------------------------
# Required Tags
For cost tracking and identifying resources, all applicable resources should be tagged. You can find the list of all tags including mandatory tags [here](https://lululemon.atlassian.net/wiki/spaces/CP/pages/584450823/Resource+Tagging+Strategy). There is already a local variable 

----------------------------------

# Support
Please ensure you have done your due diligence to understand and try to solve your issues before contacting support. This includes: 
  * Reading our [documentations](https://lululemon.atlassian.net/wiki/spaces/GSS/pages/849903957/Cloud+Applications+Overview).
  * Reading official tools documentations:
    * [Terraform](https://www.terraform.io/docs/index.html), [Terraform AWS Resources](https://www.terraform.io/docs/providers/aws/index.html)
    * [Jenkins](https://www.jenkins.io/doc/)
    * [Artifactory](https://www.jfrog.com/confluence/display/JFROG/JFrog+Artifactory)
    * [Vault](https://www.vaultproject.io/docs/what-is-vault)
    * [GitHub](https://help.github.com/en/github)
  * Searching for a solution online
  * Asking if others have already solved this in the [cloud-collaboration](https://teams.microsoft.com/l/channel/19%3acdcf0e9ad8fc443eb6413a98d383d06a%40thread.tacv2/Cloud%2520Collaboration?groupId=26d85ff0-cc15-4d09-8fcf-1c854df7a8ae&tenantId=59762c14-55e8-4b58-806e-f6cc47d75b19) channel on Lululemon Teams.

##  ServiceNow
If you still need assistance from Cloud Platform team you can look for ServiceNow requests [here](https://luluprod.service-now.com/sp/?id=sc_category&sys_id=b92652a21b880c506b3233f8cd4bcb15&catalog_id=e0d08b13c3330100c8b837659bba8fb4). If you could not find a relevant item, you can open a [General Cloud Request](https://luluprod.service-now.com/sp/?id=sc_cat_item&sys_id=e86c7d71db254450ee30a4cb0b9619e4&sysparm_category=b92652a21b880c506b3233f8cd4bcb15)

##  Incidents
If you feel something is broken or not working (i.e Jenkins is not loading, Artifactory not responding, ...), please first check our [status page](https://sharedservices-status.aws.lllint.com/) which shows overall health of shared services systems. You can always open an [incident ServiceNow request](https://luluprod.service-now.com/sp/?id=sc_cat_item&sys_id=7803b3f21b781c505df621fcbc4bcb9e&sysparm_category=b92652a21b880c506b3233f8cd4bcb15) if you feel like there is an issue with the system and it is blocking you from operating.

----------------------------------
# Quick Links
Most of services are only accessible within Lululemon's network and require VPN if you are connecting outside of the office while some of them can be accessed without VPB and from [myapps dashboard](https://account.activedirectory.windowsazure.com/r?whr=lululemon.com#/applications).
- [Jenkins](https://jenkins.lululemon.app/)
- [Terraform Enterprise](https://terraform.lululemon.app/)
- [Artifactory](https://arti.lululemon.app/)
- [Grafana](https://grafana.lululemon.app/)
- [Prometheus](https://prometheus.aws.lllint.com/)
- [Alertmanager](https://alertmanager.aws.lllint.com/)
- [Vault](https://vault.lllint.com/)

----------------------------------
> **Note:** This file has been generated automatically from [this template](https://github.com/Lululemon/cloud-workspace-templates/tree/master/aws) at the time of provisioning your workspace. You can watch that repository for updates on workspaces. Feel free to modify your Readme file to present your application.   
