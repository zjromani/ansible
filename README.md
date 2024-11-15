# Ansible

## Setup

This is my setup for Ansible for new machine setup.

 Ansible is not already installed, you can install it using the following command:

```sh
git clone https://github.com/zjromani/ansible
sudo apt update
sudo apt install ansible -y
```
Then run

```sh
ansible-playbook local.yml --ask-vault-pass
```

This will setup a new machine by pulling .dotfiles, stowing them, and auto installing some other core packages/tools.

## SSH

A note on SSH -- I'm using Ansible Vault to encrypt my SSH keys, which is why the --ask-vault-pass option is required. Ansible Vault uses AES-256-CBC for encryption

