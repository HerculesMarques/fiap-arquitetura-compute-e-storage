#!/bin/bash

echo "🧼 Atualizando o sistema..."
# Evita prompt do needrestart
sudo sed -i 's/^#\$nrconf{restart} =.*/\$nrconf{restart} = "l";/' /etc/needrestart/needrestart.conf
# Atualiza o sistema sem interação
sudo apt update -y && sudo apt upgrade -y

sudo apt install -y build-essential git curl wget unzip sysbench python3

echo "🟢 Instalando Node.js"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs  