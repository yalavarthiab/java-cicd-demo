#!/bin/bash
set -eux

REGION=us-east-1
AWS_ACCOUNT_ID=REPLACE_WITH_AWS_ACCOUNT_ID

# install dependencies
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl gnupg lsb-release unzip jq

# install Docker (official)
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# add ubuntu to docker group
usermod -aG docker ubuntu

# install awscli v2 if not present
if ! command -v aws >/dev/null 2>&1; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  apt-get install -y unzip
  unzip /tmp/awscliv2.zip -d /tmp
  /tmp/aws/install
fi

# ECR login (works with instance role that has ECR read)
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com || true

# Create a docker-compose (placeholders; CI will replace REPLACE_ECR_* names)
cat > /home/ubuntu/docker-compose.yml <<'EOF2'
version: "3.8"
services:
  python:
    image: REPLACE_ECR_PY_IMAGE:latest
    restart: always
    ports:
      - "8000:8000"

  java:
    image: REPLACE_ECR_JAVA_IMAGE:latest
    restart: always
    ports:
      - "8080:8080"
    environment:
      - PYTHON_SERVICE_URL=http://python:8000/api/time
EOF2

chown ubuntu:ubuntu /home/ubuntu/docker-compose.yml

# Pull images (if available) and start
cd /home/ubuntu || exit 0
docker compose pull || true
docker compose up -d || true
