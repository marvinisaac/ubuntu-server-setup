## Setup Steps

1. Get and install updates
    <details>
        <summary>Instructions</summary>
        <p>

        ```bash
        sudo apt update && sudo apt upgrade
        ```

        </p>
    </details>

2. Set correct timezone
    ```bash
    sudo dpkg-configure tzdata
    ```

3. Install Glances for monitoring
    ```bash
    curl -L https://bit.ly/glances | /bin/bash
    ```

4. [Install LEMP stack with other must-have packages](#file-01-lemp-stack-md)
    
5. [*(Optional)* Install and setup folder sharing](#file-02-vboxsf-md)

6. [Setup keys and enable SSH access](#file-03-ssh-keys-md)

7. [*(Optional)* Setup automatic headless start](#file-04-headless-mode-md)

8. [Setup a basic project](#file-05-nginx-basic-md)

9. Setup project with HTTP/SSL

97. [Notes](#file-97-notes-md)

98. [Commands](#file-98-commands-md)

99. [Todos]($file-99-todos-md)