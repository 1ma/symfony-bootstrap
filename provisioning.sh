#!/bin/bash

### System configuration
# set box locale
locale-gen en_US && update-locale LANG=en_US
export LANG=en_US.UTF-8

# set hostname
echo "dev" > /etc/hostname

# set hosts
echo "127.0.0.1 symfony.dev" >> /etc/hosts


### install miscellaneous software
apt-get update -y
apt-get install -y python-software-properties curl tree htop git nfs-common portmap


### register third party PPAs
add-apt-repository ppa:git-core/ppa
add-apt-repository ppa:nginx/stable
add-apt-repository ppa:chris-lea/node.js
apt-get update -y


### Frontend dev tools (npm, bower, less, uglify) and maildev installation
apt-get install -y nodejs

npm install -g bower
npm install -g less@1.7.5
npm install -g uglify-js
npm install -g uglifycss
npm install -g maildev
echo -e "\nstart on filesystem or runlevel [2345]\nstop on run level [!2345]\nexec maildev" > /etc/init/maildev.conf
start maildev


### MySQL configuration
# install MySQL server, client and set root username and password
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
apt-get install -y mysql-client mysql-server


### PHP configuration
# install PHP 5.5 required packages
apt-get install -y php5-fpm php5-cli php5-curl php5-intl php5-mysql php5-xdebug php5-apcu

# configure php.ini variables
echo "intl.default_locale = en" >> /etc/php5/mods-available/intl.ini

echo "date.timezone = UTC" > /etc/php5/mods-available/date.timezone.ini
ln -s /etc/php5/mods-available/date.timezone.ini /etc/php5/cli/conf.d/00-date.timezone.ini
ln -s /etc/php5/mods-available/date.timezone.ini /etc/php5/fpm/conf.d/00-date.timezone.ini

echo "short_open_tag = Off" > /etc/php5/mods-available/short_open_tag.ini
ln -s /etc/php5/mods-available/short_open_tag.ini /etc/php5/cli/conf.d/00-short_open_tag.ini
ln -s /etc/php5/mods-available/short_open_tag.ini /etc/php5/fpm/conf.d/00-short_open_tag.ini

# configure xdebug.ini
cat << EOF >> /etc/php5/fpm/conf.d/20-xdebug.ini
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.show_local_vars=0
xdebug.var_display_max_data=10000
xdebug.var_display_max_depth=20
xdebug.show_exception_trace=0
xdebug.max_nesting_level=250
xdebug.remote_autostart=1
EOF

# configure apcu.ini
cat << EOF >> /etc/php5/fpm/conf.d/20-apcu.ini
apc.enabled=1
apc.shm_size=32M
apc.ttl=7200
EOF

# restart php5-fpm service
service php5-fpm restart


### NGINX configuration
# install NGINX webserver
apt-get install -y nginx

# remove default vhost
rm /etc/nginx/sites-enabled/default

# setup project vhost
cat << EOF > /etc/nginx/sites-available/symfony
server {
  server_name symfony.dev;

  root /vagrant/web;

  location / {
    try_files $uri /app.php$is_args$args;
  }

  location ~ ^/(app|app_dev|config)\.php(/|$) {
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_split_path_info ^(.+\.php)(/.*)$;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param HTTPS off;
  }


  error_log /var/log/nginx/symfony_error.log;
  access_log /var/log/nginx/symfony_access.log;
}
EOF

ln -s /etc/nginx/sites-available/symfony /etc/nginx/sites-enabled/symfony

# restart nginx service
service nginx restart


### System packages cleanup
apt-get -y upgrade
apt-get -y autoremove
apt-get -y clean


### Composer configuration
# install composer globally
curl -sS https://getcomposer.org/installer | php && mv composer.phar /bin/composer


### User configuration
# install global command line utilies
su -c "mkdir /home/vagrant/.composer" - vagrant
cat << EOF > /home/vagrant/.composer/composer.json
{
    "require": {
        "d11wtq/boris": "1.0.*",
        "fabpot/php-cs-fixer": "@stable"
    }
}
EOF
chown vagrant:vagrant /home/vagrant/.composer/composer.json

su -c "composer global update" - vagrant

# add $HOME/.composer/vendor/bin to $PATH environment variable
cat << EOF >> /home/vagrant/.profile
export COMPOSER_VENDOR=$HOME/.composer/vendor
export PATH=$PATH:$COMPOSER_VENDOR/bin
EOF
chown vagrant:vagrant /home/vagrant/.profile

# add useful aliases in vagrant user's .bashrc
cat << EOF >> /home/vagrant/.bashrc
alias sf='php /vagrant/app/console'
alias my='mysql -u root -proot -D symfony'
alias wipedev='rm -rf /vagrant/app/cache/dev/* && time sf cache:clear --env=dev --no-warmup'
alias wipeprod='rm -rf /vagrant/app/cache/prod/* && time sf cache:clear --env=prod --no-debug'

cd /vagrant
EOF
chown vagrant:vagrant /home/vagrant/.bashrc


### Project setup
# Symfony installer
curl -LsS http://symfony.com/installer > /usr/bin/symfony
chmod +x /usr/bin/symfony

# setup brand new Symfony project in Vagrant shared folder
symfony new /tmp/symfony-bootstrap
shopt -s dotglob # .hidden files wouldn't be moved otherwise
mv /tmp/symfony-bootstrap/* /vagrant/
shopt -u dotglob
rm -rf /tmp/symfony-bootstrap
