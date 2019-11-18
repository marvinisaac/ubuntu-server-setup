## Setup Steps

1. <details><summary>Get and install updates</summary>

    ```
    sudo apt update
    sudo apt upgrade
    ```

    </details>

2. <details><summary>Set correct timezone</summary>

    ```
    sudo dpkg-configure tzdata
    ```

    </details>

3. <details><summary>Install Glances for system monitoring</summary>

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

4. <details><summary>Install GoAccess for access log monitoring</summary>

    ```
    sudo apt-get install goaccess
    ```
    
    - *To run in CLI mode:*

        ```
        goaccess <access log location (i.e. /var/log/nginx/access.log)>
            -c
        ```
    
    - *To run in browser mode:*

        ```
        goaccess <access log location (i.e. /var/log/nginx/access.log)
            -o <HTML file location (i.e. /var/www/html/goaccess/index.html)>
            --log-format=COMBINED
            --real-time-html
        ```

    </details>

5. <details><summary>Install LEMP stack with other must-have packages</summary>

    #### In the guest:

    1. Install LEMP stack:

        ```
        sudo apt install
            mariadb-server
            nginx
            php-fpm
        reboot
        ```
    
    2. Install other must-have packages:
        
        ```
        sudo apt install
            curl
            git
            php-cli
            php-mbstring
            php-mysql
            unzip
        ```

    3. Install `composer` globally:
    
        ```
        curl -sS https://getcomposer.org/installer
            -o composer-setup.php
        sudo php composer-setup.php
            --install-dir=/usr/local/bin
            --filename=composer
        rm composer-setup.php
        ```

    4. Install `nodejs` and `npm` globally:

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

6. <details><summary>Setup keys and enable SSH access</summary>

    #### In the guest:

    1. Generate a new 4096-bit SSH key pair:

        ```
        ssh-keygen
            -b 4096
            -t rsa
            -C "{{comment to identify the key (i.e. machine name)>"
        ```

    2. Copy the public key for external services like Github:

        ```
        cat ~/.ssh/{{public key file name}}
        ```

    3. Enable SSH access and copy private key:

        ```
        ssh-copy-id {{user (i.e. marvin)}}@{{host name (i.e. localhost)}}
        cat ~/.ssh/{{private key file name}}
        # Copy the output to clipboard
        ```

    #### In the host:

    1. Create private key file (i.e. `private`)

    2. Paste the private key contents

    3. Create `config` file:

        ```
        Host {{server name (i.e. my-localhost)}}
            HostName {{host name(i.e. localhost)}}
            User {{user (i.e. marvin)}}
            IdentityFile {{path to private key (i.e. C:\Users\Marvin\.ssh\private)}}
        ```

    4. Test if everything is working:

        ```
        ssh {{server name (i.e. my-localhost)}}
        ```

    </details>

7. Setup project folder

8. Setup project with HTTPS

## Appendix

- Install and setup folder sharing between host and guest OS

- Setup automatic VM headless start

- Notes

- <details><summary>TODO</summary>

    - Research how to run Ubuntu commands at startup

    </details>