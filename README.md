# Pact | Devops challenge

### **Challenge:**

Create a web page in a Nginx server alocated in AWS public segment. This web page just need show a simple message.

Create a checker script for health check. 

#### **Challenge Rules**:
- The web page need to be public (Internet Facing) (Required)
- Runing over NGINX web server (Required)
- Make documentation for each step
- Automate with CloudFormation (Optional)
- Use Configuration managemente tool (Puppet, Chef or Ansible) (Optional)
- Load Balancer configuration (Optional)
- Run the NGINX server un dockerization (Optional)

### **Prerequisites**:

* [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
* [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* AWS Account - It will provide for the Author of it

### **Infrastructure configuration:**

In base of start to execute the infrastrcture configuration is required first set the AWS credentials

To start the AWS credentials configurations run:

```bash
aws configure
```
The aws configuration will ask you enter bellow information:

- AWS Access Key ID - Acces Key ID downloaded from the user account
- AWS Secret Access Key - Secret key downloaded from the user account
- Default region name - For the pourpose of this challenge it is recomended to use **es-east-1** region
- Default output format - For the pourpose of this challenge it is recomended to use **json** format

```bash
AWS Access Key ID [None]:
AWS Secret Access Key [None]:
Default region name [None]:
Default output format [None]:
```
After this the next step is iniciate the terraform project. To do that is required execute the following steps:

```bash
cd ./IAC
terraform init
```
This command will iniciate the instalation of the terraform modules and the initialization of terraform backend. 

```text
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v4.12.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
The previous message means you are ready to start the Terraform deploy.



#### **Based on Scripts:**



### **Checker Script Execution:**
