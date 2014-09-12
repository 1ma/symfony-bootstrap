symfony2-bootstrap
==================

Let's get crackin' edition


## Characteristics

### Vagrant box
* Ubuntu 14.04 x64
* 2048 MB of RAM
* 10.10.10.10 private IP address
* SSH forward agent enabled
* Shared project root folder at /home/vagrant/project
* Virtualbox name: symfonydev

### Installed software
* nginx properly configured to serve the project at symfony.dev (remember to setup /etc/hosts file in your host machine)
* PHP (FPM & CLI) 5.5 with intl and xdebug modules (already configured)
* MySQL client and server (root password: root / database: symfony)
* Composer installed globally
* Misc. software: git, tree, htop
* Composer global commands: boris, phpunit, php-cs-fixer
* A brand new Symfony 2.5 project at /home/vagrant/project

## Requirements
* A recent version of VirtualBox
* A recent version of Vagrant
* Ubuntu packages ```nfs-common``` and ```nfs-kernel-server``` or equivalent

## Setup in 3 easy steps

```bash
$ git clone git@github.com:Jautenim/symfony-bootstrap.git
$ cd symfony-bootstrap
$ vagrant up
```

