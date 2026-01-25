# Dia 8

Secrets e ConfigMaps no Kubernetes: gerenciamento de dados sensiveis e configuracoes de forma segura e reutilizavel.

## Objetivo
- Criar, listar, descrever e remover Secrets.
- Codificar dados sensiveis em base64.
- Montar Secrets em Pods (env vars e volumes).
- Criar e usar ConfigMaps para configuracao.
- Montar ConfigMaps em volumes e usar em env vars.
- Combinar ConfigMap + Secret para configurar o Nginx com HTTPS.

## Arquivos
- `giropops-secret.yaml`: Secret Opaque com usuario/senha em base64.
- `dockerhub-secret.yaml`: Secret para imagem privada (imagePullSecret).
- `pod-usando-imagem-privada.yaml`: Pod que usa imagePullSecret.
- `pod-secret.yaml`: Pod que consome Secret via env vars.
- `nginx.conf`: configuracao do Nginx.
- `nginx-config.yaml`: ConfigMap com o `nginx.conf` embutido.
- `certificado.crt`: certificado TLS.
- `chave-privada.key`: chave privada TLS.
- `meu-servico-web-tls-secret.yaml`: Secret com certificado e chave.
- `pod-configmap-secret.yaml`: Pod do Nginx montando ConfigMap + Secret.

---

## 🧪 Comandos

### Secrets
```sh
# base64 para montar o Secret manualmente
echo -n "seu_usuario" | base64
echo -n "sua_senha" | base64

# aplicar e inspecionar
kubectl apply -f giropops-secret.yaml
kubectl get secret
kubectl describe secret giropops-secret

# usar em Pod via env vars
kubectl apply -f pod-secret.yaml

# remover
kubectl delete -f giropops-secret.yaml
```

### Secret para imagem privada
```sh
# aplicar e usar imagePullSecret
kubectl apply -f dockerhub-secret.yaml
kubectl apply -f pod-usando-imagem-privada.yaml

# debug de erro de pull
kubectl describe pod <nome-do-pod>
```

### ConfigMaps
```sh
# criar a partir de arquivo
kubectl create configmap nginx-config --from-file=nginx.conf

# aplicar via manifesto
kubectl apply -f nginx-config.yaml
kubectl get configmap
kubectl describe configmap nginx-config

# tornar imutavel (via manifesto)
kubectl apply -f nginx-config.yaml
```

### ConfigMap + Secret no Nginx (HTTPS)
```sh
# secret com certificado e chave
kubectl apply -f meu-servico-web-tls-secret.yaml

# pod com mounts de config e tls
kubectl apply -f pod-configmap-secret.yaml
kubectl get pod giropops-pod -o wide
kubectl logs giropops-pod -c giropops-container
```

---

## 🔐 Secrets

**Secrets** permitem armazenar informacoes sensiveis (senhas, tokens, chaves, certificados) com mais seguranca e controle de acesso.

O fluxo visto:
- Criar Secret com dados em base64.
- Validar com `get` e `describe`.
- Usar como variaveis de ambiente em Pods.
- Remover quando necessario.

Exemplo (env var a partir de Secret):
```yaml
env:
  - name: USERNAME
    valueFrom:
      secretKeyRef:
        name: giropops-secret
        key: username
```

---

## 🧰 ConfigMaps

**ConfigMaps** separam configuracoes do container, permitindo a mesma imagem rodar em dev, teste e prod com parametros diferentes.

O fluxo visto:
- Criar ConfigMap com arquivo de configuracao.
- Atualizar ConfigMap quando a configuracao muda.
- Usar ConfigMap como arquivo montado no Pod.
- Tornar ConfigMaps imutaveis quando fizer sentido.

Exemplo (volume com ConfigMap):
```yaml
volumes:
  - name: nginx-config-volume
    configMap:
      name: nginx-config
```

---

## 🔒 Nginx com HTTPS (ConfigMap + Secret)

Combinamos os dois recursos:
- **ConfigMap** armazena o `nginx.conf`.
- **Secret** armazena o certificado TLS e a chave privada.

No Pod, montamos:
- `/etc/nginx/nginx.conf` a partir do ConfigMap.
- `/etc/nginx/tls` a partir do Secret.

Exemplo (mounts):
```yaml
volumeMounts:
  - name: nginx-config-volume
    mountPath: /etc/nginx/nginx.conf
    subPath: nginx.conf
  - name: nginx-tls
    mountPath: /etc/nginx/tls
```

---

## ✅ Resultado

Essa combinacao entrega:
- **Seguranca** para dados sensiveis.
- **Flexibilidade** para configuracoes por ambiente.
- **Reuso** da mesma imagem com diferentes parametros.
- **Controle** por manifesto YAML.

---

## 📚 Documentacao oficial

- Secrets: https://kubernetes.io/docs/concepts/configuration/secret/
- ConfigMaps: https://kubernetes.io/docs/concepts/configuration/configmap/
- Usar ConfigMap em Pod: https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
- Pull de imagem privada: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
- Secret TLS: https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets
- Nginx HTTPS: https://nginx.org/en/docs/http/configuring_https_servers.html
