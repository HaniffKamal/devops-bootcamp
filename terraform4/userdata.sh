#!/bin/bash
set -euxo pipefail

# Install Docker Engine and the Docker Compose plugin.
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker

# Ubuntu AWS AMIs ship the SSM agent as a snap; make sure it is running.
systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service || true

# Allow SSM sessions to run docker commands.
id ssm-user &>/dev/null || useradd -m ssm-user
usermod -aG docker ssm-user

# Deploy Rackula with server-side persistence.
# Official compose file: https://github.com/RackulaLives/Rackula/blob/main/deploy/docker-compose.persist.yml
mkdir -p /opt/rackula/data
cd /opt/rackula
curl -fsSL https://raw.githubusercontent.com/RackulaLives/Rackula/main/deploy/docker-compose.persist.yml -o docker-compose.yml

# The Rackula API container runs as UID 1001.
chown -R 1001:1001 /opt/rackula/data

docker compose up -d
