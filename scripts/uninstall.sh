#!/usr/bin/env bash
set -euo pipefail

if command -v command-v >/dev/null 2>&1; then
  command-v uninstall
elif [ -x "$HOME/.local/bin/command-v" ]; then
  "$HOME/.local/bin/command-v" uninstall
else
  launchctl bootout "gui/$(id -u)/dev.commandv.service" 2>/dev/null || true
  rm -f "$HOME/Library/LaunchAgents/dev.commandv.service.plist"
  rm -f "$HOME/.local/bin/command-v"
fi
