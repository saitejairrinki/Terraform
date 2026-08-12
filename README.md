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
```

---

# 3️⃣ `terraform.tfvars`

These are **sample values**. Replace them with your actual AWS values.

```hcl
aws_region = "ap-south-1"

ami_id = "ami-xxxxxxxxxxxxxxxxx"

instance_type = "t3.micro"

instance_name = "devops-ec2"

key_name = "my-ec2-key"
```

⚠️ Replace:

```text
ami-xxxxxxxxxxxxxxxxx
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
resource "aws_instance" "ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

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
