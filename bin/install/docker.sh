#!/bin/bash
# Setup Docker on the bastion host

#1. Install & start Docker
sudo amazon-linux-extras install docker -y
sudo service docker start

#2. Setup the user for docker
sudo usermod -a -G docker ec2-user
sudo service docker restart

#3. Set chkconfig on for docker
sudo chkconfig docker on

#3. Echo message for start | stop PgAdmin4
echo "Docker Installation Done."
echo "PLEASE Log out and Log back in before next action!!!"
