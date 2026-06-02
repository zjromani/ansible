# Ansible

Personal machine bootstrap. Handles core tools, dotfiles, Claude Code, MCP servers, and flights workspace in one playbook run.

## New Machine Setup

**Step 1 — Manual prereqs (~5 min):**

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git ansible
# Clone via HTTPS — intentional, SSH not set up yet (playbook installs it)
git clone https://github.com/zjromani/ansible ~/me/ansible
```

**Step 2 — Run playbook:**

```sh
cd ~/me/ansible
ansible-playbook local.yml --ask-vault-pass --ask-become-pass
```

- **BECOME password** = macOS login password (used for sudo)
- **Vault password** = Ansible vault password (decrypts SSH key + secrets)

The playbook installs: SSH keys, core brew tools (`gh`, `git`, `tmux`, `fzf`, etc.), Claude Code CLI, neovim, Node via NVM, zsh + Oh My Zsh, dotfiles (stowed), tmux plugins, iTerm2 preferences, `~/.zshenv_private` from vault, and user-scoped MCP servers.

**Step 3 — After playbook: manual OAuth steps:**

```sh
gh auth login   # required before flights workspace task can clone private repos

# Re-auth claude.ai OAuth MCPs (Slack, Linear, Gmail, Figma, etc.)
# → claude.ai/settings → Integrations
```

**Step 4 — Re-run to pick up flights workspace + MCPs:**

```sh
ansible-playbook local.yml --ask-vault-pass --ask-become-pass --tags flights,claude-mcp
```

## Updating Existing Machines

```sh
cd ~/me/ansible
ansible-playbook update.yml
```

Or update specific components:

```sh
ansible-playbook update.yml --tags dotfiles
ansible-playbook update.yml --tags tmux
```

## Vault

Two things are vault-encrypted in this repo:

- `.ssh/id_rsa` — SSH private key (AES256)
- `vars/secrets.yml` — all `~/.zshenv_private` env vars

Both use the same vault password. To edit secrets:

```sh
ansible-vault edit vars/secrets.yml
```

## SSH

SSH key is stored vault-encrypted in `.ssh/id_rsa`. The playbook decrypts and installs it to `~/.ssh/id_rsa`, then uses it to clone dotfiles via SSH. This is why the vault password is required even on a fresh machine.

## iTerm2

iTerm2 preferences are synced via dotfiles (stowed from `~/.dotfiles/iterm2/`). The AppSupport symlink is created by the playbook — no manual import needed. iTerm2 will load preferences from `~/.config/iterm2/` automatically on first launch.

