# AWS Infrastructure - Personal Website

## Architecture Overview

This repository contains Terraform configurations for deploying a highly available website infrastructure on AWS.

### Infrastructure Components:
```
┌─────────────────────────────────────────────────────────────────┐
│                           VPC (10.0.0.0/16)                     │
│  ┌─────────────────────────┐      ┌─────────────────────────┐  │
│  │   Public Subnet 1       │      │   Public Subnet 2       │  │
│  │   10.0.0.0/24          │      │   10.0.1.0/24          │  │
│  │ ┌─────────────────┐    │      │ ┌─────────────────┐    │  │
│  │ │  EC2 Instance   │    │      │ │  EC2 Instance   │    │  │
│  │ │    (nginx1)     │    │      │ │    (nginx2)     │    │  │
│  │ └─────────────────┘    │      │ └─────────────────┘    │  │
│  └─────────────────────────┘      └─────────────────────────┘  │
│                    │                           │                 │
│                    └───────────┬───────────────┘                │
│                                │                                │
│                      ┌─────────────────┐                       │
│                      │ Application Load│                       │
│                      │    Balancer    │                       │
│                      └─────────────────┘                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                      ┌───────────────┐
                      │   S3 Bucket   │
                      │ (Web Content) │
                      └───────────────┘
```

## Prerequisites

1. AWS CLI installed and configured
2. Terraform >= 1.0
3. SSH key pair for EC2 instance access
4. Website content in the `website/` directory

## Configuration Files

- `instances.tf`: EC2 instances and IAM configurations
- `loadbalancer.tf`: ALB and target group configurations
- `locals.tf`: Local variables and common tags
- `network.tf`: VPC, subnets, and security groups
- `outputs.tf`: Output values like ALB DNS name
- `providers.tf`: AWS provider configuration
- `s3.tf`: S3 bucket for website content and logs
- `variables.tf`: Input variables
- `terraform.tf`: Terraform and provider versions

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/oqqzn/webiste-aws.git
cd website-aws
```

2. Initialize Terraform:
```bash
terraform init
```

3. Copy and modify the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

4. Place your website content in the `website/` directory

5. Review the plan:
```bash
terraform plan
```

6. Apply the configuration:
```bash
terraform validate
terraform apply
```

## Components

### VPC and Networking
- VPC with CIDR 10.0.0.0/16
- Two public subnets across different AZs
- Internet Gateway
- Route tables for public access

### Security Groups
- ALB Security Group: Allows inbound HTTP (80)
- EC2 Security Group: Allows inbound HTTP from ALB and SSH access

### Application Load Balancer
- HTTP listener on port 80
- Health checks on path "/"
- Distributes traffic across two EC2 instances

### EC2 Instances
- Amazon Linux 2 AMI
- t2.micro instance type
- Nginx web server
- IAM role for S3 access

### S3 Bucket
- Stores website content
- ALB access logs
- Protected with bucket policy

## NGINX Configuration
The NGINX configuration is applied via user data script and includes:
- Root directory configuration
- Static file serving
- Error page handling
- Access and error logging

## Security Considerations
- SSH access restricted by security group
- S3 bucket access limited to EC2 instances via IAM
- ALB logs stored in S3 for auditing
- HTTPS can be enabled (requires SSL certificate)

## Maintenance

### Adding Content
1. Add files to the `website/` directory
2. Run `terraform apply` to update S3 bucket

### Updating Instances
1. Modify the instance configuration in `instances.tf`
2. Run `terraform plan` to review changes
3. Apply with `terraform apply`

### Cleanup
To destroy all resources:
```bash
terraform destroy
```

## Cost Considerations
This infrastructure includes:
- EC2 t2.micro instances (~$8.50/month each)
- Application Load Balancer (~$18/month)
- S3 storage (varies with usage)
- Data transfer costs (varies with usage)

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
MIT

## Support
For support, please create an issue in the GitHub repository.
