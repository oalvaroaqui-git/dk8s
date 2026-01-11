# Dia 6

Armazenamento no Kubernetes: volumes, PV, PVC e StorageClass.

## Objetivo
- Entender volumes e persistencia de dados.
- Revisar PV, PVC e StorageClass.
- Usar StorageClass com provisionamento estatico (no-provisioner).

## Arquivos
- `storageclass.yaml`: StorageClass `giropops` com `kubernetes.io/no-provisioner` e `WaitForFirstConsumer`.

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
