variable "REGION" {
  default = "us-east-2"
}

variable "ZONE1" {
  default = "us-east-2a"
}


variable "BUCKET1" {
  default = "devopspractice2024terraform"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-2 = "ami-0fb653ca2d3203ac1"
    us-east-1 = "ami-0e1d30f2c40c4c701"
  }
}

