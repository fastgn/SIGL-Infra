Ansible Role: Teleport
=========

This role will deploy Teleport to a given server. 

What this does:
---------------

You can configure which parts of a teleport deployment you want with variables.

- Install teleport via DEB/RPM with GPG check
- Install teleport from tarball with GPG check (None apt/rpm systems)
- Enroll automatically as a node for SSH
- Automatically deploy "commands"/labels for SSH and Application such as Kernel, Teleport & more versioning.
- Automatically generate invite token

Requirements
------------

A system running utilizing systemd
This has only been tested on:

Debian 10/11
RHEL 7/8/9
openSUSE 15.0/1/2/3/Tumbleweed



How token generation works:
---------------------------
- Generate token with tctl command in JSON format
- Extracts token
- Updates "INVITE_TOKEN" variable


How to use token generation function:
-------------------------------------
- Fill in the following variables:

GENERATE_TOKEN: true                      # Required for token generation to start
GENERATE_TOKEN_COMBO: true                # If you want to generate both an app and node token. Don't use this in combination with the below "GENERATE_TOKEN_<....>_ONLY" variables.
GENERATE_TOKEN_SSH_ONLY: false            # If you only want to generate a node token
GENERATE_TOKEN_APP_ONLY: false            # If you only want to generate an app token
TELEPORT_TOKEN_HOST: "Jump"               # The host (via SSH) that tctl will run on
TOKEN_TTL: "2m"                           # TTL (Time-to-live) of the token.

Role Variables
--------------

### Group Vars:

| Name           | Type    | Example           |
|----------------|---------|-------------------|
| INVITE_TOKEN   | string  | 4f622402dawdawdaw |
| CA_PIN         | string  | sha256:2awdwadwad678767awd768awdd |
| TELEPORT_HOST  | string  | teleport.domain.tld:443 |
| TELEPORT_MAJOR_VERSION | INT | 10 |
| TELEPORT_MINOR_VERSION | FLOAT | 3.5 |
| GENERATE_TOKEN | bool | true    |
| GENERATE_TOKEN_COMBO | bool | true    |
| GENERATE_TOKEN_SSH_ONLY | bool | false   |
| GENERATE_TOKEN_APP_ONLY | bool | false    |
| TELEPORT_TOKEN_HOST | string | "Jump"    |
| TOKEN_TTL | string | "10m"    |



### Host Vars:

| Name   | Type    |  Example    |
|--------|---------|-------------|
| SSH_SERVICE | bool | true    |
| APP_SERVICE | bool | true |
| CREATE_SSH_COMMANDS | bool | true |
| CREATE_APP_COMMANDS | bool | true |
| CREATE_COMMAND | bool | true |
| CREATE_OS_COMMAND | bool | true |
| CREATE_KERNEL_COMMAND | bool | true |
| CREATE_TELEPORT_COMMAND | bool | true |
| CREATE_HOSTNAME_COMMAND | bool | true |
| CREATE_VIRTUALIZATION_COMMAND | bool | true |
| TELEPORT_APPLICATION_NAME | string | proxmox |
| TELEPORT_APPLICATION_IGNORE_TLS | string | true |
| TELEPORT_APPLICATION_URI | string | https://192.168.200.1:8006  |




Dependencies
------------

There are no dependencies for this role

Example Playbook
----------------

PLAYBOOK (NONE GENERATED TOKEN):
```yaml
- hosts: teleport
  become: true
  roles:
    - jamdoog.teleport
  vars:
    - INVITE_TOKEN: 4f622402dawdawdaw
    - CA_PIN: sha256:2awdwadwad678767awd768awdd
    - TELEPORT_HOST: domain.tld:443
    - TELEPORT_MINOR_VERSION: 3.2
    - TELEPORT_MAJOR_VERSION: 10
    - SSH_SERVICE: true
    - APP_SERVICE: true
    - CREATE_COMMANDS: true 
    - CREATE_HOSTNAME_COMMAND: true 
    - CREATE_OS_COMMAND: true
    - CREATE_KERNEL_COMMAND: true
    - CREATE_TELEPORT_COMMAND: true
    - CREATE_VIRTUALIZATION_COMMAND: true
    - TELEPORT_APPLICATION_NAME: "proxmox"
    - TELEPORT_APPLICATION_IGNORE_TLS: true
    - TELEPORT_APPLICATION_URI: "https://192.168.200.1:8006"
```

PLAYBOOK (GENERATED TOKEN):
```yaml
- hosts: teleport
  become: true
  roles:
    - jamdoog.teleport
  vars:
    - GENERATE_TOKEN: true
    - GENERATE_TOKEN_COMBO: true
    - GENERATE_TOKEN_SSH_ONLY: false
    - GENERATE_TOKEN_APP_ONLY: false
    - TELEPORT_TOKEN_HOST: "Jump"
    - TOKEN_TTL: "2m"
    - CA_PIN: sha256:2awdwadwad678767awd768awdd
    - TELEPORT_HOST: domain.tld:443
    - TELEPORT_MINOR_VERSION: 3.2
    - TELEPORT_MAJOR_VERSION: 10
    - SSH_SERVICE: true
    - APP_SERVICE: true
    - CREATE_COMMANDS: true 
    - CREATE_HOSTNAME_COMMAND: true 
    - CREATE_OS_COMMAND: true
    - CREATE_KERNEL_COMMAND: true
    - CREATE_TELEPORT_COMMAND: true
    - CREATE_VIRTUALIZATION_COMMAND: true
    - TELEPORT_APPLICATION_NAME: "proxmox"
    - TELEPORT_APPLICATION_IGNORE_TLS: true
    - TELEPORT_APPLICATION_URI: "https://192.168.200.1:8006"
```


License
-------

BSD

Author Information
------------------

This role was created by James Ledger, I write about things on https://jamesledger.net
