#!/usr/bin/env bash
set -euo pipefail

if command -v cmd-v >/dev/null 2>&1; then
  cmd-v uninstall
elif [ -x "$HOME/.local/bin/cmd-v" ]; then
  "$HOME/.local/bin/cmd-v" uninstall
elif [ -x "/opt/homebrew/bin/cmd-v" ]; then
  "/opt/homebrew/bin/cmd-v" uninstall
elif [ -x "/usr/local/bin/cmd-v" ]; then
  "/usr/local/bin/cmd-v" uninstall
else
  launchctl bootout "gui/$(id -u)/io.github.serkanemir.cmdv" 2>/dev/null || true
  rm -f "$HOME/Library/LaunchAgents/io.github.serkanemir.cmdv.plist"
  rm -f "$HOME/.local/bin/cmd-v"
  rm -f "/opt/homebrew/bin/cmd-v" 2>/dev/null || true
  rm -f "/usr/local/bin/cmd-v" 2>/dev/null || true
fi
