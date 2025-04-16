# Trabalho Final

## Descrição 

Nesse trabalho final você vai testar a transferencia de dados entre um EFS e um S3. 
Vai gerar evidencias e submeter no portal da FIAP

## Objetivo

Os seguintes testes devem ser executada dentro da EC2 que foi criada pelo terraform:

##### 1. Com um arquivo de 5GB dentro do EFS
  - Utilize as seguintes configurações do cliente do S3
    - 1 Thread concorrente
    - 64MB de Mutlipart Threshold
    - 16MB de Chunk Size
  - Teste a transferencia de dados entre o EFS e o S3
    - Tire print do resultado
  - Execute o mesmo teste, mas com 5 Threads concorrentes no cliente do S3
    - Tire print do resultado
    
##### 2. Crie um arquivo de 1GB dentro do EFS
  - Utilize as seguintes configurações do cliente do S3
    - 1 Thread concorrente
    - 64MB de Mutlipart Threshold
    - 16MB de Chunk Size
  - Teste a transferencia de dados entre o EFS e o S3 utilizando o comando parallel com 5 execuções paralelas
    - Tire print do resultado
  - Execute o mesmo teste, mas com 15 Threads concorrentes no cliente do S3
    - Tire print do resultado

##### 3. Dentro do EFS crie uma pasta chamada sync/ e dentro dela crie 2000 arquivos de 1Mb cada
  -  Com cliente do S3 com apenas 1 Thread concorrente
    - Execute o comando sync para a pasta `sync/` do EFS para o S3
     - Tire print do resultado
  - Com cliente do S3 com 10 Thread concorrentes
    - Execute o comando sync para a pasta `sync/` do EFS para o S3
     - Tire print do resultado


### Como subir o ambiente

1. Execute os comandos abaixo no codespaces após atualizar as credenciais da AWS no arquivo `~/.aws/credentials`

```bash
cd /workspaces/fiap-arquitetura-compute-e-storage/04-Trabalho-Final/infraestrutura
export bucketState=$(aws s3 ls | awk '/base-config-/ {print $3; exit}')
sed -i "s/base-config-SEU_RM/$bucketState/g" state.tf
terraform init
terraform apply -auto-approve
```
2. Entre no console EC2 e conecte-se na instância criada pelo terraform para o trabalho final

3. Verifique que o EFS esta instalado, senão volte a demo do EFS e copie os comandos para arrumar.
4. Para facilitar os comandos do trabalho final, execute os comandos abaixo para guardar o nome do bucket recém criado e instalar o parallel
```bash
export bucket=$(aws s3 ls | awk '/trabalho-fiap-/ {print $3; exit}')
echo $bucket
sudo yum update -y
sudo yum install -y parallel
```


### Entregável

- Monte um zip com todos os prints requisitados durante os testes
  - Além dos prints já requisitados, tire os seguintes prints:
    - Entre no EFS e tire um print de quanto storage esta sendo utilizado
    - Entre no S3 e tire um prints dos conteudos gerados durante o trabalho

### Dicas

- Os comandos pedidos já foram executados com outra fonte na [demo do s3](../02-Storage/01-Storage-de-Objetos/README.md) e na [demo EFS](../02-Storage/02-Network-file-system/README.md)

- Nos prints, mostre que os comandos foram executados de dentro da pasta do EFS
- O terraform executado acima já cria o bucket do S3, o EFS, e a instância EC2 do tipo c5.large já configurada com o EFS, não é necessário criar mais nada
- Ao terminar o trabalho, retorne ao codespaces e execute um **terraform destroy** para não ficar com a conta da AWS suja