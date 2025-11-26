# WordPress Infrastructure on AWS with Terraform

Infrastructure as Code (IaC) project to deploy a highly available WordPress application on AWS using Terraform.

## Architecture Overview

This Terraform project creates a complete, production-ready WordPress infrastructure on AWS with the following components:

### Network Layer
- **VPC** - Virtual Private Cloud with custom CIDR block
- **2 Public Subnets** - Distributed across different Availability Zones for high availability
- **Internet Gateway** - Provides internet access to resources
- **Route Tables** - Configured for public internet access

### Compute Layer
- **EC2 Auto Scaling Group** - Automatically scales WordPress instances (1-3 instances)
- **Launch Template** - Standardized EC2 configuration with WordPress pre-installed
- **Amazon Linux 2023** - Latest Amazon Linux AMI with PHP 8.2 and Apache

### Database Layer
- **RDS MySQL 8.0** - Managed database service for WordPress
- **DB Subnet Group** - Database deployment across multiple AZs
- **Automated Backups** - 7-day retention with automated snapshots
- **Encryption** - Storage encryption enabled

### Load Balancing
- **Application Load Balancer** - Distributes traffic across EC2 instances
- **Target Group** - Health checks and sticky sessions enabled
- **HTTP Listener** - Configured on port 80 (HTTPS ready with SSL certificate)

### Security
- **Security Groups**:
  - ALB Security Group - Allows HTTP/HTTPS from internet
  - EC2 Security Group - Allows HTTP from ALB and SSH access
  - RDS Security Group - Allows MySQL (3306) from EC2 only
- **Encrypted RDS Storage**
- **IMDSv2 Required** - Enhanced EC2 metadata security

## Project Structure

```
.
├── main.tf                      # Main configuration with all modules
├── variables.tf                 # Input variables definition
├── outputs.tf                   # Output values
├── providers.tf                 # Provider configuration (AWS, S3 backend)
├── terraform.tfvars.example     # Example variables file
├── .gitignore                   # Git ignore rules
├── README.md                    # This file
└── modules/
    ├── VPC/                     # VPC, Subnets, IGW, Route Tables
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── SecurityGroups/          # Security Groups for ALB, EC2, RDS
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── RDS/                     # RDS MySQL Database
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── EC2/                     # EC2 Auto Scaling Group
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── user_data.sh        # WordPress installation script
    └── ALB/                     # Application Load Balancer
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Prerequisites

1. **Terraform** installed (version >= 1.0)
   ```bash
   terraform version
   ```

2. **AWS CLI** configured with credentials
   ```bash
   aws configure
   ```

3. **AWS Account** with appropriate permissions to create:
   - VPC, Subnets, Internet Gateway, Route Tables
   - EC2 instances, Auto Scaling Groups, Launch Templates
   - RDS instances
   - Application Load Balancer
   - Security Groups
   - S3 bucket for Terraform state

4. **SSH Key Pair** created in AWS EC2 console
   - Navigate to EC2 > Key Pairs > Create Key Pair
   - Name it `wordpress-key` (or update the `key_name` variable)

5. **S3 Bucket** for Terraform state backend
   - Bucket: `joiangon.tfstates2025` (already configured)
   - Region: `us-east-1`

## Installation & Deployment

### 1. Clone and Configure

```bash
cd c:\Users\Usuario\Documents\aws\.terraform
```

### 2. Create terraform.tfvars

Copy the example file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
aws_region = "us-east-1"
aws_profile = "default"
shared_credentials_files = ["C:/Users/Usuario/.aws/credentials"]

db_name     = "wordpressdb"
db_username = "admin"
db_password = "YourSecurePassword123!"  # CHANGE THIS!

key_name = "wordpress-key"  # Must exist in AWS
```

**IMPORTANT**: Change `db_password` to a secure password!

### 3. Initialize Terraform

```bash
terraform init
```

This will:
- Download AWS provider
- Configure S3 backend for state management
- Initialize modules

### 4. Select/Create Workspace

Workspaces allow you to manage multiple environments:

```bash
# List workspaces
terraform workspace list

# Create new workspace (dev, staging, prod)
terraform workspace new dev

# Select workspace
terraform workspace select dev
```

### 5. Plan Deployment

Review what will be created:

```bash
terraform plan
```

### 6. Apply Configuration

Create the infrastructure:

```bash
terraform apply
```

Type `yes` when prompted.

Deployment takes approximately 10-15 minutes.

### 7. Access WordPress

After successful deployment:

```bash
terraform output wordpress_url
```

This will display the URL to access your WordPress site.

Example output:
```
wordpress_url = "http://alb-itm-wordpress-dev-123456789.us-east-1.elb.amazonaws.com"
```

Visit the URL and complete WordPress installation:
1. Select language
2. Enter site information
3. Create admin account

## Important Outputs

View all outputs:

```bash
terraform output
```

Key outputs:
- `wordpress_url` - WordPress site URL
- `wordpress_admin_url` - WordPress admin panel URL
- `alb_dns_name` - Load balancer DNS name
- `db_instance_endpoint` - RDS database endpoint
- `vpc_id` - VPC ID
- `autoscaling_group_name` - ASG name for scaling adjustments

## Workspaces Configuration

The project uses Terraform workspaces for multi-environment management:

### Default Workspace
- VPC CIDR: `192.168.16.0/24`
- Subnet 1: `192.168.16.0/28` (us-east-1a)
- Subnet 2: `192.168.16.32/28` (us-east-1b)
- Instance Type: `t2.micro`
- DB Instance: `db.t3.micro`

