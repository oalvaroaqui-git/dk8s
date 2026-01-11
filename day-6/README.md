# Dia 6

Armazenamento no Kubernetes: volumes, PV, PVC e StorageClass.

## Objetivo
- Entender volumes e persistencia de dados.
- Revisar PV, PVC e StorageClass.
- Usar StorageClass com provisionamento estatico (no-provisioner).

## Arquivos
- `storageclass.yaml`: StorageClass `giropops` com `kubernetes.io/no-provisioner` e `WaitForFirstConsumer`.

## Explicacoes
Volumes permitem persistir dados fora do ciclo de vida de um Pod. O tipo de volume define como e onde os dados ficam armazenados.

StorageClass define uma classe de armazenamento. Com `kubernetes.io/no-provisioner`, o provisionamento e estatico: os PVs precisam ser criados manualmente.

PV (PersistentVolume) e um recurso do cluster que representa o armazenamento. PVC (PersistentVolumeClaim) e o pedido de armazenamento feito pela aplicacao. Quando ha compatibilidade, o PVC faz bind com o PV.

Para compartilhamento entre varios Pods, um PV com NFS pode ser usado, desde que exista um servidor NFS disponivel.

## Exemplos
Exemplo de PV estatico com NFS (ajuste `server` e `path`):
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs
spec:
  capacity:
    storage: 5Gi
  accessModes:
  - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: giropops
  nfs:
    server: 10.0.0.10
    path: /exports/dados
```

Exemplo de PVC usando a StorageClass `giropops`:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-app
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
  storageClassName: giropops
```

## Comandos
```bash
kubectl apply -f storageclass.yaml
kubectl get storageclass
```

## Documentacao oficial
- https://kubernetes.io/docs/concepts/storage/storage-classes/
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- https://kubernetes.io/docs/concepts/storage/volumes/
- https://kubernetes.io/docs/concepts/storage/volumes/#nfs
