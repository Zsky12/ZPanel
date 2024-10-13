#!/bin/bash

# Atualizar pacotes
sudo apt update && sudo apt upgrade -y

# Instalar Nginx
sudo apt install nginx -y

# Instalar PHP e extensões necessárias
sudo apt install php-fpm php-mysql -y

# Instalar phpMyAdmin
sudo apt install phpmyadmin -y

# Configurar Nginx para phpMyAdmin
cat <<EOL | sudo tee /etc/nginx/conf.d/phpmyadmin.conf
server {
    listen 80;
    server_name localhost;

    root /usr/share/phpmyadmin;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;  # Altere para sua versão do PHP
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Reiniciar o Nginx
sudo systemctl restart nginx

# Liberar as portas do firewall
sudo ufw allow 'Nginx Full'

# Habilitar o firewall
sudo ufw enable

echo "Instalação do phpMyAdmin e Nginx concluída. Acesse o phpMyAdmin em http://<seu_endereço_ip>/"
