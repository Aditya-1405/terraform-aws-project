#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt install -y unzip curl

# Install AWS CLI
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

# Fetch the bucket name from the passed variable
bucket=${bucket}
availability_zone=${availability_zone}

# Check the availability zone or subnet to decide which script to run
if [ "$availability_zone" == "ap-south-1a" ]; then
  # Run user_data for instances in ap-south-1a
  sudo aws s3 cp s3://${bucket}/user_data.sh /home/ubuntu/user_data.sh
  sudo chmod +x /home/ubuntu/user_data.sh
  sudo bash /home/ubuntu/user_data.sh
elif [ "$availability_zone" == "ap-south-1b" ]; then
  # Run user_data1 for instances in ap-south-1b
  sudo aws s3 cp s3://${bucket}/user_data1.sh /home/ubuntu/user_data1.sh
  sudo chmod +x /home/ubuntu/user_data1.sh
  sudo bash /home/ubuntu/user_data1.sh
fi
