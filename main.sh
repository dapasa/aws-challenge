#!/bin/dash
echo "### Update and install deps ###"
apt-get update && apt-get install -y gnupg software-properties-common curl ca-certificates gnupg lsb-release
echo .
echo .
echo "### Seting up stable repo ###"
yes | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo .
echo .
echo "### Update deps ###"
apt-get update
echo .
echo .

docker ps > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "### Docker is not installed in the system. Installing... ###"
    yes | apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo service docker start
    docker ps > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "### A problem ocurred while trying to check the docker service runnin."
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

echo "### Bulding nginx-custom-content Image ###"
docker build --no-cache -t nginx-custom-content .