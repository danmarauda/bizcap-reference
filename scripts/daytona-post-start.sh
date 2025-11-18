#!/bin/bash

# Daytona post-start script for OpenCode workspace
# This runs every time the workspace starts

set -e

echo "🔄 Starting OpenCode Daytona workspace..."

# Load environment variables from .env file if it exists
if [ -f /workspace/.env ]; then
    echo "📋 Loading environment variables..."
    set -a
    source /workspace/.env
    set +a
fi

# Verify OpenCode installation
if command -v opencode &> /dev/null; then
    echo "✅ OpenCode is installed: $(opencode --version)"
else
    echo "❌ OpenCode not found, installing..."
    bun install -g opencode-ai
fi

# Check for API keys
if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$OPENAI_API_KEY" ]; then
    echo "⚠️  Warning: No API keys found!"
    echo "   Please set ANTHROPIC_API_KEY or OPENAI_API_KEY in your .env file"
    echo "   You can get API keys from:"
    echo "   - Anthropic: https://console.anthropic.com/"
    echo "   - OpenAI: https://platform.openai.com/api-keys"
fi

# Set up OpenCode configuration
export OPENCODE_CONFIG_DIR=~/.config/opencode

# Create a helpful startup message
cat << 'EOF'

🎉 OpenCode Daytona Workspace Ready!

Commands:
  opencode              - Start the AI coding agent
  opencode --help       - Show available commands
  opencode auth login   - Configure API keys
  opencode run "task"   - Run a specific task

Environment:
  Workspace: /workspace
  Config: ~/.config/opencode
  API Keys: Set in .env file

Happy coding with AI! 🤖

EOF