variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "instance_count" {
  type        = number
  description = "Number of nodes to create"
  default     = 3
}

variable "key_name" {
  type        = string
  description = "Name of an existing EC2 key pair for SSH"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID (leave empty to use default VPC)"
  default     = ""
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID (leave empty to use a default subnet)"
  default     = ""
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH"
  default     = "0.0.0.0/0"
}
