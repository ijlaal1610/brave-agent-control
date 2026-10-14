#!/usr/bin/env bash
# setup-brave-bridge.sh
# Sets up the DevToolsActivePort bridge for Antigravity & AI agents to control active Brave sessions.

set -e

echo "=== Configuring Brave DevTools Bridge for AI Agents ==="

# 1. Ensure Chrome config dir exists
mkdir -p "$HOME/.config/google-chrome"

# 2. Check if Brave config dir exists
BRAVE_CONFIG="$HOME/.config/BraveSoftware/Brave-Browser"
if [ ! -d "$BRAVE_CONFIG" ]; then
  echo "⚠️ Warning: $BRAVE_CONFIG does not exist yet. It will be created when Brave is launched."
  mkdir -p "$BRAVE_CONFIG"
fi

# 3. Create symbolic link
ln -sf "$BRAVE_CONFIG/DevToolsActivePort" "$HOME/.config/google-chrome/DevToolsActivePort"
echo "✅ Symlink created: $HOME/.config/google-chrome/DevToolsActivePort -> $BRAVE_CONFIG/DevToolsActivePort"

# 4. Check if Brave is listening on port 9222
if ss -tulpn | grep -q ":9222 "; then
  echo "✅ Brave is currently running and listening on port 9222!"
  curl -s http://127.0.0.1:9222/json/version | grep -i "Browser" || true
else
  echo "ℹ️ Brave is not currently running with remote debugging."
  echo "To start Brave with agent control enabled, run:"
  echo "  brave-browser --remote-debugging-port=9222 &"
fi

echo "=== Setup Complete ==="