### Dev Workspace
- VPC CIDR: `192.168.16.0/24`
- Subnet 1: `192.168.16.16/28` (us-east-1b)
- Subnet 2: `192.168.16.32/28` (us-east-1c)
- Instance Type: `t2.micro`
- DB Instance: `db.t3.micro`

Customize these values in `variables.tf`.

## Cost Optimization

Current configuration uses Free Tier eligible resources where possible:

- **EC2**: t2.micro instances (Free Tier: 750 hours/month)
- **RDS**: db.t3.micro instance (Free Tier: 750 hours/month, 20GB storage)
- **ALB**: ~$16-20/month (not Free Tier eligible)
- **Data Transfer**: First 100GB/month free

**Estimated monthly cost**: $20-30/month (varies by region and usage)

### Cost Reduction Tips

1. **Use Spot Instances** for EC2 (reduce costs by 70-90%)
2. **Reduce Auto Scaling** min/desired to 1 instance
3. **Use Aurora Serverless v2** instead of RDS for variable workloads
4. **Stop resources** when not in use (especially RDS)

## Security Considerations

### Implemented
- ✅ RDS encryption at rest
- ✅ Security Groups with least privilege access
- ✅ IMDSv2 required for EC2 metadata
- ✅ Sensitive variables marked as sensitive
- ✅ Database in private subnets (logically isolated)
- ✅ Automated backups enabled

### Recommended Enhancements
- 🔒 Add SSL/TLS certificate to ALB (HTTPS)
- 🔒 Restrict SSH access to specific IP addresses
- 🔒 Use AWS Secrets Manager for database credentials
- 🔒 Enable VPC Flow Logs
- 🔒 Add WAF to ALB for application protection
- 🔒 Enable CloudWatch monitoring and alarms
- 🔒 Implement regular automated backups

## Scaling

### Manual Scaling

Adjust Auto Scaling Group:

```bash
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name $(terraform output -raw autoscaling_group_name) \
  --desired-capacity 3
```

### Auto Scaling Policies

Add to `modules/EC2/main.tf`:

```hcl
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}
```

## Backup & Disaster Recovery

### RDS Backups
- **Automated backups**: Daily at 03:00-04:00 UTC
- **Retention period**: 7 days
- **Manual snapshots**: Create via AWS Console or CLI

### Create Manual Snapshot

```bash
aws rds create-db-snapshot \
  --db-instance-identifier $(terraform output -raw db_instance_id) \
  --db-snapshot-identifier wordpress-manual-snapshot-$(date +%Y%m%d)
```

### Restore from Snapshot

1. Update `modules/RDS/main.tf`
2. Add `snapshot_identifier` parameter
3. Run `terraform apply`

## Monitoring

### CloudWatch Metrics

Monitor key metrics:
- ALB Target Health
- EC2 CPU/Memory utilization
- RDS CPU/Storage/Connections
- Auto Scaling Group metrics

### Enable Detailed Monitoring

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name high-cpu \
  --alarm-description "Alert when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold
```

## Troubleshooting

### WordPress Installation Issues

1. **Check EC2 User Data logs**:
   ```bash
   ssh -i wordpress-key.pem ec2-user@<ec2-ip>
   sudo cat /var/log/cloud-init-output.log
   ```

2. **Verify database connectivity**:
   ```bash
   mysql -h <rds-endpoint> -u admin -p
   ```

3. **Check Apache logs**:
   ```bash
   sudo tail -f /var/log/httpd/error_log
   ```

### ALB Health Check Failures

1. Verify target group health:
   ```bash
   aws elbv2 describe-target-health \
     --target-group-arn $(terraform output -raw target_group_arn)
   ```

2. Check security group rules
3. Verify `/health.html` exists on EC2 instances

### Database Connection Issues

1. Check security group allows MySQL (3306) from EC2
2. Verify RDS is in "available" state
3. Check WordPress `wp-config.php` has correct endpoint

## Maintenance

### Update WordPress

SSH into an EC2 instance:

```bash
ssh -i wordpress-key.pem ec2-user@<ec2-ip>
cd /var/www/html
sudo -u apache wp core update
sudo -u apache wp plugin update --all
sudo -u apache wp theme update --all
```

### Update Infrastructure

1. Modify Terraform files
2. Run `terraform plan` to review changes
3. Run `terraform apply` to apply changes

## Cleanup

To destroy all resources:

```bash
# WARNING: This will delete everything!
terraform destroy
```

Type `yes` when prompted.

**Note**: This will delete:
- All EC2 instances
- Load Balancer
- RDS database (unless `skip_final_snapshot = false`)
- VPC and networking components

The S3 state bucket is NOT deleted.

## Contributing

1. Create a feature branch
2. Make your changes
3. Test with `terraform plan`
4. Submit a pull request

## License

This project is for educational and internal use.

## Support

For issues or questions:
1. Check Terraform documentation: https://www.terraform.io/docs
2. Check AWS documentation: https://docs.aws.amazon.com
3. Review logs on EC2 instances
4. Check CloudWatch metrics

## Authors

- ITM Infrastructure Team
- Project: WordPress on AWS

## Version History

- **v1.0.0** (2025) - Initial release
  - VPC with 2 public subnets
  - Auto Scaling EC2 instances
  - RDS MySQL database
  - Application Load Balancer
  - Complete WordPress installation

---

**Last Updated**: 2025
