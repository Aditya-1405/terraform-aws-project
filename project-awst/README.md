# Terraform Project: AWS Infrastructure Deployment

## Overview
This project uses Terraform to provision and configure AWS infrastructure, including a Virtual Private Cloud (VPC), subnets, an internet gateway, a security group, an EC2 instance, an S3 bucket, and an application load balancer. After successful creation, a static HTML template is hosted on the EC2 instances.

## Prerequisites
1. Terraform is installed on your local machine.
2. AWS CLI installed and configured with appropriate permissions.
3. SSH key pair for accessing EC2 instances.
4. IAM permissions are required to create resources in AWS (e.g., VPC, EC2, S3, IAM).

## File Structure
- `ec2.tf`: Contains the Terraform configuration to launch ec2 instance.
- `vpc.tf` : Contains the configuration to create VPC and its components.
- `iam.tf`: Defines IAM roles, policies, and instance profiles.
- `variables.tf`: Declares input variables used in the Terraform configuration.
- `aws_install.sh`: Script to configure EC2 instances and interact with S3.

## Resources Created
1. **VPC**:
   - CIDR Block: 10.0.0.0/16
   - Name: Project-AWST-VPC
2. **Subnets**:
   - Public subnets with auto-assign public IP enabled.
   - Names: Project-AWST-Subnet-1, Project-AWST-Subnet-2
3. **Internet Gateway (IGW)**:
   - Name: Project-AWST-IGW
4. **Route Table**:
   - Routes traffic to the IGW for internet access.
   - Associated with subnets.
5. **Security Group**:
   - Allows SSH (port 22) and HTTP (port 80) traffic.
   - Name: Project-AWST-SG
6. **S3 Bucket**:
   - Name: awst-project-bucket-2024-<region>
   - Contains uploaded scripts (e.g., `user_data.sh`, `user_data1.sh`).
7. **EC2 Instances**:
   - Instance type: t2.micro
   - Deployed in public subnets.
   - IAM instance profile for S3 access.
   - User data script executed during initialization.
   - Hosts a static HTML template.
8. **Application Load Balancer (ALB)**:
   - Public-facing ALB with an HTTP listener.
   - Target group forwarding traffic to EC2 instances.

## Usage

### Step 1: Configure Variables
Update the `variables.tf` file as needed:
- `region`: AWS region (default: ap-south-1)
- `vpc_cidr_block`: CIDR block for the VPC
- `subnets_cidr_block`: List of CIDR blocks for subnets
- `availability_zone`: Availability zones for subnets
- `ami`: AMI ID for EC2 instances
- `instance_type`: EC2 instance type
- `key_pair`: Path to the SSH public key file

### Step 2: Initialize Terraform
Run the following command to initialize Terraform:

```sh
terraform init
```
### Step 3: Validate the Configuration
Validate the configuration to ensure there are no syntax errors:

```sh
terraform validate
```
### Step 4: Plan the Deployment
Review the execution plan to verify the resources to be created:

```sh
terraform plan
```
### Step 5: Apply the Configuration
Deploy the resources to AWS:

```sh
terraform apply
```
### Step 6: Access the Resources
- Use the output `instance_public_ips` to access the EC2 instances via SSH.
- Use the output `lb_dns` to access the application load balancer and view the hosted static HTML template.

### Step 7: Destroy the Resources
To clean up the resources created by Terraform:

```sh
terraform destroy
```
## Notes
- Ensure the SSH key file path in `variables.tf` is correct.
- The S3 bucket name must be globally unique; modify it if needed.
- Update `aws_install.sh` with additional configuration as required.
- IAM policies are scoped to allow only EC2 instances access to the S3 bucket.

## Outputs
- `instance_public_ips`: Public IP addresses of the EC2 instances.
- `lb_dns`: DNS name of the application load balancer.

## Troubleshooting
**Resource Creation Issues**:
- Check AWS CLI credentials and permissions.
- Verify the AWS region is correctly specified.

**SSH Access**:
- Ensure the security group allows inbound traffic on port 22.
- Verify the private key matches the public key specified in `key_pair`.

**Load Balancer**:
- Ensure EC2 instances are healthy in the target group.
- Check security group rules for the ALB and EC2 instances.
