#!/bin/bash


#UPDATE THE PACKAGE REPOSITORY AND UPGRADE THE SYSTEM

sudo apt-get update && sudo apt-get upgrade -y < /dev/null


# INSTALLATION OF LAMP STACK

sudo apt-get install apache2 -y < /dev/null

# Start Apache and enable it to start on boot
systemctl start apache2 < /dev/null

systemctl enable apache2 < /dev/null

sudo apt-get install mysql-server -y < /dev/null

sudo add-apt-repository -y ppa:ondrej/php < /dev/null

sudo apt-get update < /dev/null

sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y < /dev/null

sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini

sudo systemctl restart apache2 < /dev/null

echo "LAMP stack installation is complete."


#INSTALLING ANSIBLE

sudo apt update

sudo apt install ansible


#INSTALLING COMPOSER

sudo apt-get install curl -y

curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar /usr/local/bin/composer

composer --version < /dev/null



#CONFIGURING APACHE2

cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin fcakagha9943@gmail.com
    ServerName 192.168.20.31
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

#enable site and restart apache2
sudo a2enmod rewrite

sudo a2ensite laravel.conf

sudo systemctl restart apach2.service




# CLONING THE LARAVEL GIT REPOSITORY

mkdir /var/www/html/laravel

cd /var/www/html && sudo git clone https://github.com/laravel/laravel.git

cd /var/www/html/laravel && composer install --no-dev < /dev/null


# Change ownership of the Laravel directory to the user and group (vagrant and www-data)
sudo chown -R vagrant:www-data /var/www/html/laravel

# Changing file permissions to restrict write access
sudo chmod -R 775 /var/www/html/laravel

sudo chmod -R 775 /var/www/html/laravel/storage

sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache

cd /var/www/html/laravel 

sudo cp .env.example .env

php artisan key:generate




#CONFIGURING MYSQL AND SETTING USER, DATABASE & PASSWORD

echo "Creating MYSQL user, database and password"

PASS=$2
if [ -z "$2" ]; then
  PASS=`openssl rand -base64 8`
fi

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CRAETE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "Mysql user, database and password are set."
echo "Username:   $1"
echo "Database:   $1"
echo "Password:   $PASS"



#EXECUTE KEY GENERATE AND MIGRATE COMMAND FOR PHP

sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=favour/' /var/www/html/laravel/.env

sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=favour/' /var/www/html/laravel/.env

sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=favour99@/' /var/www/html/laravel/.env

php artisan config:cache

cd /var/www/html/laravel

php artisan migrate



