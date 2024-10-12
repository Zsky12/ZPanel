#!/bin/bash

# Atualizar o sistema
echo "Atualizando o sistema..."
if [ -f /etc/redhat-release ]; then
    # Para CentOS
    sudo yum update -y
    echo "Sistema atualizado."
else
    # Para Ubuntu/Debian
    sudo apt update && sudo apt upgrade -y
    echo "Sistema atualizado."
fi

# Instalar dependências
echo "Instalando dependências..."
if [ -f /etc/redhat-release ]; then
    # Para CentOS
    sudo yum install -y httpd mysql-server php php-mysql php-cli php-pear php-xml php-mbstring
else
    # Para Ubuntu/Debian
    sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql php-cli php-xml php-mbstring
fi
echo "Dependências instaladas."

# Iniciar e habilitar serviços
echo "Iniciando e habilitando serviços..."
if [ -f /etc/redhat-release ]; then
    sudo systemctl start httpd
    sudo systemctl start mysqld
    sudo systemctl enable httpd
    sudo systemctl enable mysqld
else
    sudo systemctl start apache2
    sudo systemctl start mysql
    sudo systemctl enable apache2
    sudo systemctl enable mysql
fi
echo "Serviços iniciados."

# Baixar e instalar o ZPanel
echo "Baixando e instalando o ZPanel..."
cd /tmp
wget http://downloads.zpanelcp.com/zpanel/x/xpanel-install.sh
sudo sh xpanel-install.sh
echo "ZPanel instalado."

# Configuração do MySQL
echo "Configurando o MySQL..."
sudo mysql_secure_installation

# Criar banco de dados e usuário para o ZPanel
echo "Criando banco de dados e usuário para o ZPanel..."
DB_NAME="zpanel"
DB_USER="zpaneluser"

# Solicitar a senha do banco de dados
read -sp "Digite uma senha forte para o banco de dados '$DB_NAME' (usuário: '$DB_USER'): " DB_PASS
echo # Nova linha após a senha

# Criar banco de dados e usuário
sudo mysql -u root -p -e "
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
"

echo "Banco de dados e usuário criados com sucesso."

# Finalizar
echo "Instalação concluída! Acesse o ZPanel em http://seu_ip/zpanel"
