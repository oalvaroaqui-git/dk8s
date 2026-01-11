# Terraform - Day 5

Este exemplo cria instancias EC2 Ubuntu 22.04 para o cluster Kubernetes.

## Como usar
```bash
terraform init
terraform apply -var="key_name=SEU_KEY_PAIR" -var="allowed_ssh_cidr=SEU_IP/32"
```

## Variaveis principais
- `instance_count`: numero de instancias (default 3)
- `instance_type`: tipo da instancia (default t3.medium)
- `key_name`: key pair existente na AWS
- `aws_region`: regiao (default us-east-1)

## Observacao
Se voce nao informar `vpc_id` e `subnet_id`, o codigo usa a VPC default e uma subnet default da regiao.
