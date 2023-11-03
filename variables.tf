variable "key-pair" {
  default = "aws-ws"
}

variable "ami_id" {
  default = "ami-0ab1a82de7ca5889c"
}

variable "my_ip" {
    default = "62.89.6.123/32"
}


variable "region" {
    default = "eu-central-1"
}

variable "cidr_block" {
    default = "10.100.0.0/16"
}

variable "public_subnet_cidr_block" {
    default = "10.100.10.0/24"
}

variable "private_subnet_cidr_block" {
    default = "10.100.20.0/24"
}

variable "ecr_url" {
  default = "428496519623.dkr.ecr.eu-central-1.amazonaws.com/jenkins:8"
}
