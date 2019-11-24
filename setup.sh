#!/bin/bash
set -e

wait () {
    sleep 2
}

update () {
    wait
    printf "> Updating system...\n"
    
    wait
    printf "> Getting updates...\n"
    sudo apt update -y
    
    wait
    printf "> Installing updates...\n"
    sudo apt upgrade -y
    
    wait
    printf ">>> Updates installed.\n"
}

install () {
    wait
    printf "> Installing LEMP stack...\n"
    sudo apt install mariadb-server nginx php-fpm -y
    
    wait
    printf ">>> LEMP installed.\n"
    
    wait
    printf "> Installing required packages...\n"
    sudo apt install curl git php-cli php-curl php-mbstring php-mysql php-xml unzip -y
    
    wait
    printf "> Required packages installed.\n"
    
    wait
    printf "> Installing node and npm...\n"
    sudo apt install nodejs npm -y
    
    wait
    printf ">>> Node and npm installed.\n"
    
    wait
    printf "> Installing composer...\n"
    curl https://getcomposer.org/installer -o composer-setup.php
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    rm composer-setup.php
    
    wait
    printf ">>> Composer installed.\n"
    
    wait
    printf ">>> Installations complete.\n"
}

alias () {
    wait
    printf "> Setting up custom commands...\n"
    
    # Remove custom commands
    sed '/^marvin-/d' ~/.bashrc

    # Write aliases to ~/.bashrc
    echo "alias marvin-status=\"htop\"" >> ~/.bashrc
    echo "alias marvin-exit=\"shutdown -h 1\"" >> ~/.bashrc
    
    # Reload terminal to make aliases usable
    source ~/.bashrc
    
    wait
    printf ">>> Custom commands online.\n"

}

update
install
alias

printf "   _____      __                                            __     __     \n";
printf "  / ___/___  / /___  ______     _________  ____ ___  ____  / /__  / /____ \n";
printf "  \__ \/ _ \/ __/ / / / __ \   / ___/ __ \/ __ \`__ \/ __ \/ / _ \/ __/ _ \\\n";
printf " ___/ /  __/ /_/ /_/ / /_/ /  / /__/ /_/ / / / / / / /_/ / /  __/ /_/  __/\n";
printf "/____/\___/\__/\__,_/ .___/   \___/\____/_/ /_/ /_/ .___/_/\___/\__/\___/ \n";
printf "                   /_/                           /_/                      \n";

# Credits:
# >>> Text to ASCII: http://patorjk.com/software/taag