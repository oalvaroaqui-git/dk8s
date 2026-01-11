locals {
  use_default_vpc    = var.vpc_id == ""
  use_default_subnet = var.subnet_id == ""
}

data "aws_vpc" "default" {
  count   = local.use_default_vpc ? 1 : 0
  default = true
}

data "aws_subnet_ids" "default" {
  count  = local.use_default_subnet ? 1 : 0
  vpc_id = local.use_default_vpc ? data.aws_vpc.default[0].id : var.vpc_id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "k8s" {
  name        = "dk8s-day5-k8s"
  description = "Security group for kubeadm cluster"
  vpc_id      = local.use_default_vpc ? data.aws_vpc.default[0].id : var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Kubernetes API Server
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # etcd server client API
  ingress {
    description = "etcd server client API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Kubelet API
  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # kube-scheduler
  ingress {
    description = "kube-scheduler"
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # kube-controller-manager
  ingress {
    description = "kube-controller-manager"
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # NodePort Services
  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Allow all traffic within the SG
  ingress {
    description = "Inter-node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dk8s-day5-k8s"
  }
}

resource "aws_instance" "k8s_nodes" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = local.use_default_subnet ? data.aws_subnet_ids.default[0].ids[0] : var.subnet_id

  vpc_security_group_ids = [aws_security_group.k8s.id]

  tags = {
    Name = "dk8s-day5-node-${count.index + 1}"
  }
}
