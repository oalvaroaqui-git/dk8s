# Dia 5

Hoje nos iremos falar como instalar o Kubernetes em um cluster com 03 nodes, onde um deles sera o control plane e os outros dois serao os workers.

Nos iremos utilizar o kubeadm para configurar o nosso cluster. Nos iremos conhecer no detalhe como criar um cluster utilizando 03 instancias EC2 da AWS, mas voce pode utilizar qualquer outro tipo de instancia, desde que seja uma instancia Linux, o importante e entender o processo de instalacao do Kubernetes e como seus componentes trabalham juntos.

Espero que voce se divirta durante o Day-5, e que aprenda muito com o conteudo que preparamos para voce. Hoje o dia sera mais curtinho, mas nao menos importante. Bora la! #VAIIII

Utilize Terraform para implementar via IaaS.

## Objetivo
- Instalar o Kubernetes em 3 nodes (1 control plane + 2 workers).
- Entender o fluxo de instalacao com kubeadm.
- Preparar infraestrutura em IaaS (exemplo com AWS EC2).

## Topicos
- O que e Kubernetes?
- O que e um cluster Kubernetes?
- Diferentes formas de instalar um cluster Kubernetes.
- Como criar as instancias.
- Configurar os nodes.
- Instalacao e configuracao do containerd.
- Configuracao das portas.
- Inicializacao do cluster com admin.conf.
- Adicionando outros nodes e o que e CNI.
- Visualizando detalhes dos nodes.

## Contexto e explicacoes
Kubernetes e uma plataforma de orquestracao de containers que automatiza o deploy, escalonamento e operacao de aplicacoes em containers. Um cluster Kubernetes e composto por um control plane (que gerencia o estado do cluster) e um conjunto de workers (onde os Pods rodam).

Ha diferentes formas de instalacao: gerenciadas (EKS, GKE, AKS), distribuicoes (k3s, RKE), ou instalacao manual com kubeadm. Aqui vamos usar kubeadm para entender o processo de ponta a ponta.

## Passos em alto nivel
1. Criar as instancias (3 VMs Linux) via Terraform.
2. Configurar pre-requisitos nos nodes (swap off, modulos de kernel, sysctl, pacotes basicos).
3. Instalar e configurar o containerd.
4. Abrir portas necessarias no security group/firewall.
5. Inicializar o cluster com kubeadm no control plane e gerar o `admin.conf`.
6. Instalar o CNI (plugin de rede) e adicionar os workers.
7. Validar os nodes com kubectl.

## Documentacao oficial
- https://kubernetes.io/docs/concepts/overview/
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
- https://kubernetes.io/docs/setup/production-environment/container-runtimes/
- https://kubernetes.io/docs/concepts/cluster-administration/addons/
- https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
- https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/
