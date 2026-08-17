#!/bin/bash
# Personal-machine only: materialize ~/.cursor/mcp.json from secrets.
# Not part of default ansible — run directly, or:
#   ansible-playbook local.yml --tags cursor-mcp -e enable_cursor_mcp=true
#
# Sources ~/.zshenv_private. Missing secrets warn and skip that MCP.
# Cursor GUI does not inherit ~/.zshenv_private, so this expands tokens.
# OAuth after setup:
#   agent mcp login krisp
#   agent mcp login readwise

set -euo pipefail

if [ -f ~/.zshenv_private ]; then
  # shellcheck disable=SC1090
  source ~/.zshenv_private
fi

write_cursor_mcp_json() {
  local out="$HOME/.cursor/mcp.json"
  mkdir -p "$HOME/.cursor"

  if [ -L "$out" ]; then
    rm "$out"
  fi

  local exec_circle_entry=""
  if [ -n "${EXEC_CIRCLE_TOKEN:-}" ]; then
    exec_circle_entry=$(cat <<EOF
,
    "executive-circle": {
      "url": "https://www.contentmasterpro.limited/api/mcp/subscriber/${EXEC_CIRCLE_TOKEN}"
    }
EOF
)
  else
    echo "Skipping Cursor executive-circle MCP: EXEC_CIRCLE_TOKEN not set in ~/.zshenv_private."
  fi

  cat >"$out" <<EOF
{
  "mcpServers": {
    "krisp": {
      "url": "https://mcp.krisp.ai/mcp"
    },
    "readwise": {
      "url": "https://mcp2.readwise.io/mcp"
    },
    "playwright": {
      "command": "${HOME}/.dotfiles/bin/scripts/run-mcp-npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "env": {
        "NPM_CONFIG_PREFIX": " ",
        "npm_config_prefix": " "
      }
    },
    "airbnb": {
      "command": "${HOME}/.dotfiles/bin/scripts/run-mcp-npx",
      "args": ["-y", "@openbnb/mcp-server-airbnb", "--ignore-robots-txt"],
      "env": {
        "NPM_CONFIG_PREFIX": " ",
        "npm_config_prefix": " "
      }
    },
    "vrbo": {
      "command": "${HOME}/.dotfiles/bin/scripts/run-mcp-npx",
      "args": ["-y", "@striderlabs/mcp-vrbo"],
      "env": {
        "NPM_CONFIG_PREFIX": " ",
        "npm_config_prefix": " "
      }
    },
    "alltrails": {
      "url": "https://www.alltrails.com/mcp"
    }${exec_circle_entry}
  }
}
EOF
  echo "Wrote Cursor MCP config: $out"
}

write_cursor_mcp_json
