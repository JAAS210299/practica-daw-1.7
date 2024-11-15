#!/bin/bash

# Configuramos el script para que se muestren los comando
# y finalice cuando hay un error en la ejecucion
set -ex

# Importamos el archivo .env
source .env

# Eliminamos descargas previas de WordPress
rm -rf /tmp/wp-cli-phar*

# Descargamos la utilidad WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Asignamos permiso de ejecución
chmod +x /tmp/wp-cli.phar

# Renombramos la utilidad WP-CLI a wp => /usr/local/bin todos lo que esta en este directorio se ejecuta sin tener que poner la ruta 
sudo mv /tmp/wp-cli.phar /usr/local/bin/wp

# Utilizamos el parámetro --path para indicar el directorio donde queremos descargar el código fuente de WordPress. Por ejemplo:
wp core download --locale=es_ES --path=/var/www/html --allow-root

# Creamos la base de datos y el usuario para WordPress.
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

# Creación del archivo de configuración (wp config create)
# Una vez que hemos creado la base de datos, usuario y contraseña en MySQL Server, podemos crear el archivo de configuración wp-config.php para WordPress con el siguiente comando:

wp config create \
  --dbname=$WORPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=localhost \
  --path=/var/www/html \
  --allow-root