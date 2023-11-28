### ****Age Calculator and Birthday Countdown App****

-------------------------------------------------------------------------------------------
Project Details
-------------------------------------------------------------------------------------------
This project is a simple Age Calculator and Birthday Countdown web application that allows users to calculate their current age and find out how many days are left until their next birthday.

-------------------------------------------------------------------------------------------
Technologies Used
-------------------------------------------------------------------------------------------
Node.js
HTML

-------------------------------------------------------------------------------------------
Deployment Platform
-------------------------------------------------------------------------------------------
AWS EC2 Instance

-------------------------------------------------------------------------------------------
Operating System
-------------------------------------------------------------------------------------------
Ubuntu

-------------------------------------------------------------------------------------------
DevOps Tool 
-------------------------------------------------------------------------------------------
Terraform 
shell scripting

-------------------------------------------------------------------------------------------
Port Exposed
-------------------------------------------------------------------------------------------
The application is accessible on port 80.

-------------------------------------------------------------------------------------------
Docker Image
-------------------------------------------------------------------------------------------
You can use the following Docker image to run this application:

> $ docker pull burhandm/birthday-app:v1

-------------------------------------------------------------------------------------------
Getting Started
-------------------------------------------------------------------------------------------
To get started with the Age Calculator and Birthday Countdown App, follow these steps:

1. Pull the Docker image using the command provided above.
2. Run the Docker container on your AWS EC2 instance, mapping port 80 to the appropriate port on your EC2 instance.

> $ docker run -d -p 80:80 burhandm/birthday-app:v1

Access the application in your web browser by entering the EC2 instance's public IP or domain name in the address bar, followed by port 80.
MAKE SURE PORT 80 IS OPEN IN SG
