resource "aws_instance" "Instance" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  key_name               = "websrv"
  vpc_security_group_ids = ["sg-076a3a8ac4480cde9"]
  tags = {
    Name = "IAAC"
    Team = "DevOps"
  }
}
