#!/bin/bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='p@ssw0rd'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache2 and php5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install -y php5-mysql
sudo apt-get install -y php5-gd

 setup hosts file

VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/docroot"
    <Directory "/var/www/docroot">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# remove default html folder
sudo rm -rf /var/www/html

# enable mod_rewrite
sudo a2enmod rewrite

# change apache2 user and group
sudo sed -i -- 's/${APACHE_RUN_USER}/vagrant/g' /etc/apache2/apache2.conf
sudo sed -i -- 's/${APACHE_RUN_GROUP}/vagrant/g' /etc/apache2/apache2.conf

# enable allow_url_include
sudo sed -i -- 's/allow_url_include = Off/allow_url_include = On/g' /etc/php5/apache2/php.ini

# restart apache
service apache2 restart

# install vim
sudo apt-get -y install vim
sudo echo ':set number' > /home/vagrant/.vimrc
sudo echo ':syntax on' >> /home/vagrant/.vimrc

# modify .bashrc
sudo sed -i -- 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/vagrant/.bashrc
sudo sed -i -- "s/#alias ll='ls -l'/alias ll='ls -l'/g" /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# install git
sudo apt-get install -y git

# install dvwa
cd /var/www/docroot
git clone https://github.com/ethicalhack3r/DVWA.git .

# recaptcha
sudo sed -i -- "s/''/'6LdK7xITAAzzAAJQTfL7fu6I-0aPl8KHHieAT_yJg'/g" /var/www/docroot/config/config.inc.php
sudo sed -i -- "s/'6LdK7xITAAzzAAJQTfL7fu6I-0aPl8KHHieAT_yJg'/'6LdK7xITAzzAAL_uw9YXVUOPoIHPZLfw2K1n5NVQ'/g" /var/www/docroot/config/config.inc.php