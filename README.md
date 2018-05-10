# `workerd`

This repository contains a number of scripts that enable:

- Syncing the data produced by running algorithms on a prototype server
- Syncing and configuration of new algorithms
- Syncing of new configurations

## INSTALLATION

To install the tools on a device board:

- create a new user on the device:

```bash
root@device:        useradd -c "User Name" -d /home/user -s /bin/bash user
```

- launch the `deploy_device.sh` script

## WORKING SCHEME

This repo contains a handful of scripts which together constitute an autonomous (Linux) subsystem designed to

1. keep a number of programs running and working
2. allow the maintainers to install, update or remove any program
3. remotely sync any output produced by the programs
4. monitor the subsystem status

At the lowest level, the subsystem is piloted by the script `/etc/init.d/workerd-starter` installed as _service_ and auto-launched at boot. The main purpose of `workerd-starter` is to enable the automatic (or manual) start/stop of the main daemon `/usr/bin/workerd-crond` supervising the operation of the subsystem.
