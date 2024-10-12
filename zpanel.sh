#!/bin/bash

# Atualizar e instalar pacotes básicos
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar Apache, MySQL e PHP
echo "Instalando Apache, MySQL e PHP..."
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql php-cli php-xml php-mbstring

# Iniciar e habilitar Apache e MySQL
echo "Iniciando e habilitando Apache e MySQL..."
sudo systemctl start apache2
sudo systemctl start mysql
sudo systemctl enable apache2
sudo systemctl enable mysql

# Configurar senha root do MySQL
echo "Configurando MySQL..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'senha_segura_root'; FLUSH PRIVILEGES;"

# Configuração básica do MySQL Secure Installation
echo "Realizando configurações de segurança no MySQL..."
sudo mysql_secure_installation <<EOF

y
senha_segura_root
senha_segura_root
y
y
y
y
EOF

# Criar banco de dados e usuário para o ZPanel
echo "Configurando banco de dados para o ZPanel..."
mysql -uroot -psenha_segura_root -e "CREATE DATABASE zpanel;"
mysql -uroot -psenha_segura_root -e "CREATE USER 'zpaneluser'@'localhost' IDENTIFIED BY 'senha_zpanel_user';"
mysql -uroot -psenha_segura_root -e "GRANT ALL PRIVILEGES ON zpanel.* TO 'zpaneluser'@'localhost';"
mysql -uroot -psenha_segura_root -e "FLUSH PRIVILEGES;"

# Baixar e instalar o ZPanel
echo "Baixando e instalando o ZPanel..."
cd /tmp
wget http://downloads.zpanelcp.com/zpanel/x/xpanel-install.sh
chmod +x xpanel-install.sh
sudo sh xpanel-install.sh

# Configurar o firewall para permitir acesso HTTP e HTTPS
echo "Configurando o firewall..."
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable

# Reiniciar o Apache para aplicar todas as mudanças
echo "Reiniciando o Apache..."
sudo systemctl restart apache2

# Mensagem de finalização
echo "Instalação concluída. Você pode acessar o ZPanel em http://177.153.51.12/zpanel"
echo "Credenciais padrão para o ZPanel:"
echo "Usuário: admin"
echo "Senha: password" # Você poderá alterar a senha após o primeiro login
