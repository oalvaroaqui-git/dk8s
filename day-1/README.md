# Dia 1

Introducao ao cluster local com kind e ao primeiro Pod no Kubernetes.

## Objetivo
- Criar um cluster local com kind e entender o manifesto de configuracao.
- Subir um Pod com nginx e revisar labels, portas e recursos.

## Arquivos
- `kind/kind-cluster.yaml`: configuracao do cluster kind com 1 control-plane e 2 workers.
- `meu-primeiro-pod.yaml`: Pod nginx com requests e limits de CPU/memoria.

## Explicacoes
O kind (Kubernetes in Docker) cria clusters locais usando containers. O manifesto define quantos nos (control-plane e workers) o cluster tera.

O Pod e a menor unidade de execucao do Kubernetes. Neste exemplo, usamos nginx com labels para organizacao e definimos requests e limits para controlar o uso de CPU e memoria.

## Observacoes
- O exemplo usa requests/limits de memoria altos (4.4Gi/5Gi). Em maquinas com poucos recursos, ajuste para valores menores.

## Comandos
```bash
kind create cluster --name dk8s-day1 --config kind/kind-cluster.yaml
kubectl apply -f meu-primeiro-pod.yaml
kubectl get pods -o wide
kubectl describe pod nginx-day1
```

## Documentacao oficial
- https://kind.sigs.k8s.io/docs/user/configuration/
- https://kubernetes.io/docs/concepts/workloads/pods/
- https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
