# Dia 3

Namespaces e Deployments, incluindo estrategias de rollout.

## Objetivo
- Criar um namespace dedicado para isolar recursos.
- Criar Deployments e entender replicas e estrategias de atualizacao.

## Arquivos
- `namespace.yaml`: cria o namespace `giropops`.
- `deployment.yaml`: Deployment nginx com 3 replicas no namespace `giropops`.
- `strategy-deployment.yaml`: Deployment com estrategia RollingUpdate.
- `rollout-deployment.yaml`: Deployment com estrategia Recreate e 10 replicas.
- `novo-deployment.yaml`: manifesto gerado para estudo e edicao.
- `day3.txt`: anotacoes iniciais.

## Explicacoes
Namespace separa recursos dentro do cluster, facilitando organizacao e controle.

Deployment gerencia replicas e permite atualizacoes de forma controlada. RollingUpdate atualiza aos poucos, enquanto Recreate remove os Pods antigos antes de criar os novos.

## Comandos
```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl get deploy -n giropops
kubectl apply -f strategy-deployment.yaml
kubectl rollout status deployment/nginx-deployment-rolling -n giropops
kubectl apply -f rollout-deployment.yaml
kubectl rollout history deployment/nginx-deployment-recreate -n giropops
```

## Documentacao oficial
- https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
- https://kubernetes.io/docs/reference/kubectl/kubectl-commands#rollout
