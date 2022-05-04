#!/bin/dash
echo "### Removing docker ###"
apt-get remove docker docker-engine docker.io containerd runc
echo .
echo .
echo "### Update and install deps ###"
apt-get update && apt-get install -y gnupg software-properties-common curl ca-certificates gnupg lsb-release
echo .
echo .
echo "### Seting up stable repo ###"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo .
echo .
echo "### Update deps ###"
apt-get update
echo .
echo .
echo "### Installing Docker ###"
yes | apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
echo .
echo .
echo "### Bulding nginx-custom-content Image ###"
docker build --no-cache -t nginx-custom-content .