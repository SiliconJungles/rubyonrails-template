#!/bin/bash
sudo yum -y update
sudo yum -y install unzip
echo "AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws ecr get-login-password --region ap-southeast-1 \
  | docker login --username AWS --password-stdin ${ecr_stdin}

# create the local file
mkdir -p /var/local
printf ${encrypted_secrets} >> /var/local/${environment}.yml.enc
printf ${rails_master_key} >> /var/local/${environment}.key

docker pull ${ecr_stdin}/${app_name}-rails-api:staging

docker network create --attachable app-default

docker run -d --restart unless-stopped --name database \
  --network app-default \
  --env POSTGRES_DB=${db_name} \
  --env POSTGRES_USER=${db_user} \
  --env POSTGRES_PASSWORD=${db_password} \
  postgres:12.3-alpine

docker run -d --name web \
  --network app-default \
  -p 3000:3000 \
  --env DATABASE_USERNAME=${db_user} \
  --env DATABASE_PASSWORD=${db_password} \
  --env DATABASE_NAME=${db_name} \
  --env DB_HOST=database \
  --env VIRTUAL_HOST=${domain} \
  --env RAILS_MASTER_KEY=${rails_master_key} \
  --volume /var/local/${environment}.key:/app/config/credentials/${environment}.key \
  --volume /var/local/${environment}.yml.enc:/app/config/credentials/${environment}.yml.enc \
  --cap-drop ALL \
  ${ecr_stdin}/${app_name}-rails-api:staging

docker run -d --restart unless-stopped --name nginx-proxy \
  --network app-default \
  -p 80:80 \
  -p 443:443 \
  --env VIRTUAL_PORT=3000 \
  --volume /var/run/docker.sock:/tmp/docker.sock:ro \
  jwilder/nginx-proxy