# Ansible

## Pre Reqs

- Ansible
- Git
- Homebrew

## Setup

This is my setup for Ansible for new machine setup.

Ansible is not already installed, you can install it using the following command:

```sh
git clone https://github.com/zjromani/ansible
```
Then run

```sh
// ask-become-pass is for sudo password
ansible-playbook local.yml --ask-vault-pass --ask-become-pass
```

This will setup a new machine by pulling .dotfiles, stowing them, and auto installing some other core packages/tools.

## SSH

A note on SSH -- I'm using Ansible Vault to encrypt my SSH keys, which is why the --ask-vault-pass option is required. Ansible Vault uses AES-256-CBC for encryption

