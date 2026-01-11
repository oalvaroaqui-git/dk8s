# Dia 4

Deployment com versao fixa de imagem e recursos definidos.

## Objetivo
- Fixar versao de imagem para evitar surpresas em atualizacoes.
- Revisar requests e limits em um Deployment.

## Arquivos
- `deployment.yaml`: Deployment nginx com 3 replicas e imagem `nginx:1.19.2`.

## Explicacoes
Fixar a tag de imagem garante previsibilidade no ambiente. O Deployment aplica a mesma configuracao para todas as replicas e permite observar o rollout.

## Comandos
```bash
kubectl apply -f deployment.yaml
kubectl get deploy
kubectl rollout status deployment/nginx-deployment-day4
```

## Documentacao oficial
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- https://kubernetes.io/docs/concepts/containers/images/
