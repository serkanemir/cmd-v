#!/usr/bin/env bash
set -euo pipefail

source_bin="$HOME/.local/bin/cmd-v"
plist="$HOME/Library/LaunchAgents/io.github.serkanemir.cmdv.plist"

if [ -x "$source_bin" ]; then
  "$source_bin" uninstall
  exit 0
fi

if [ -f "$plist" ]; then
  program_path="$(/usr/libexec/PlistBuddy -c 'Print :ProgramArguments:0' "$plist" 2>/dev/null || true)"
  if [ "$program_path" = "$source_bin" ]; then
    launchctl bootout "gui/$(id -u)/io.github.serkanemir.cmdv" 2>/dev/null || true
    rm -f "$plist"
  fi
fi

rm -f "$source_bin"
echo "No source cmd-v installation found at $source_bin."
echo "If you installed with Homebrew, run: brew services stop cmd-v && brew uninstall cmd-v"
