#!/bin/bash
set -e

wait () {
    sleep 2
}

setup_user () {
    printf "> Script is currently running under \"$user\".\n"
    wait

    printf "> (A) Type username to use in script, or\n"
    printf "> (B) press enter to run as \"$user\".\n"
    printf ">> Waiting for input: "
    read username
    if [ "$username" != "" ]
    then
        user=$username
        printf "> You entered: \"$user\".\n"
        wait
    fi

    printf "> Using \"$user\" in script.\n"
    wait
}

update_system () {
    printf "> Updating system...\n"
    wait

    printf "> Getting updates...\n"
    wait
    sudo apt update -y

    printf "> Installing updates...\n"
    wait
    sudo apt upgrade -y

    printf ">>> Updates installed.\n"
    wait
}

install_packages () {
    printf "> Installing LEMP stack...\n"
    wait
    sudo apt install mariadb-server nginx php-fpm -y

    printf ">>> LEMP stack installed.\n"
    wait

    printf "> Installing required packages...\n"
    wait
    sudo apt install curl git php-cli php-curl php-mbstring php-mysql php-xml unzip -y

    printf "> Required packages installed.\n"
    wait

    printf "> Installing Node and npm...\n"
    wait
    sudo apt install nodejs npm -y

    printf ">>> Node and npm installed.\n"
    wait

    printf "> Installing Composer...\n"
    wait
    curl https://getcomposer.org/installer -o composer-setup.php
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    rm composer-setup.php

    printf ">>> Composer installed.\n"
    wait

    printf "> Installing Glances...\n"
    wait
    curl https://bit.ly/glances | /bin/bash

    printf ">>> Glances installed.\n"
    wait

    printf "> Installing GoAccess...\n"
    wait
    sudo apt-get install goaccess

    printf ">>> GoAccess installed.\n"
    wait

    printf ">>> Installations complete.\n"
    wait
}

setup_timezone () {
    if hash dpkg-configure 2>/dev/null
    then
        sudo dpkg-configure tzdata
    else
        sudo dpkg-reconfigure tzdata
    fi
}

setup_keys () {
    printf "> Setting up SSH keys...\n"
    wait

    printf ">> Enter SSH key identifier: "
    read identifier
    ssh-keygen -b 4096 -t rsa -C "$identifier"

    printf ">>> SSH keys setup.\n"
    wait

    ssh-copy-id $user@localhost
    printf ">>> SSH keys enabled."
    wait
}

setup_static_ip () {
    printf "> Setting up static IP address...\n"
    wait

    printf ">> Enter IP address to use: "
    read ip
    printf ">> Enter gateway IP address: "
    read gateway
    filename="/etc/netplan/50-cloud-init.yaml"
    cat <<EOF >> $filename
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
      addresses: [$ip/24]
      gateway4: $gateway
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF
    printf ">>> Static IP address setup."
    wait
}

setup_terminal () {
    sed "/PS1='\A \u \W \$ '/d" ~/.bashrc -in
    echo "PS1='\A \u \w \$ '" >> ~/.bashrc
}

setup_commands () {
    printf "> Setting up custom commands...\n"
    printf "> Custom commands prefix with \"$user\"\n"
    wait

    # Remove custom commands
    sed "/alias $user/d" ~/.bashrc -in

    # Write aliases to ~/.bashrc
    cat <<EOF >> ~/.bashrc
alias $user-commands="sed '/alias $user-/p' ~/.bashrc -n"
alias $user-run-glances="glances"
alias $user-run-goaccess="goaccess /var/log/nginx/access.log -c"
alias $user-show-status="htop"
alias $user-show-private-key="cat ~/.ssh/id_rsa"
alias $user-show-public-key="cat ~/.ssh/id_rsa.pub"
alias $user-shutdown="sudo shutdown -h 0"
EOF

    printf ">>> Custom commands setup.\n"
    wait

    printf "> Loading custom commands...\n"
    wait
    # Reload terminal to make aliases usable
    source ~/.bashrc

    printf ">>> Custom commands loaded.\n"
    wait
}

user=$(whoami)
setup_user
update_system
install_packages
setup_timezone
setup_keys
setup_static_ip
setup_terminal
setup_commands

printf "   _____      __                                            __     __     \n";
printf "  / ___/___  / /___  ______     _________  ____ ___  ____  / /__  / /____ \n";
printf "  \__ \/ _ \/ __/ / / / __ \   / ___/ __ \/ __ \`__ \/ __ \/ / _ \/ __/ _ \\n";
printf " ___/ /  __/ /_/ /_/ / /_/ /  / /__/ /_/ / / / / / / /_/ / /  __/ /_/  __/\n";
printf "/____/\___/\__/\__,_/ .___/   \___/\____/_/ /_/ /_/ .___/_/\___/\__/\___/ \n";
printf "                   /_/                           /_/                      \n";

printf ">>> Setting up static IP address.\n"
wait

printf ">>> NOTE: This will disconnect this shell.\n"
wait

sudo netplan apply --debug;

# Credits:
# >>> Text to ASCII: http://patorjk.com/software/taag