# Ubuntu Sever Setup

[Marvin](https://marvinisaac.com)'s guide on setting up a local Ubuntu server.

From the start, this guide assumes several things:

- Windows host OS
- VirtualBox virtual machine

- - - - -

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
    # In case of `command not found` error
    #sudo dpkg-reconfigure tzdata
    ```

    </details>


3. <details><summary>Install LEMP stack with other must-have packages</summary>

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
            libcurl3
            libcurl3-dev
            php-cli
            php-curl
            php-mbstring
            php-mysql
            php-xml
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

4. <details><summary>Setup keys and enable SSH access</summary>

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

5. Setup project

## Appendix

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
    
    - *To run in browser mode:*

        ```
        goaccess <access log location (i.e. /var/log/nginx/access.log)
            -o <HTML file location (i.e. /var/www/html/goaccess/index.html)>
            --log-format=COMBINED
            --real-time-html
        ```

    </details>

- <details><summary>Install and setup folder sharing between host and guest OS</summary>

    ### In the host:

    1. Setup shared folder
        - VirtualBox Menu > "Machine" > "Shared Folders" > "Add New Shared Folder"
        - Check "Make Permanent" and "Auto-mount"
        - Add folder path(s) and name(s)

    ### In the guest:

    1. Insert installer
        - VirtualBox Menu > "Devices" > "Insert Guest Additions CD Image"

    2. Install in virtual machine
        ```
        sudo mount /dev/cdrom /mnt
        sudo apt-get install build-essential linux-headers-`uname -r`
        sudo /mnt/./VBoxLinuxAdditions.run
        sudo reboot
        ```

    3. Setup auto-mount
        ```
        sudo nano /etc/fstab
        # Insert line and save
        # {{shared folder name (i.e. shared)}}  {{mount point (i.e. /var/www/shared/)}}  vboxsf  defaults  0  0
        sudo nano /etc/modules
        # Insert line and save
        # vboxsf
        sudo reboot
        ```

    </details>

- <details><summary>Customize terminal display</summary>

    > Based on experience, changing the colors are *required*.
    > Default colors of shared folders are undreadable.

    ```
    sudo nano ~/.bashrc
    # To turn shared folders to white text on green background, add to end of file:
    # LS_COLORS="ow=97;42"
    # export LS_COLORS
    #
    # To show "{{time}} {{user}} {{current directory}} $ ", find PS1 value and change to:
    # PS1='\A \u \w \$ '
    ```

    </details>

- <details><summary>Setup automatic VM headless start</summary>

    ### In the host:

    1. Create a `.bat` file in the Startup folder
        ```
        cd "{{location of VirtualBox (i.e. C:\Program Files\VirtualBox)}}"
        .\vboxmanage startvm "{{VM name (i.e. Local Host)}}" --type headless
        # To prevent auto-close of command line, add
        # cmd \k
        ```

    </details>

- <details><summary>Setup static IP</summary>

    ### In the host:

    1. Change the VM's settings
        - Select the VM > "Settings" > "Network" > "Attached to: Bridged Adapter"

    2. Run `ipconfig` and take note of value of `Default Gateway`

    ### In the guest:

    1. Update the file inside `/etc/netplan` (i.e. `50-cloud-init.yaml`)
        ```
        network:
            version: 2
            renderer: networkd
            ethernets:
                enp0s3:
                    dhcp4: no
                    addresses: [{{static IP (i.e. 192.168.1.99)}}/24]
                    gateway4: {{default gateway of host (i.e. 192.168.1.1)}}
                    nameservers:
                        addresses: [8.8.8.8,8.8.4.4]
        ```

    2. Check and apply new settings
        ```
        sudo netplan --debug apply
        ```

    </details>

- <details><summary>Notes</summary>

    1. Install optional packages with:

        ```
        sudo apt install {{package name}}
        ```

        - List of optional packages:
            
            - `php-pgsql` (PostgreSQL driver)
            - `php-sqlite3` (SQLite3 driver)

    </details>

- <details><summary><strong>TODO</strong></summary>

    - Research how to run services and custom commands at startup

    </details>