# Ansible

Personal machine bootstrap. Handles core tools, Cursor Agent CLI, dotfiles, and optional personal extras (MCP servers, flights workspace).

Clone path on this machine: `~/personal-harness/ansible` (legacy docs may say `~/me/ansible`).

## New Machine Setup

**Step 1 — Manual prereqs (~5 min):**

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git ansible
# Clone via HTTPS — intentional, SSH not set up yet (playbook installs it)
git clone https://github.com/zjromani/ansible ~/personal-harness/ansible
```

**Step 2 — Run playbook:**

```sh
cd ~/personal-harness/ansible
ansible-playbook local.yml --ask-vault-pass --ask-become-pass
```

- **BECOME password** = macOS login password (used for sudo)
- **Vault password** = Ansible vault password (decrypts SSH key + secrets)

The playbook installs: SSH keys, core brew tools (`gh`, `git`, `tmux`, `fzf`, etc.), **Cursor Agent CLI** (`agent` / `cursor-agent`), neovim, Node via NVM, zsh + Oh My Zsh, dotfiles (stowed, including portable `agents/` skills), tmux plugins, iTerm2 preferences, and `~/.zshenv_private` from vault.

It does **not** write Cursor MCP config by default.

**Step 3 — After playbook:**

```sh
gh auth login   # required before flights workspace task can clone private repos
```

**Step 4 (optional) — Flights workspace:**

```sh
ansible-playbook local.yml --ask-vault-pass --ask-become-pass --tags flights
```

## Optional: Cursor MCP (personal machine only)

MCP servers live in this repo (`scripts/setup-mcps.sh`), not in shared `.dotfiles`. Opt-in only:

```sh
# Direct
~/personal-harness/ansible/scripts/setup-mcps.sh

# Or via ansible
cd ~/personal-harness/ansible
ansible-playbook local.yml --ask-vault-pass --tags cursor-mcp -e enable_cursor_mcp=true
```

Then OAuth where needed:

```sh
agent mcp login krisp
agent mcp login readwise
```

## Updating Existing Machines

```sh
cd ~/personal-harness/ansible
ansible-playbook update.yml
```

Or update specific components:

```sh
ansible-playbook update.yml --tags dotfiles
ansible-playbook update.yml --tags tmux
```

MCP is skipped on update unless you pass `-e enable_cursor_mcp=true`.

## Vault

Two things are vault-encrypted in this repo:

- `.ssh/id_rsa` — SSH private key (AES256)
- `vars/secrets.yml` — all `~/.zshenv_private` env vars

Both use the same vault password. The vault is the source of truth for secrets — `~/.zshenv_private` on any machine is written from it by the playbook.

### Viewing secrets

```sh
ansible-vault view vars/secrets.yml
```

### Updating a secret (e.g. rotated API token)

```sh
# 1. Edit the vault file
ansible-vault edit vars/secrets.yml

# 2. Commit and push
git add vars/secrets.yml && git commit -m "Updated <token name>" && git push

# 3. Re-deploy secrets (and MCP only if you want)
ansible-playbook local.yml --ask-vault-pass --ask-become-pass --tags secrets
ansible-playbook local.yml --ask-vault-pass --tags cursor-mcp -e enable_cursor_mcp=true
```

### Adding a new secret

Same as updating — open `vars/secrets.yml` with `ansible-vault edit`, add the new `export VAR="value"` line inside the `zshenv_private` block, commit, push, re-deploy.

## SSH

SSH key is stored vault-encrypted in `.ssh/id_rsa`. The playbook decrypts and installs it to `~/.ssh/id_rsa`, then uses it to clone dotfiles via SSH. This is why the vault password is required even on a fresh machine.

## iTerm2

iTerm2 preferences are synced via dotfiles (stowed from `~/.dotfiles/iterm2/`). The AppSupport symlink is created by the playbook — no manual import needed. iTerm2 will load preferences from `~/.config/iterm2/` automatically on first launch.
