#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Install AWS CLI if not already installed
install_aws_cli() {
    if command_exists aws; then
        echo "AWS CLI is already installed."
    else
        echo "AWS CLI not found. Installing..."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm -rf awscliv2.zip aws
        echo "AWS CLI installation completed."
    fi
}

# Install Azure CLI if not already installed
install_az_cli() {
    if command_exists az; then
        echo "Azure CLI is already installed."
    else
        echo "Azure CLI not found. Installing..."
        curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
        echo "Azure CLI installation completed."
    fi
}

# Install Google Cloud CLI if not already installed
install_gcloud_cli() {
    if command_exists gcloud; then
        echo "Google Cloud CLI is already installed."
    else
        echo "Google Cloud CLI not found. Installing..."
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-506.0.0-linux-x86_64.tar.gz
        tar -xzf google-cloud-cli-506.0.0-linux-x86_64.tar.gz
        ./google-cloud-sdk/install.sh --quiet
        rm -rf google-cloud-cli-506.0.0-linux-x86_64.tar.gz
        source ./google-cloud-sdk/path.bash.inc
        echo "Google Cloud CLI installation completed."
    fi

    echo "Installing essential Google Cloud CLI components..."
    gcloud components install kubectl cloud-sql-proxy --quiet
    gcloud components update --quiet
    echo "Google Cloud CLI essential components installation completed."
}

# Main script
echo "Checking and installing tools if necessary..."
install_aws_cli
install_az_cli
install_gcloud_cli
echo "All tools have been checked and installed as necessary."
