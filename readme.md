## Setup Steps

- <details><summary>Get and install updates</summary>

    ```
    sudo apt update
    sudo apt upgrade
    ```

    </details>

- <details><summary>Set correct timezone</summary>

    ```
    sudo dpkg-configure tzdata
    ```

    </details>

- <details><summary>Install Glances for system monitoring</summary>

    ```
    curl -L https://bit.ly/glances | /bin/bash
    ```
    
    - *To run in CLI mode:*

        ```
        glances
        ```
    
    - *To run in browser mode:*

        ```
        glances -w
        ```

    </details>

- <details><summary>Install GoAccess for access log monitoring</summary>

    ```
    sudo apt-get install goaccess
    ```
    
    - *To run in CLI mode:*

        ```
        goaccess <access log location (i.e. /var/log/nginx/access.log)>
            -c
        ```
    
    - *To run in CLI mode:*

        ```
        goaccess <access log location (i.e. /var/log/nginx/access.log)
            -o <HTML file location (i.e. /var/www/html/goaccess/index.html)>
            --log-format=COMBINED
            --real-time-html
        ```

    </details>

- <details><summary>Install LEMP stack with other must-have packages</summary>

    #### In the guest:

    1. Install LEMP stack

        ```
        sudo apt install
            mariadb-server
            nginx
            php-fpm
        reboot
        ```
    
    2. Install other must-have packages
        
        ```
        sudo apt install
            curl
            git
            php-cli
            php-mbstring
            php-mysql
            unzip
        ```

    3. Install Composer globally
    
        ```
        curl -sS https://getcomposer.org/installer
            -o composer-setup.php
        sudo php composer-setup.php
            --install-dir=/usr/local/bin
            --filename=composer
        rm composer-setup.php
        ```

    4. Install nodejs and npm globally

        ```
        sudo apt install
            nodejs
            npm
        ```

    5. Install `gitmoji-cli`

        ```
        npm i -g gitmoji-cli
        ```

    6. Setup git user

        ```
        git config --global user.name "{{user name}}"
        git config --global user.email {{user email address}}
        ```

    </details>
