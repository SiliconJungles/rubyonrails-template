#!/bin/bash
sudo yum -y update
sudo yum -y install unzip

echo "AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "Login ECR"
aws ecr get-login-password --region ap-southeast-1 \
  | docker login --username AWS --password-stdin ${ecr_stdin}

# create the local file
mkdir -p /var/local
printf ${encrypted_secrets} >> /var/local/production.yml.enc
printf ${rails_master_key} >> /var/local/production.key

docker network create --attachable rails-default

docker run -d --name web \
  --network rails-default \
  -p 3000:3000 \
  --env DATABASE_USERNAME=${postgres_user} \
  --env DATABASE_PASSWORD=${postgres_password} \
  --env DATABASE_NAME=${postgres_db} \
  --env DB_HOST=${db_host} \
  --env VIRTUAL_HOST=${domain} \
  --env RAILS_MASTER_KEY=${rails_master_key} \
  --volume /var/local/${environment}.key:/app/config/credentials/${environment}.key \
  --volume /var/local/${environment}.yml.enc:/app/config/credentials/${environment}.yml.enc \
  --cap-drop ALL \
  ${ecr_stdin}/${app_name}-rails-api:${sha1}

docker run -d --restart unless-stopped --name nginx-proxy \
  --network rails-default \
  -p 80:80 \
  -p 443:443 \
  --env VIRTUAL_PORT=3000 \
  --volume /var/run/docker.sock:/tmp/docker.sock:ro \
  jwilder/nginx-proxy
