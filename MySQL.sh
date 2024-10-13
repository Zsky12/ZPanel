#!/bin/bash

# Atualizar pacotes e instalar Apache
sudo apt update -y
sudo apt upgrade -y
sudo apt install apache2 -y

# Instalar MySQL Server e configurar senha root
sudo apt install mysql-server -y
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '35#Av@a5ka';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Instalar PHP e extensões necessárias
sudo apt install php libapache2-mod-php php-mysql php-curl php-json php-cgi php-cli php-gd php-zip php-mbstring php-xml php-common -y

# Instalar phpMyAdmin
sudo apt install phpmyadmin -y

# Configurar o phpMyAdmin
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Configurar permissões para a pasta www
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Liberar pasta www publicamente
sudo ufw allow in "Apache Full"

# Reiniciar Apache para aplicar alterações
sudo systemctl restart apache2

echo "Instalação concluída! Apache, MySQL, PHP e phpMyAdmin foram configurados."
