## Setup Steps

- <details>
    <summary>Get and install updates</summary>

    ```
    sudo apt update && sudo apt upgrade
    ```

    </details>

- <details>
    <summary>Set correct timezone</summary>

    ```
    sudo dpkg-configure tzdata
    ```

    </details>

- <details>
    <summary>Install Glances for system monitoring</summary>

    ```
    curl -L https://bit.ly/glances | /bin/bash
    ```
    
    - To run in CLI mode:

        ```
        glances
        ```
    
    - To run in browser mode:

        ```
        glances -w
        ```

    </details>

- <details>
    <summary>Install GoAccess for access log monitoring</summary>

    ```
    sudo apt-get install goaccess
    ```
    
    - To run in CLI mode:

        ```
        goaccess <access log location (i.e. /var/log/nginx/access.log)>
            -c
        ```
    
    - To run in CLI mode:

        ```
        goaccess <access log location (i.e. /var/log/nginx/access.log)
            -o <HTML file location (i.e. /var/www/html/goaccess/index.html)>
            --log-format=COMBINED
            --real-time-html
        ```

    </details>