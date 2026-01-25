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

## Updating Existing Machines

For machines with dotfiles already installed, use the update playbook:

```sh
# Quick update - pulls latest dotfiles and re-stows
ansible-playbook update.yml

# Update specific components
ansible-playbook update.yml --tags dotfiles
ansible-playbook update.yml --tags tmux
```

This will:
- Pull latest .dotfiles from GitHub
- Re-stow all packages (reads from dotfiles/packages.yml)
- Update tmux plugins (catppuccin)
- Sync iTerm2 configuration

The dotfiles update task reads the package list from `~/.dotfiles/packages.yml`, ensuring it stays in sync with the dotfiles repo.

### Full Setup vs Update

- **New machine**: `ansible-playbook local.yml --ask-vault-pass --ask-become-pass`
- **Existing machine**: `ansible-playbook update.yml`

## SSH

A note on SSH -- I'm using Ansible Vault to encrypt my SSH keys, which is why the --ask-vault-pass option is required. Ansible Vault uses AES-256-CBC for encryption

## iTerm2 Profile Setup

Iterm sync requires some manual effort. I save an instance of my settings in iCloud, which allows me to sync my iTerm2 profile across devices. Here’s how to set it up:

1. Open iTerm2 → Preferences (`⌘ + ,`)
2. Go to the **General** tab → **Preferences**
3. Enable **"Load preferences from a custom folder"**
4. Set the path to the "iterm-profile.json"
5. Restart iTerm2

