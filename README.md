# Terraform

Yes — **no `modules/` directory for now**. We’ll keep it simple with separate Terraform files.

## 📁 Directory Structure

```text
terraform-ec2/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
└── outputs.tf
```

### 📌 Purpose of each file

| File               | Purpose                                |
| ------------------ | -------------------------------------- |
| `provider.tf`      | AWS provider configuration             |
| `variables.tf`     | Variable declarations                  |
| `terraform.tfvars` | Sample values — you will replace these |
| `main.tf`          | EC2 resource                           |
| `outputs.tf`       | Display EC2 details after creation     |

---

# 1️⃣ `provider.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

# 2️⃣ `variables.tf`

```hcl
variable "aws_region" {
  description = "AWS region where EC2 will be created"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}
variable "ec2_sg" {
  description = "EC2 SG"
  type        = string
}
```

---

# 3️⃣ `terraform.tfvars`

These are **sample values**. Replace them with your actual AWS values.

```hcl
bucket_name = "devopsaugust122026"
aws_region = "us-east-1"
ami_id = "ami-0b6d9d3d33ba97d99"
instance_type = "t3.micro"
instance_name = "Chilling"
ec2_sg = "sg-0b6140854f3cfff24"
key_name = "chilling"
```


with a valid AMI ID from your selected AWS region.

Also replace:

```text
my-ec2-key
```

with your actual EC2 key-pair name.

---

# 4️⃣ `main.tf`

This is where we create the EC2 instance.

```hcl
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name 

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_instance" "ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.ec2_sg]

  tags = {
    Name = var.instance_name
  }
}
```

---

# 5️⃣ `outputs.tf`

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ec2.id
}

output "public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.ec2.public_ip
}

output "private_ip" {
  description = "EC2 private IP address"
  value       = aws_instance.ec2.private_ip
}
```

---

# 🔄 How Terraform Works Here

```text
terraform.tfvars
       │
       │ sample values
       ▼
 variables.tf
       │
       ▼
    main.tf
       │
       │ creates
       ▼
  AWS EC2 Instance
       │
       ▼
  outputs.tf
       │
       ▼
Instance ID
Public IP
Private IP
```

## 🚀 Run Terraform

```bash
terraform init
```

```bash
terraform validate
```

```bash
terraform plan
```

```bash
terraform apply
```

To remove the EC2 later:

```bash
terraform destroy
```

🟢 **Best practice for this stage:** Keep it exactly like this while learning Terraform. Once you're comfortable with variables, resources, outputs, and providers, we can introduce `modules/` and make the EC2 reusable.

# Using Modules

## 📁 Folder Structure

```text
terraform-ec2/
│
├── main.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
│
└── modules/
    │
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── s3/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## `provider.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

## `variables.tf`

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ec2_sg" {
  description = "EC2 security group ID"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}
```

---

## `terraform.tfvars`

```hcl
aws_region = "us-east-1"

ami_id = "ami-0b6d9d3d33ba97d99"

instance_type = "t3.micro"

instance_name = "Chilling"

key_name = "chilling"

ec2_sg = "sg-0b6140854f3cfff24"

bucket_name = "devopsaugust122026"
```

---

## `main.tf`

```hcl
module "ec2" {
  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  instance_name = var.instance_name
  key_name      = var.key_name
  ec2_sg        = var.ec2_sg
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}
```

---

## `outputs.tf`

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "EC2 public IP address"
  value       = module.ec2.public_ip
}

output "private_ip" {
  description = "EC2 private IP address"
  value       = module.ec2.private_ip
}

output "bucket_id" {
  description = "S3 bucket ID"
  value       = module.s3.bucket_id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3.bucket_arn
}
```

---

# 📦 EC2 Module

### `modules/ec2/variables.tf`

```hcl
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ec2_sg" {
  description = "EC2 security group ID"
  type        = string
}
```

### `modules/ec2/main.tf`

```hcl
resource "aws_instance" "ec2" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg]

  tags = {
    Name = var.instance_name
  }
}
```

### `modules/ec2/outputs.tf`

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ec2.id
}

output "public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.ec2.public_ip
}

output "private_ip" {
  description = "EC2 private IP address"
  value       = aws_instance.ec2.private_ip
}
```

---

# 🪣 S3 Module

### `modules/s3/variables.tf`

```hcl
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}
```

### `modules/s3/main.tf`

```hcl
resource "aws_s3_bucket" "this" {

  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}
```

### `modules/s3/outputs.tf`

```hcl
output "bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.this.arn
}
```

---

## 🔄 Final Flow

```text
terraform.tfvars
       │
       ▼
variables.tf
       │
       ▼
   main.tf
    /    \
   ▼      ▼
 EC2      S3
Module   Module
   │        │
   ▼        ▼
 EC2      Bucket
   │        │
   └───┬────┘
       ▼
 outputs.tf
```

Then run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

This gives you a clean **root configuration + two reusable modules** without adding any extra complexity.

