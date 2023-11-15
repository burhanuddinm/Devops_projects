#!/bin/bash

# Update package lists and upgrade existing packages
sudo apt update
sudo apt upgrade -y

# Install Docker
if ! command -v docker &> /dev/null; then
    # Install required dependencies
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker repository and GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Add your user to the Docker group to run Docker without sudo
    sudo usermod -aG docker $USER

    # Start and enable the Docker service
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Docker installed successfully."
else
    echo "Docker is already installed."
fi

# Install Node.js and npm
if ! command -v node &> /dev/null; then
    # Install Node.js LTS
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null
    sudo apt update
    sudo apt install -y nodejs

    # Print Node.js and npm versions
    node -v
    npm -v

    echo "Node.js and npm installed successfully."
else
    echo "Node.js and npm are already installed."
fi

# Run Docker Image for Birthday Count 

# Replace "<image>" with the actual image name or ID
IMAGE_NAME="burhandm/birthday-app:v1"

# Run the Docker container
docker run -d -p 80:80 $IMAGE_NAME
