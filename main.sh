#!/bin/dash

echo "### Update and install deps ###"
apt-get update && apt-get install -y gnupg software-properties-common curl ca-certificates gnupg lsb-release unzip
echo .
echo .
terraform -help > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "### Terraform is not installed. Installing"
    apt-get install terraform
fi
echo .
echo .
aws --help > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "### AWS CLI is not installed. Installing"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
    
fi

echo .
echo .
echo "### Initiating AWS configuration###"
aws configure
echo .
echo .
cd ./IAC
echo "### Initiating Terraform ###"
terraform init
echo .
echo .
echo "### Terraform Planing ###"
terraform plan
echo .
echo .
echo "### Applying Terraform Plan ###"
terraform apply
echo .
echo .