provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1" # Set your desired AWS region
}

variable "existing_security_group_id" {
  description = "ID of the existing security group"
}

resource "aws_instance" "EC2" {
  ami           = "ami-06aa3f7caf3a30282" # Use the desired AMI ID
  instance_type = "t2.micro"             # Set your desired instance type

  key_name = "burhan_cf_tf" # Replace with the name of your existing key pair
  vpc_security_group_ids = [var.existing_security_group_id] # Reference the existing security group ID

  user_data = <<-EOF
#!/bin/bash

# Define the Git repository URL and script file name
REPO_URL="https://github.com/burhanuddinm/Shell_Scripts.git"
SCRIPT_NAME="docker&node.sh"

# Define the directory where the script will be downloaded
SCRIPT_DIR="/my_file"

# Clone the Git repository to the specified directory
git clone $REPO_URL $SCRIPT_DIR

# Change to the script directory
cd $SCRIPT_DIR

# Make the script executable
chmod +x $SCRIPT_NAME

# Execute the script
./$SCRIPT_NAME

#Update the package manager and refresh packages
apt update
apt upgrade -y


EOF

  tags = {
    Name = "EC2" # Set the desired name for your EC2 instance
  }


  provisioner "local-exec" {
    command = "echo -n '${aws_instance.EC2.public_ip}' > public_ip.csv"
  }
}

output "public_ip" {
  value = aws_instance.EC2.public_ip
}

# Define variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
