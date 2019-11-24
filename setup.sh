#!/bin/bash
set -e

wait () {
    sleep 2
}

setup_user_variable () {
    # Setup user prefix for custom commands (i.e. marvin-commands)
    printf "> Script is currently running under \"$user\".\n"
    printf "> (A) Type another username to use as, or\n"
    printf "> (B) press enter to continue running under \"$user\".\n"
    echo ">> Waiting for input: "
    read user_input < /dev/tty
    if [ "$user_input" != "" ]
    then
        user=$user_input
        printf "> You entered: \"$user\".\n"
    fi
    printf "> Using \"$user\" in script.\n"
}

setup_identifier_variable () {
    printf "> Default SSH key identifier is $identifier.\n"
    printf "> (A) Type a new identifier, or\n"
    printf "> (B) press enter to use $identifier.\n"
    echo ">> Enter SSH key identifier: "
    read identifier_input < /dev/tty
    if [ "$identifier_input" != "" ]
    then
        identifier=$identifier_input
        printf "> You entered: \"$identifier\".\n"
    fi
    printf "> Using \"$identifier\" as SSH key identifier.\n"
}

setup_ip_variable () {
    printf "> Default static IP address is $ip.\n"
    printf "> (A) Type a new IP address, or\n"
    printf "> (B) press enter to use $ip.\n"
    echo ">> Enter static IP address: "
    read ip_input < /dev/tty
    if [ "$ip_input" != "" ]
    then
        ip=$ip_input
        printf "> You entered: \"$ip\".\n"
    fi
    printf "> Using \"$ip\" as static IP address.\n"
}

setup_gateway_variable () {
    printf "> Default gateway IP address is $gateway.\n"
    printf "> (A) Type a new IP address, or\n"
    printf "> (B) press enter to use $gateway.\n"
    echo ">> Enter gateway IP address: "
    read gateway_input < /dev/tty
    if [ "$gateway_input" != "" ]
    then
        gateway=$gateway_input
        printf "> You entered: \"$gateway\".\n"
    fi
    printf "> Using \"$gateway\" as gateway IP address.\n"
}

setup_script_variables () {
    setup_user_variable
    setup_identifier_variable
    setup_ip_variable
    setup_gateway_variable
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
    sudo apt install curl git php-cli php-curl php-mbstring php-mysql php-xml unzip zip -y

    printf "> Required packages installed.\n"
    wait

    printf "> Installing Node and npm...\n"
    wait
    sudo apt install nodejs npm -y

    printf ">>> Node and npm installed.\n"
    wait

    printf "> Installing Composer...\n"
    wait
    curl -s https://getcomposer.org/installer -o composer-setup.php
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    rm composer-setup.php

    printf ">>> Composer installed.\n"
    wait

    printf "> Installing GoAccess...\n"
    wait
    sudo apt-get install goaccess -qq > /dev/null

    printf ">>> GoAccess installed.\n"
    wait

    printf ">>> Installations complete.\n"
    wait
}

setup_timezone () {
    printf "> Configuring system timezone...\n"
    wait

    if hash dpkg-configure 2>/dev/null
    then
        sudo dpkg-configure tzdata
    else
        sudo dpkg-reconfigure tzdata
    fi

    printf ">>> System timezone configured.\n"
    wait
}

setup_keys () {
    printf "> Setting up SSH keys...\n"
    wait
    ssh-keygen -b 4096 -C "$identifier" -f ~/.ssh/id_rsa -N "" -t rsa 2>/dev/null <<< y >/dev/null

    printf ">>> SSH keys setup.\n"
    wait

    ssh-copy-id $user@localhost
    printf ">>> SSH keys enabled."
    wait
}

setup_static_ip () {
    printf "> Setting up static IP address...\n"
    wait

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
identifier="local-server"
ip="192.168.1.250"
gateway="192.168.1.1"

setup_script_variables
setup_timezone
setup_keys
update_system
install_packages
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