# vermillion-client

Interact with your [vermillion-server](https://github.com/aapis/vermillion-server) instances.

## Installation

`gem install vermillion-client`

If no `~/.vermillion.yml` file is present, the application will attempt to create on before anything else so you don't have to create this file.  You do have to update it with real information, here is an example.

```yml
servers:
  -
    name: domain1
    address: domain2.com
    https: false
    key: SHA_HASH
  -
    name: local
    address: localhost:8000
    https: false
    key: DIFFERENT_SHA_HASH
  -
    name: domain2
    address: domain2.com
    https: true
user:
  test@example.com
```

## Supported Commands

### change

Change branches on the requested server.

`vermillion change branch local/domain1 -t my-feature-branch`

### status

Prints information about `vermillion`, including the app's configuration data and a list of the servers the client can access.

`vermillion status`

### update

Quite simply, executes `git-pull` in the requested project.

`vermillion update one local/domain1`
