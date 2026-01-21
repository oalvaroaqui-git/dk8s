# Dia 7

StatefulSet no Kubernetes: controlador para aplicacoes stateful que precisam manter estado, identidade e conexoes mesmo com restart, rescale ou recriacao de Pods.

![Image](https://miro.medium.com/v2/resize%3Afit%3A1200/1%2AHlgT4PgRsjrHj30vihI5Fw.png)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1200/1%2Ay02_WQcb6DUugimnodPSxw.png)

![Image](https://miro.medium.com/1%2AL7ubANy6JIPcKCBo7E4JcA.png)

---

## 📦 O que torna um StatefulSet diferente?

Diferente de um **Deployment**, o **StatefulSet** garante:

### 1️⃣ Identidade estavel

- Nome fixo: `app-0`, `app-1`, `app-2`
- Hostname estavel
- Mantem identidade mesmo apos restart

Exemplo:
```
meu-app-0
meu-app-1
meu-app-2
```

### 2️⃣ Armazenamento persistente por Pod

Cada Pod recebe seu proprio **PersistentVolumeClaim (PVC)**:

- Se o Pod morrer, os dados permanecem
- Novo Pod sobe usando o mesmo volume

Essencial para bancos de dados, filas e sistemas distribuidos com estado local.

### 3️⃣ Ordem garantida

Criacao, escala e remocao em ordem:

- Criacao: `app-0 → app-1 → app-2`
- Remocao: `app-2 → app-1 → app-0`

### 4️⃣ Service Headless obrigatorio

StatefulSets usam **Headless Service** (`clusterIP: None`) para DNS estavel:

```
meu-app-0.meu-service.default.svc.cluster.local
```

---

## 🧠 Quando usar StatefulSet?

Use quando a aplicacao precisa de:

✅ Dados persistentes  
✅ Identidade unica por instancia  
✅ Ordem de inicializacao/desligamento  
✅ Comunicacao direta entre replicas

Exemplos:
- Bancos de dados: PostgreSQL, MySQL, MongoDB
- Sistemas distribuidos: Kafka, ZooKeeper, Elasticsearch
- Cache stateful: Redis (cluster/sentinel)

---

## 🚫 Quando NAO usar StatefulSet?

- Aplicacoes stateless (APIs, frontends)
- Servicos que nao dependem de identidade
- Quando um Deployment resolve

---

## ⚔️ StatefulSet vs Deployment (resumo)

| Caracteristica    | StatefulSet   | Deployment     |
| ----------------- | ------------- | -------------- |
| Identidade do Pod | Estavel       | Aleatoria      |
| Volume por Pod    | Exclusivo     | Compartilhado  |
| Ordem de criacao  | Sim           | Nao            |
| Uso tipico        | Stateful apps | Stateless apps |

---

## 📝 Exemplo simples de StatefulSet

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: app
spec:
  serviceName: app-headless
  replicas: 3
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: nginx
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
```

---

## 🧩 Em termos de SRE / Observabilidade

- Monitorar PVCs (latencia, uso de disco, erros)
- Alertas para Pods presos em `Pending`
- Tempo de rollout (ordem pode atrasar deploys)
- Backups por volume (nao so por aplicacao)

---

## 🌐 Services no Kubernetes (conceitos e exemplos)

Um **Service** fornece um IP e DNS estaveis para acessar Pods, fazendo balanceamento entre replicas via `selector`.

### 1️⃣ ClusterIP (padrao)

Exposicao **interna** no cluster.

Exemplo (`day-7/nginx-clusterip-svc.yaml`):
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

### 2️⃣ NodePort

Exposicao via uma **porta fixa** em cada Node.

Exemplo (`day-7/nginx-nodeport-svc.yaml`):
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 32000
  type: NodePort
```

### 3️⃣ LoadBalancer

Exposicao via **load balancer** externo (quando o ambiente suporta).

Exemplo (`day-7/nginx-loadbalancer-svc .yaml`):
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-loadbalancer
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

Observacao: em **kind**, o `LoadBalancer` nao recebe IP externo sem add-ons (ex: MetalLB).

### 4️⃣ Headless Service

Usado para **DNS estavel** por Pod, comum em StatefulSets.

Exemplo (`day-7/nginx-headless-svc.yaml`):
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-headless
spec:
  clusterIP: None
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
```

### ✅ Testes rapidos

ClusterIP:
```bash
kubectl port-forward svc/nginx 8080:80
curl http://localhost:8080
```

NodePort:
```bash
kubectl get nodes -o wide
curl http://<node-ip>:32000
```

No kind (ex: contexto `kind-girus`), geralmente funciona direto:
```bash
curl http://localhost:32000
```

LoadBalancer:
```bash
kubectl get svc nginx-loadbalancer -w
kubectl port-forward svc/nginx-loadbalancer 8081:80
curl http://localhost:8081
```

Headless:
```bash
kubectl get svc nginx-headless
kubectl get endpoints nginx-headless
```

---

## Comandos

```bash
kubectl apply -f statefulset.yaml
kubectl get statefulsets
kubectl get pods -l app=app
kubectl describe pod app-0
kubectl get pvc
kubectl get svc
```

---

## Documentacao oficial

- https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
- https://kubernetes.io/docs/concepts/services-networking/service/#headless-services
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/
