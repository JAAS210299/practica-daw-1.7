#!/bin/bash

# Configuramos el script para que se muestren los comando
# y finalice cuando hay un error en la ejecucion
set -ex

# Importamos el archivo .env
source .env

# 1 - Realizamos la instalación y actualización de snapd.
snap install core
snap refresh core

# 2 - Eliminamos si existiese alguna instalación previa de certbot con apt.
sudo apt remove certbot -y

# 3 - Instalamos el cliente de Certbot con snapd.
snap install --classic certbot

# 4 - Creamos una alias para el comando certbot.
ln -fs /snap/bin/certbot /usr/bin/certbot

# 5 - Solicitamos un certificado en Let'S Encript
certbot --apache -m $LE_EMAIL --agree-tos --no-eff-email -d $LE_DOMAIN --non-interactive