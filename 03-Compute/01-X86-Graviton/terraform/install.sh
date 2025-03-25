#!/bin/bash

echo "🧼 Atualizando o sistema..."
sudo DEBIAN_FRONTEND=noninteractive apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo apt install -y build-essential git curl wget unzip sysbench python3

echo "🟢 Instalando Node.js"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs  