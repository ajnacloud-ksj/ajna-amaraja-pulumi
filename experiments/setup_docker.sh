#!/bin/bash

# Update and upgrade the system
sudo apt-get update && sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Add the current user to the Docker group
sudo usermod -aG docker $USER

# Check if the development directory exists, and create if it doesn't
if [ ! -d "$HOME/development" ]; then
  echo "Creating development directory..."
  mkdir ~/development
fi

# Set permissions (chown) for the development folder
sudo chown -R $USER:$USER ~/development

# Modify the ~/.bashrc file to ensure docker group membership is refreshed on login
if ! grep -q "newgrp docker" ~/.bashrc; then
  echo -e "\n# Automatically refresh docker group membership on login\nif ! groups | grep -q '\\bdocker\\b'; then\n  newgrp docker\nfi" >> ~/.bashrc
fi

# Reload the ~/.bashrc file to apply changes immediately
source ~/.bashrc

# Display installed versions
docker --version
docker-compose --version

# Reminder to log out and log back in
echo "Docker and Docker Compose installed successfully!"
echo "Log out and log back in to apply group membership changes."
