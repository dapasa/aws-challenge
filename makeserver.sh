#!/bin/dash

log=/var/log/infra_install.log

echo . >> $log 2>&1 
echo . >> $log 2>&1
echo "### Update and install deps ###" >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
apt-get update && apt-get install -y gnupg software-properties-common curl ca-certificates gnupg lsb-release >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
echo "### Seting up repos ###" >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >> $log 2>&1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo . >> $log 2>&1
echo . >> $log 2>&1
echo "### Update deps ###" >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
apt-get update >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
echo "### Docker is not working in the system. Checking... ###" >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
yes | apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin >> $log 2>&1
service docker start >> $log 2>&1
docker ps > /dev/null 2>&1
rc = $? 
if [ $rc -ne 0 ]; then
    echo . >> $log 2>&1
    echo . >> $log 2>&1
    echo "### A problem ocurred while trying to check the docker service running. ###" >> $log 2>&1
    echo . >> $log 2>&1
    echo . >> $log 2>&1 
fi
echo . >> $log 2>&1
echo . >> $log 2>&1
echo "### Making host folder for Docker volume ###" >> $log 2>&1
mkdir -p /var/www/html >> $log 2>&1
chmod 775 /var/www/html >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
echo "### Runing Docker container for nginx ###" >> $log 2>&1
docker run --name some-nginx -d -p 80:80 -v /var/www/html:/usr/share/nginx/html --restart=always nginx >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
echo "### Creating index.html ###" >> $log 2>&1
hostname=`hostname` >> $log 2>&1
echo "The page came from the hostname ${hostname}" | sudo tee /var/www/html/index.html >> $log 2>&1
echo . >> $log 2>&1
echo . >> $log 2>&1
echo "### Copying log for download ###" >> $log 2>&1
sudo cp $log /var/www/html/install.log
echo . >> $log 2>&1
echo . >> $log 2>&1