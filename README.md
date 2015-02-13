symfony2-bootstrap
==================

Let's get crackin' edition


## Characteristics

### Vagrant box
* Ubuntu 14.04 x64
* 2048 MB of RAM
* 10.10.10.10 private IP address
* SSH forward agent enabled
* Virtualbox name: symfonydev

### Installed software
* nginx properly configured to serve the project's index page (remember to edit the /etc/hosts file in your host machine)
* PHP (FPM & CLI) 5.5 with intl and xdebug modules (already configured)
* MySQL client and server (root password: root)
* Symfony installer and Composer are installed as global commands
* Misc. software: git, tree, htop
* Misc global commands: boris (PHP REPL) and php-cs-fixer

## Requirements
* A recent version of VirtualBox
* A recent version of Vagrant
* Ubuntu packages ```nfs-common``` and ```nfs-kernel-server``` or equivalent

## Setup in 4 steps

```bash
$ git clone git@github.com:Jautenim/symfony-bootstrap.git
$ cd symfony-bootstrap
# Edit PROJECT variable to change the default project name in provisioning.sh script
$ vagrant up
```

