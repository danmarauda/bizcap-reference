#!/bin/bash

# Daytona post-create script for OpenCode workspace
# This runs after the workspace is created but before it's started

set -e

echo "🚀 Setting up OpenCode Daytona workspace..."

# Create OpenCode config directory if it doesn't exist
mkdir -p ~/.config/opencode

# Copy example config if no config exists
if [ ! -f ~/.config/opencode/opencode.jsonc ]; then
    echo "📋 Setting up default OpenCode configuration..."
    cp /workspace/opencode.jsonc ~/.config/opencode/opencode.jsonc 2>/dev/null || true
fi

# Copy environment template if .env doesn't exist
if [ ! -f /workspace/.env ]; then
    echo "🔑 Setting up environment template..."
    cp /workspace/.env.example /workspace/.env 2>/dev/null || true
fi

# Install any additional dependencies if needed
echo "📦 Installing additional dependencies..."
bun install || npm install || echo "No package.json found, skipping dependency installation"

# Initialize git repo if not already done
if [ ! -d .git ]; then
    echo "📚 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: OpenCode Daytona workspace" || echo "Git commit failed, continuing..."
fi

echo "✅ OpenCode workspace setup complete!"
echo ""
echo "Next steps:"
echo "1. Set your API keys in .env file"
echo "2. Run 'opencode' to start the AI coding agent"
echo "3. Use 'opencode --help' for available commands"