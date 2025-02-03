# simple-terraform-proj-Statefile
This is a simple Terraform project where I am creating local and remote state files. 
Welcome to the simple-terraform-proj-Statefile wiki!

# Why Terraform? Why not Cloud Formation template?
* We configure terraform provider as AWS, and based on the configuration files terraform converts them into the APIs that AWS can understand.
* Here target API is AWS. Using Terraform we can manage any kind of infrastructure on any Cloud. 
* With Terraform we can track the infrastructure, without everytime logging into the AWS Cloud account. We can keep track of Infrastructure.
* With terraform, we can automate change to infrastructure/resources already deployed on to AWS. 
* We can put terraform files (except state file) into git repo, whenever we have to modify the resources deployed, we can just modify that in terraform code in git repo, we can collaborate with our peers, can raise a PR , once they check modified code and accept it, we can deploy the change.
* Strandardize configuration 

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

![terraform_2](https://github.com/user-attachments/assets/46350c69-515f-43b9-b124-d9c10955b63c)


## Terraform commands

```
terraform init
terraform plan
terraform apply
terraform destroy
```

**Terraform init** :- Initializes the Terraform. Navigate to the folder with terraform file and initialize terraform there. Terraform initializes the AWS provider based on the instructions in main.tf file. We can communicate with that provider and create resources.

**Terraform Dry run - Terraform Plan**

* We can use Terraform plan to see the list of resources that will be created. and aply give **"Terraform Apply"** once the resources plan is finalized. 

### main.tf file 
* All the provider details, resource details should be put into main.tf file 


### Input.tf file
All the sensitive information like VPC, Security groups details should not be put in main.tf file, it should be there in input.tf file

### variables.tf file
* Instead of hard-coding resource configurations, we can use variables.tf file to put the variable details

### outputs.tf
* we can use output.tf file to print the resource details which is created. This will be useful for someone who wants to use the resource who does not have access to AWS Console/AWS account.  

## Terraform Installation

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## Install AWS CLI
* Its a pre-requisite for terraform that, when we are configuring terraform with AWS, we should authenticate cloud provider with CLI. I am using Linux VM to setup with terraform and apply the scripts to create resources in AWS. 
* So using AWS CLI, authenticate AWS cloud by providing access key and secret access key. 

### Install AWS CLI

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
### Create an AWS Credentials File
```
cd aws
vim credentials                 // create a credentials file

aws_access_key_id=YOUR_ACCESS_KEY
aws_secret_access_key=YOUR_SECRET_KEY

cat credentials
```

I created a local state file and a remote state to see the difference

## terraform state file - terraform.tfstate
* Terraform completely relies on it. State file has complete information of all resources that are created by terraform on AWS. 
* If the state file is deleted, terraform lose its tracking on what resources are created. 
* Terraform tracks the AWS infra using " state file " . It keeps track of all the created resources.
* terraform state file is not pushed to git repo. So sharing a state file is a critical problem. It cannot be shared through git repo as it has all the sensitive information. 
* So to avoid this put the state files remotely, not locally. 
* Do not manipulate the state files locally. terraform state file gets corrupted. state file should have read permissions only. 
* Terraform should only update the state file. 
* Terraform files should be stored in github repo. 
* We can create jenkins pipeline, which gets triggered whenever a terraform file is updated with resource configuration in github and jenkins executes the files and created AWS resources. 
* Using output.tf, we can get the information of the resources created get printed.

### Storing state file remotely: Remote Backend
* ** State file should be stored in AWS S3**, this is the ideal approach.  
* The advantage of storing state file in S3 which is a centralized location, whenever someone changes the terraform scripts and executed it, terraform automatically updates state file in centralized location which is S3 bucket. 
* If 2 or multiple people are trying to execute terraform scripts parallely, it creates conflict in creating resources. So terraform cannot decide which user script to execute first.
* So avoid this, we can follow this approach. 

### State file locking
* Integrate remote backend to Dynamo DB, which is used to locking the state file. This is the locking solution.
* So when multiple users are trying to execute the same script, terraform picks the first request and starts the execution and locks the state file until that execution is done, so that another usr request to execute the script does not conflict. 
* Once the lock on the state file removed , then only another person execution is carried out by terraform. 
* So using Dynamo DB , terraform does not allow parallel execution of terraform script by multiple users.

**S3 + Dynamo DB - Ideal solution **

Another important usecase of Terraform 
* Isolate terraform state files for different environments like Dev, QA, Pre-Prod, PROD. 


## Terraform Modules
* Modules is a way of writing reusable components.
### Existing Modules
* Any re-usable code can be used as Modules for other terraform scripts. 
* Once we reference some re-usable code as modules, we can use these modules in some other terraform scripts. 
* Terraform, before executing the script, it executes modules. This saves lot of time and effort in writing repeated code. 
* Existing modules are the current modules that terraform offers in its documentation. 
 



