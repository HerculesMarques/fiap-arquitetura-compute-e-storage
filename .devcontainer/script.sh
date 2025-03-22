#!/bin/bash
set -eux
sudo apt-get update -y 
npm i serverless@3.39.0 -g
mkdir -p ~/.aws/
cp /workspaces/fiap-arquitetura-compute-e-storage/.devcontainer/config ~/.aws/config