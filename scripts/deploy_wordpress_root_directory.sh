#!/bin/bash

# Configuramos el script para que se muestren los comando
# y finalice cuando hay un error en la ejecucion
set -ex

# Importamos el archivo .env
source .env

# Eliminamos descargas previas de WordPress
rm -rf /tmp/latest.tar.gz

# Descargamos la última versión de WordPress con el comando wget.
wget http://wordpress.org/latest.tar.gz -P /tmp

# Descomprimimos el archivo .tar.gz que acabamos de descargar con el comando tar. (Descomprimimos el código fuente de WordPress)
tar -xzvf /tmp/latest.tar.gz -C /tmp

# Eliminamos instalaciones previas en /var/www/html
rm -rf /var/www/html/*

# El contenido se ha descomprimido en una carpeta que se llama wordpress. Ahora, movemos el contenido de /tpm/wordpress a /var/www/html.
mv -f /tmp/wordpress/* /var/www/html

# Creamos la base de datos y el usuario para WordPress.
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

# Creamos un archivo de configuración wp-config.php a partir del archivo de ejemplo wp-config-sample.php.
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# En este paso tenemos que configurar las variables de configuración del archivo de configuración de WordPress.
sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

# Cambiamos el propietario y el grupo al directorio /var/www/html.
chown -R www-data:www-data /var/www/html/
