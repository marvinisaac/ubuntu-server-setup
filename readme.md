# Ubuntu Sever Setup

[Marvin](https://marvinisaac.com)'s guide on setting up a local Ubuntu server.

From the start, this guide assumes several things:

- Windows host OS
- VirtualBox virtual machine

# Basic Setup Steps

#### 1. Get and install updates
    
```
sudo apt update && sudo apt upgrade
```

#### 2. Set correct timezone
    
```
sudo dpkg-configure tzdata
```

- In case of **command not found** error, try `sudo dpkg-reconfigure tzdata`

#### 3. Install LEMP stack and other must-have packages

1. Install LEMP and other must-have packages:
    ```
    sudo apt install mariadb-server nginx php-fpm
    sudo apt install curl git nodejs npm php-cli php-curl php-mbstring php-mysql php-xml unzip
    ```

2. Install `composer` globally:
    ```
    curl -sS https://getcomposer.org/installer -o composer-setup.php
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    rm composer-setup.php
    ```

#### 4. Setup keys and enable SSH access

In the guest:

1. Generate a new 4096-bit SSH key pair:
    ```
    ssh-keygen -b 4096 -t rsa -C "{{comment to identify the key (i.e. machine name)>"
    ```

2. Copy the public key for external services like Github:
    ```
    cat ~/.ssh/{{public key file name}}
    ```

3. Enable SSH access and copy private key:
    ```
    ssh-copy-id {{user (i.e. marvin)}}@{{host name (i.e. localhost)}}
    cat ~/.ssh/{{private key file name}}
    ```

In the host:

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

    - In case of **WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!** error, try `ssh-keygen -R {{server hostname or IP}}`

#### 5. Setup project

# Optional Steps

#### Install Glances for system monitoring:

```
curl -L https://bit.ly/glances | /bin/bash
```

- *To run in CLI mode:* `glances`

#### Install GoAccess for access log monitoring:

```
sudo apt-get install goaccess
```

- *To run in CLI mode:* `goaccess <access log location (i.e. /var/log/nginx/access.log)> -c`

#### Customize terminal display:

```
sudo nano ~/.bashrc
# To show "{{time}} {{user}} {{current directory}} $ ", find PS1 value and change to:
# PS1='\A \u \w \$ '
```

#### Setup automatic VM headless start:

- Create a `.bat` file in the Startup folder
    ```
    cd "{{location of VirtualBox (i.e. C:\Program Files\VirtualBox)}}"
    .\vboxmanage startvm "{{VM name (i.e. Local Host)}}" --type headless
    # To prevent auto-close of command line, add
    # cmd \k
    ```

#### Setup static IP:

In the host:

1. Change the VM's settings
    - Select the VM > "Settings" > "Network" > "Attached to: Bridged Adapter"

2. Run `ipconfig` and take note of value of `Default Gateway`

In the guest:

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

- Install optional packages with: `sudo apt install {{package name}}`

    - List of optional packages:
        
        - `php-pgsql` (PostgreSQL driver)
        - `php-sqlite3` (SQLite3 driver)

#### Todo List

- Research how to run services and custom commands at startup