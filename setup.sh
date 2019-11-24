#!/bin/bash
set -e

wait () {
    sleep 2
}

update () {
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

install () {
    printf "> Installing LEMP stack...\n"
    wait
    sudo apt install mariadb-server nginx php-fpm -y
    
    printf ">>> LEMP installed.\n"
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
    
    printf ">>> Installations complete.\n"
    wait
}

alias () {
    printf "> Setting up custom commands...\n"
    wait
    
    # Remove custom commands
    sed '/alias marvin/d' ~/.bashrc -in

    # Write aliases to ~/.bashrc
    echo "alias marvin-status=\"htop\"" >> ~/.bashrc
    echo "alias marvin-exit=\"shutdown -h 0\"" >> ~/.bashrc
    
    # Reload terminal to make aliases usable
    source ~/.bashrc
    
    printf ">>> Custom commands online.\n"
    wait
}

update
install
alias

printf "   _____      __                                            __     __     \n";
printf "  / ___/___  / /___  ______     _________  ____ ___  ____  / /__  / /____ \n";
printf "  \__ \/ _ \/ __/ / / / __ \   / ___/ __ \/ __ \`__ \/ __ \/ / _ \/ __/ _ \\n";
printf " ___/ /  __/ /_/ /_/ / /_/ /  / /__/ /_/ / / / / / / /_/ / /  __/ /_/  __/\n";
printf "/____/\___/\__/\__,_/ .___/   \___/\____/_/ /_/ /_/ .___/_/\___/\__/\___/ \n";
printf "                   /_/                           /_/                      \n";

# Credits:
# >>> Text to ASCII: http://patorjk.com/software/taag