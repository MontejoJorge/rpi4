#!/bin/bash

# Verificar si tiene permisos de root
if [[ $(id -u) -ne 0 ]]; then
   echo "Este script debe ser ejecutado con permisos de root."
   exit 1
fi

# Actualizar
apt update
apt upgrade -y

# Instalar Git y Curl
apt install -y git curl

# Instalar Docker
curl -sSL https://get.docker.com/ | sh

echo "Instalación completa"
