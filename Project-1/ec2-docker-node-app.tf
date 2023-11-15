variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1" # Set your desired AWS region
}

variable "existing_security_group_id" {
  description = "ID of the existing security group"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-06aa3f7caf3a30282" # Use the desired AMI ID
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  default     = "t2.micro"             # Set your desired instance type
}

variable "key_pair_name" {
  description = "Name of the existing key pair"
  default     = "access.key" # Replace with the name of your existing key pair
}

variable "git_repo_url" {
  description = "URL of the Git repository"
  default     = "https://github.com/burhanuddinm/Devops_projects.git"
}

variable "git_script_name" {
  description = "Name of the script in the Git repository"
  default     = "Project-1/src/docker_run.sh"
}

variable "script_directory" {
  description = "Directory where the script will be downloaded"
  default     = "/my_file"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_instance" "ec2_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  key_name = var.key_pair_name
  vpc_security_group_ids = [var.existing_security_group_id]

  user_data = <<-EOF
#!/bin/bash

# Define the Git repository URL and script file name
REPO_URL="${var.git_repo_url}"
SCRIPT_NAME="${var.git_script_name}"

# Define the directory where the script will be downloaded
SCRIPT_DIR="${var.script_directory}"

# Clone the Git repository to the specified directory
git clone $REPO_URL $SCRIPT_DIR

# Change to the script directory
cd $SCRIPT_DIR

# Make the script executable
chmod +x $SCRIPT_NAME

# Execute the script
./$SCRIPT_NAME

# Update the package manager and refresh packages
apt update
apt upgrade -y

EOF

  tags = {
    Name = "EC2" # Set the desired name for your EC2 instance
  }

  provisioner "local-exec" {
    command = "echo -n '${aws_instance.ec2_instance.public_ip}' > public_ip.csv"
  }
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}
