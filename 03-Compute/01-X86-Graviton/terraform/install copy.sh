#!/bin/bash

echo "🧼 Atualizando o sistema..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y build-essential git curl wget unzip sysbench python3

echo "🟢 Instalando Node.js"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

echo "🧪 Teste de CPU com Sysbench"
sysbench cpu --cpu-max-prime=20000 --time=10 run

echo "💾 Teste de Memória com Sysbench"
sysbench memory --memory-block-size=1M --memory-total-size=10G run

echo "📦 Gerando arquivo de 1GB para teste de compressão"
mkdir -p teste-arquivo && cd teste-arquivo
dd if=/dev/urandom of=testfile.bin bs=1M count=1024

echo "🗜️  Testando compressão com gzip"
time gzip testfile.bin

echo "🗜️  Apagando pasta do teste"
cd ..
rm -rf teste-arquivo

echo "🐍 Teste com Python - cálculo de Fibonacci"
cat << 'EOF' > cpustress.py
import time

def fib(n):
    if n <= 1:
        return n
    else:
        return fib(n-1) + fib(n-2)

start = time.time()
print(f"Fibonacci(40): {fib(40)}")
print(f"Execution Time: {time.time() - start} seconds")
EOF

python3 cpustress.py

echo "🟦 Teste com Node.js - hash SHA256"
cat << 'EOF' > hash.js
const crypto = require('crypto');

console.time('hash');
for (let i = 0; i < 1e7; i++) {
  crypto.createHash('sha256').update('AWS Academy').digest('hex');
}
console.timeEnd('hash');
EOF

node hash.js

echo "🔍 Informações do processador:"
lscpu

echo "✅ Testes concluídos!"
