# 🚀 Laboratório: Aplicação no ECS com Fargate (AWS Academy)

Este laboratório implanta uma aplicação Node.js no ECS utilizando Fargate, totalmente compatível com o ambiente da AWS Academy.

## ✅ Pré-requisitos

- Conta ativa na AWS Academy Learner Lab
- Docker instalado localmente
- AWS CLI configurado com credenciais temporárias
- Terraform instalado

## 📦 Etapas

### 1. Clone este repositório

```bash
git clone https://github.com/SEU_USUARIO/aws-ecs-fargate-lab.git
cd aws-ecs-fargate-lab
```

### 2. Construa e envie a imagem para o ECR

```bash
terraform -chdir=terraform init
terraform -chdir=terraform apply -var="subnet_id=subnet-xxxxxxxx" -var="security_group_id=sg-xxxxxxxx"

# Faça login no ECR
ECR_REPO_URL=$(aws ecr describe-repositories --repository-name ecs-fargate-lab | jq .repositories[0].repositoryUri -r)
aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REPO_URL

# Construa e envie a imagem
cd app
docker build -t ecs-fargate-lab .
docker tag ecs-fargate-lab:latest $ECR_REPO_URL:latest
docker push $ECR_REPO_URL:latest
```

### 3. Crie os recursos ECS + Fargate

```bash
terraform -chdir=terraform apply -var="subnet_id=subnet-xxxxxxxx" -var="security_group_id=sg-xxxxxxxx"
```

### 4. Acesse a aplicação

Pegue o IP público da task no console do ECS e acesse:

```
http://<public-ip>:3000
```

## 📘 Recursos úteis

- [Documentação Amazon ECS](https://docs.aws.amazon.com/ecs/latest/userguide/what-is-ecs.html)
- [Documentação AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html)
