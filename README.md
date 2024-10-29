# PHP Development Container Images

An extended PHP development container based on `mcr.microsoft.com/vscode/devcontainers/php`.
This container enhances the official Microsoft PHP devcontainer with additional extensions and tools for a more comprehensive development environment.

## Features

- Pre-installed PHP extensions
- Development tools

### Pre-installed PHP Extensions

- bcmath
- exif
- gd (with freetype and jpeg support)
- imap (with Kerberos and SSL support)
- imagick
- intl
- mailparse
- mysqli
- pcntl
- PDO (MySQL, PostgreSQL, SQLite)
- redis
- xdebug
- xml
- zip

### Development Tools

- nvm (Node Version Manager)
- SQLite3
- Supervisor
- ImageMagick
- MariaDB client
- PostgreSQL client

## Usage

1. Create a `.devcontainer/devcontainer.json` file in your project
2. Copy the configuration examples below to set up your development environment
3. Open your project in VS Code and click "Reopen in Container" when prompted
4. The container will automatically start Apache server on port 80

### Basic Configuration Example

This configuration uses the `features` property to easily install Node.js using the official devcontainer feature. It also includes recommended VS Code extensions and settings for PHP development. For more information on available features, visit [devcontainer features](https://containers.dev/features).

Create `.devcontainer/devcontainer.json` in your project:

```json:.devcontainer/devcontainer.json
{
  "name": "PHP Development Container",
  "image": "ghcr.io/horatjp/php-dev:latest",
  "features": {
    "ghcr.io/devcontainers/features/node:latest": {
      "version": "20"
    }
  },
  "customizations": {
    "vscode": {
      "settings": {
        "php.validate.enable": false,
        "php.suggest.basic": false,
        "[php]": {
          "editor.formatOnSave": true,
          "editor.defaultFormatter": "bmewburn.vscode-intelephense-client"
        }
      },
      "extensions": [
        "EditorConfig.EditorConfig",
        "esbenp.prettier-vscode",
        "mikestead.dotenv",
        "bmewburn.vscode-intelephense-client",
        "xdebug.php-debug",
        "neilbrayfield.php-docblocker",
        "recca0120.vscode-phpunit"
      ]
    }
  },
  "forwardPorts": [
    80
  ],
  "workspaceFolder": "/var/www/html",
  "workspaceMount": "source=${localWorkspaceFolder},target=/var/www/html,type=bind,consistency=cached",
  "postAttachCommand": {
    "command": "service apache2 start"
  }
}
```

### nvm (Node Version Manager)

This configuration demonstrates how to install a specific version of Node.js using the `postCreateCommand` property. This is useful when you need to use a specific version of Node.js for your project.

```json:.devcontainer/devcontainer.json
{
  // ... other configuration ...
  "postCreateCommand": "bash -i -c 'nvm install 20 && nvm use 20"
}
```

### Custom Document Root Configuration

This configuration creates a custom document root in the `public` directory. Note that when using this configuration, you can omit the `workspaceFolder` and `workspaceMount` settings as the document root is managed through symbolic links.

```json:.devcontainer/devcontainer.json
{
  // ...
  "postCreateCommand": "mkdir -p \"$(pwd)\"/public && sudo chmod a+x \"$(pwd)\"/public && sudo rm -rf /var/www/html && sudo ln -s \"$(pwd)\"/public /var/www/html",
  "postAttachCommand": {
    "command": "service apache2 start"
  }
}
```

### Extended Configuration with Custom Dockerfile

This configuration demonstrates how to extend the base image with a custom Dockerfile. This is useful when you need to customize the development environment further, such as setting the locale and timezone.

```json:.devcontainer/devcontainer.json
  "build": {
    "dockerfile": "Dockerfile",
    "args": {
      "LOCALE": "ja_JP.UTF-8",
      "TIME_ZONE": "Asia/Tokyo"
    }
  },
```

Create `.devcontainer/Dockerfile` in your project:

```Dockerfile:.devcontainer/Dockerfile
FROM  ghcr.io/horatjp/php-dev:latest

ARG LOCALE=en_US.UTF-8
ARG TIME_ZONE=UTC

ENV LANG=${LOCALE}
ENV TZ=${TIME_ZONE}

RUN : \
    # locale
    && sed -i -E "s/# (${LOCALE})/\1/" /etc/locale.gen \
    && locale-gen ${LOCALE} \
    && dpkg-reconfigure locales \
    && update-locale LANG=${LOCALE} \
    # timezone
    && ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo ${TIME_ZONE} > /etc/timezone \
    && apt-get clean && rm -rf /var/lib/apt/lists/
```
