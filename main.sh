#!/bin/dash

DockerPgPFILE=/usr/share/keyrings/docker-archive-keyring.gpg

echo "### Update and install deps ###"
apt-get update && apt-get install -y gnupg software-properties-common curl ca-certificates gnupg lsb-release unzip
echo .
echo .
echo "### Seting up repos ###"
if [ ! -f "$DockerPgPFILE" ]; then
echo "########## Entro"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o ${DockerPgPFILE} 
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    echo .
    echo .
fi
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
echo .
echo .
echo "### Update deps ###"
apt-get update
echo .
echo .

docker ps > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "### Docker is not working in the system. Checking... ###"
    yes | apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo service docker start
    docker ps > /dev/null 2>&1
    rc = $? 
    echo $rc
    if [ $rc -ne 0 ]; then
        echo "### A problem ocurred while trying to check the docker service running."
        echo .
        echo . 
    fi
    echo .
    echo .
else
    echo "### Docker is installed in the system. ###"
    echo .
    echo .
fi
terraform -help > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "### Terraform is not installed. Installing"
    apt-get install terraform
fi

echo "### installing AWS CCLI ###"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

echo .
echo .
echo "### Bulding nginx-custom-content Image ###"
docker build --no-cache -t nginx-custom-content .