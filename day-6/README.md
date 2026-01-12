# Dia 6

Armazenamento no Kubernetes: volumes, PV, PVC e StorageClass.

## Objetivo
- Entender volumes e persistencia de dados.
- Revisar PV, PVC e StorageClass.
- Usar StorageClass com provisionamento estatico (no-provisioner).

## Arquivos
- `storageclass.yaml`: StorageClass `giropops` com `kubernetes.io/no-provisioner` e `WaitForFirstConsumer`.
- `pv.yml`: exemplo de PersistentVolume (PV) estatico para uso em laboratorio.
- `storageclass-nfs.yaml`: StorageClass `nfs` (sem provisionamento automatico).
- `pv-nfs.yml`: PV estatico usando NFS.

Em **Kubernetes**, **Volumes** são o mecanismo usado para **fornecer armazenamento para os containers** de um Pod. Eles resolvem um problema fundamental dos containers: **o sistema de arquivos de um container é efêmero** (os dados somem quando o container reinicia).

👉 Em resumo: **volumes permitem persistir e compartilhar dados** entre containers e reinícios.

---

## 🧠 Por que volumes existem?

Sem volumes:

* Dados são perdidos quando o container reinicia
* Containers no mesmo Pod não conseguem compartilhar arquivos facilmente

Com volumes:

* 📦 Persistência de dados
* 🔄 Compartilhamento entre containers do mesmo Pod
* 🔐 Injeção de configurações e segredos
* ☁️ Integração com storages externos (NFS, cloud, etc.)

---

## 📦 O que é um Volume no Kubernetes?

Um **Volume**:

* É definido **no nível do Pod**
* Pode ser montado em **um ou mais containers**
* Vive **enquanto o Pod existir** (a menos que seja um volume persistente)

📌 Importante: o volume **não pertence ao container**, pertence ao **Pod**.

---

## 🧩 Tipos de volumes mais comuns

### 🔹 `emptyDir`

* Criado quando o Pod inicia
* Apagado quando o Pod é removido
* Usado para cache ou arquivos temporários

```yaml
volumes:
- name: cache
  emptyDir: {}
```

---

### 🔹 `hostPath`

* Usa um diretório do nó (host)
* Forte acoplamento com o node
* Pouco recomendado em produção

```yaml
volumes:
- name: host-data
  hostPath:
    path: /data
```

---

### 🔹 `configMap`

* Injeta arquivos de configuração
* Ideal para configs de aplicações

```yaml
volumes:
- name: config
  configMap:
    name: app-config
```

---

### 🔹 `secret`

* Injeta dados sensíveis (senhas, tokens)
* Conteúdo é base64 no etcd

```yaml
volumes:
- name: secrets
  secret:
    secretName: db-secret
```

---

### 🔹 `persistentVolumeClaim (PVC)`

* Forma padrão de **persistência de dados**
* Desacoplado do Pod e do Node
* Usa um **PersistentVolume (PV)** por baixo

```yaml
volumes:
- name: data
  persistentVolumeClaim:
    claimName: app-pvc
```

---

## 🗄️ PV e PVC (conceito essencial)

### 📀 PersistentVolume (PV)

* Recurso de cluster
* Representa um storage real (EBS, NFS, Ceph, etc.)

### 📄 PV do repositorio (`pv.yml`)

O arquivo `pv.yml` define um PV simples. Principais campos:

- `capacity.storage`: capacidade do volume (ex: `1Gi`).
- `accessModes`: modo de acesso (ex: `ReadWriteOnce`).
- `persistentVolumeReclaimPolicy`: o que fazer com o volume ao liberar o PVC (`Retain` mantem os dados).
- `storageClassName`: classe de storage usada para vinculo do PVC.
- `hostPath.path`: caminho no node (apenas para laboratorio, nao indicado em producao).

### 📄 PV com NFS do repositorio (`pv-nfs.yml`)

O arquivo `pv-nfs.yml` e um exemplo de PV usando NFS. Campos principais:

- `nfs.server`: IP do servidor NFS (substitua pelo seu).
- `nfs.path`: diretorio exportado (ex: `/mnt/nfs`).
- `storageClassName`: classe `nfs` definida em `storageclass-nfs.yaml`.

---

## 🧰 Preparando um servidor NFS (exemplo)

1) Criar o diretorio exportado:
```bash
mkdir /mnt/nfs
```

2) Instalar os pacotes:
```bash
sudo apt-get install nfs-kernel-server nfs-common
```

3) Editar o arquivo `/etc/exports` e adicionar:
```
/mnt/nfs *(rw,sync,no_root_squash,no_subtree_check)
```

Onde:
- `/mnt/nfs`: diretorio compartilhado.
- `*`: permite qualquer host (troque por CIDR/IPs para maior seguranca).
- `rw`: leitura e escrita.
- `sync`: grava no disco antes de confirmar.
- `no_root_squash`: root do cliente acessa como root.
- `no_subtree_check`: desativa checagem de subarvore.

4) Aplicar as configuracoes e verificar:
```bash
sudo exportfs -ar
showmount -e
```

### 📄 PersistentVolumeClaim (PVC)

* Pedido de storage feito pelo Pod
* Define tamanho, modo de acesso, storageClass

📌 O Pod **nunca usa PV diretamente**, sempre usa **PVC**.

---

## 🔄 Ciclo de vida dos volumes

| Tipo               | Sobrevive a restart do container? | Sobrevive a recriação do Pod? |
| ------------------ | --------------------------------- | ----------------------------- |
| emptyDir           | ✅                                 | ❌                             |
| hostPath           | ✅                                 | ⚠️ depende do node            |
| ConfigMap / Secret | ✅                                 | ❌                             |
| PVC                | ✅                                 | ✅                             |

---

## 🛠️ Exemplo completo

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: app-pvc
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: data
      mountPath: /usr/share/nginx/html
```

---

## Comandos
```bash
kubectl apply -f storageclass.yaml
kubectl apply -f pv.yml
kubectl apply -f storageclass-nfs.yaml
kubectl apply -f pv-nfs.yml
kubectl get storageclass
kubectl get pv
```

---

## 📌 Boas práticas

* ✅ Use **PVC + StorageClass** em produção
* ❌ Evite `hostPath`
* 🔐 Use `Secret` para dados sensíveis
* 📁 Separe volumes por responsabilidade (dados, config, cache)

---

## Documentacao oficial
- https://kubernetes.io/docs/concepts/storage/storage-classes/
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- https://kubernetes.io/docs/concepts/storage/volumes/
- https://kubernetes.io/docs/concepts/storage/volumes/#nfs
- https://kubernetes.io/docs/concepts/storage/volumes/#hostpath
- https://ubuntu.com/server/docs/network-file-system
