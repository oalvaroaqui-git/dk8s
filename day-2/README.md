# Dia 2

Revisao de recursos de containers e uso de volumes simples.

## Objetivo
- Entender requests e limits em Pods.
- Usar um volume `emptyDir` para dados temporarios.

## Arquivos
- `pod.yaml`: Pod ubuntu em sleep com requests e limits.
- `pod-limitado.yaml`: Pod com limites definidos para estudo.
- `pod-emptydir.yaml`: Pod nginx com volume `emptyDir` montado em `/giropops`.

## Explicacoes
Requests definem o minimo de CPU e memoria reservado para o container. Limits definem o teto de uso. Isso ajuda o scheduler a posicionar o Pod e evita consumo excessivo.

`emptyDir` e um volume temporario criado quando o Pod inicia e removido quando o Pod termina. E util para cache ou arquivos intermediarios.

## Comandos
```bash
kubectl apply -f pod.yaml
kubectl apply -f pod-emptydir.yaml
kubectl get pods -o wide
kubectl describe pod giropops-ubuntu
```

## Documentacao oficial
- https://kubernetes.io/docs/concepts/workloads/pods/
- https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
- https://kubernetes.io/docs/concepts/storage/volumes/#emptydir
