# 🌍 Multi-Region High Availability & Disaster Recovery on AWS

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazon-aws)](https://aws.amazon.com/)

Enterprise-grade disaster recovery architecture with automatic DNS failover across AWS regions using Infrastructure as Code.

---

## 📋 Overview

This project implements a production-ready, multi-region High Availability and Disaster Recovery (HADR) architecture on AWS. The system automatically fails over between Mumbai (primary) and Virginia (secondary) regions with **2-3 minute RTO** and near-zero RPO.

### Key Features

- **Multi-Region Deployment**: Active-passive architecture across 2 AWS regions
- **Automatic Failover**: DNS-based switching via Route 53 health checks
- **Self-Healing Infrastructure**: Auto Scaling Groups with automatic instance replacement
- **Load Balancing**: Application Load Balancers with health monitoring
- **Infrastructure as Code**: 100% Terraform, modular and reusable
- **Fast Recovery**: 2-3 minute failover time with zero manual intervention

---

## 🏗️ Architecture

```
                         INTERNET
                            │
                            ↓
                   ┌────────────────┐
                   │   Route 53     │
                   │ (DNS Failover) │
                   └────────────────┘
                      /          \
           PRIMARY   /            \   SECONDARY
                    /              \
         ┌─────────────┐      ┌──────────────┐
         │ Mumbai ALB  │      │ Virginia ALB │
         │ ap-south-1  │      │  us-east-1   │
         └─────────────┘      └──────────────┘
         Multi-AZ: a,b         Multi-AZ: a,b
               │                      │
         ┌─────┴─────┐          ┌────┴─────┐
         │           │          │          │
    ┌────▼────┐ ┌───▼────┐ ┌───▼────┐ ┌───▼────┐
    │ EC2-1a  │ │ EC2-1b │ │ EC2-1a │ │ EC2-1b │
    │ Mumbai  │ │ Mumbai │ │ Virgin.│ │ Virgin.│
    └─────────┘ └────────┘ └────────┘ └────────┘
```

### Component Stack

| Layer | Component | Purpose |
|-------|-----------|---------|
| **DNS** | Route 53 | Global DNS with failover routing and health checks |
| **Load Balancing** | Application Load Balancer | Traffic distribution and health-based routing |
| **Compute** | Auto Scaling Group | Instance management with self-healing |
| **Security** | Security Groups | Stateful firewall for traffic control |
| **Network** | VPC | Network isolation per region |

---

## ✨ Benefits

### High Availability
- Multi-AZ deployment within each region for zone-level fault tolerance
- Auto Scaling maintains desired instance count automatically
- Load balancers route traffic only to healthy instances
- Failed instances replaced within 2-3 minutes

### Disaster Recovery
- Automatic region-level failover without manual intervention
- Health checks monitor primary region every 30 seconds
- Automatic failback when primary region recovers
- Sub-5-minute RTO, near-zero RPO

### Operational Excellence
- Infrastructure as Code enables reproducible deployments
- Modular Terraform design for code reusability
- Version-controlled configuration
- Automated DR testing scripts

---

## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.0
- AWS CLI >= 2.0
- AWS account with appropriate IAM permissions
- Git

### Deployment

**1. Clone Repository**
```bash
git clone https://github.com/YOUR-USERNAME/hadr-aws-automation.git
cd hadr-aws-automation
```

**2. Deploy Mumbai (Primary Region)**
```bash
cd terraform/environments/mumbai
terraform init
terraform apply
```

**3. Deploy Virginia (Secondary Region)**
```bash
cd ../virginia
terraform init
terraform apply
```

**4. Configure DNS Failover**
```bash
cd ../../global/dns-failover
# Update terraform.tfvars with ALB DNS names and zone IDs
terraform init
terraform apply
```

**5. Verify Deployment**
```bash
# Check Mumbai instances
aws ec2 describe-instances --region ap-south-1 \
  --filters "Name=tag:Name,Values=hadr-mumbai-asg-instance"

# Check Virginia instances
aws ec2 describe-instances --region us-east-1 \
  --filters "Name=tag:Name,Values=hadr-virginia-asg-instance"
```

---

## 📁 Project Structure

```
hadr-aws-automation/
├── terraform/
│   ├── modules/                    # Reusable Terraform modules
│   │   ├── vpc/                    # VPC with subnets, IGW, route tables
│   │   ├── security-group/         # Security group configuration
│   │   ├── asg/                    # Auto Scaling Group with launch template
│   │   └── alb/                    # Application Load Balancer
│   ├── environments/               # Region-specific deployments
│   │   ├── mumbai/                 # Primary region (ap-south-1)
│   │   └── virginia/               # Secondary region (us-east-1)
│   └── global/
│       └── dns-failover/           # Route 53 DNS configuration
└── scripts/
    └── dr-test.sh                  # Automated DR testing
```

---

## 🧪 Disaster Recovery Testing

### Automated Test

```bash
cd scripts
./dr-test.sh
```

### Manual Failover Test

**Trigger Failover (Simulate Mumbai Failure)**
```bash
aws autoscaling update-auto-scaling-group \
  --region ap-south-1 \
  --auto-scaling-group-name hadr-mumbai-asg \
  --desired-capacity 0 \
  --min-size 0
```

**Monitor Health Check**
```bash
watch -n 10 'aws route53 get-health-check-status \
  --health-check-id YOUR_HEALTH_CHECK_ID'
```

**Verify Failover**
```bash
aws route53 test-dns-answer \
  --hosted-zone-id YOUR_HOSTED_ZONE_ID \
  --record-name app.your-domain.com \
  --record-type A
```

**Restore Primary Region**
```bash
aws autoscaling update-auto-scaling-group \
  --region ap-south-1 \
  --auto-scaling-group-name hadr-mumbai-asg \
  --desired-capacity 2 \
  --min-size 1
```

### DR Metrics

| Metric | Target | Achieved |
|--------|--------|----------|
| **RTO** (Recovery Time) | < 5 min | 2-3 min |
| **RPO** (Data Loss) | < 1 min | Near-zero |
| **Automation** | 100% | 100% |
| **Failover Detection** | < 2 min | 60 seconds |

---

## 💰 Cost Analysis

### Monthly Cost Estimate

| Resource | Quantity | Monthly Cost (INR) |
|----------|----------|--------------------|
| ALB | 2 | ₹540 |
| Route 53 Hosted Zone | 1 | ₹40 |
| Route 53 Health Check | 1 | ₹40 |
| t2.micro instances | 4 | ₹0 (free tier) |
| Data Transfer | - | ~₹50 |
| **Total** | | **~₹670/month** |

**Cost Optimization**: Destroy infrastructure when not in use. Rebuild takes 5-10 minutes. Test cost: ~₹45 for 2 days.

---

## 📚 Module Documentation

### VPC Module
Creates isolated network infrastructure with subnets, Internet Gateway, and route tables across multiple availability zones.

### Security Group Module
Configures security group allowing HTTP traffic (port 80) with stateful firewall rules.

### ASG Module
Deploys Auto Scaling Group with launch template, user data for Apache installation, and configurable capacity (min: 1, desired: 2, max: 3).

### ALB Module
Creates Application Load Balancer with target group, health checks (30s interval), and HTTP listener for traffic distribution.

---

## 🔧 Technologies Used

- **AWS Services**: VPC, EC2, Auto Scaling, Application Load Balancer, Route 53
- **Infrastructure as Code**: Terraform (100% IaC)
- **Automation**: Bash scripting for DR testing
- **Version Control**: Git

---

## 🎯 Use Cases

- Production web applications requiring high availability
- Mission-critical systems needing automatic disaster recovery
- Multi-region deployments for compliance or latency requirements
- Learning enterprise-grade cloud architecture patterns

---

## 🔍 Key Learnings

This project demonstrates:
- Multi-region cloud architecture design
- Infrastructure as Code best practices
- Terraform module development and reusability
- Auto Scaling and load balancing configuration
- DNS-based disaster recovery implementation
- Health monitoring and automatic failover
- AWS multi-service integration

---

## 📈 Future Enhancements

- HTTPS/SSL with ACM certificates
- CloudWatch monitoring and alerting
- RDS with cross-region replication
- CI/CD pipeline integration
- WAF for enhanced security
- CloudFront CDN integration

---

## 🤝 Contributing

Contributions welcome! Please fork the repository and submit pull requests with descriptive commit messages.

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Shubham**
- GitHub: [@Bshubhs](https://github.com/Bshubhs)

---

**Built with Terraform and AWS for enterprise-grade disaster recovery** 🚀