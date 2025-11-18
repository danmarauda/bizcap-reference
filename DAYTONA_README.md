# OpenCode in Daytona

Run OpenCode AI coding agent in a Daytona cloud development workspace.

## What is Daytona?

[Daytona](https://daytona.io) is a cloud-based development environment platform that provides fully configured, ephemeral development workspaces in the cloud.

## Features

- **Cloud-based**: Run OpenCode in the cloud without local setup
- **Ephemeral**: Clean workspace for each session
- **Persistent**: Configuration and data persist across sessions
- **Collaborative**: Share workspaces with team members
- **Reproducible**: Consistent environment every time

## Quick Start

### 1. Install Daytona CLI

```bash
# Install Daytona CLI
curl -fsSL https://download.daytona.io/daytona/install.sh | bash

# Verify installation
daytona version
```

### 2. Create OpenCode Workspace

```bash
# Clone this repository
git clone <your-repo-url>
cd <repo-directory>

# Create Daytona workspace
daytona create .

# Or specify a custom name
daytona create . --name my-opencode-workspace
```

### 3. Start the Workspace

```bash
# Start the workspace
daytona start

# Open in VS Code
daytona code
```

### 4. Configure API Keys

Once the workspace is running:

```bash
# Edit the .env file
code .env

# Add your API keys
ANTHROPIC_API_KEY=sk-ant-api03-your-key-here
OPENAI_API_KEY=sk-your-openai-key-here
```

### 5. Start OpenCode

```bash
# Start OpenCode
opencode

# Or run a specific task
opencode run "Create a React component"
```

## Configuration

### Environment Variables

Set these in your `.env` file:

```bash
# Required: At least one API key
ANTHROPIC_API_KEY=sk-ant-api03-...
OPENAI_API_KEY=sk-...

# Optional: Default model
OPENCODE_MODEL=anthropic/claude-sonnet-4-5

# Optional: Other providers
GROQ_API_KEY=gsk_...
GOOGLE_API_KEY=...
```

### OpenCode Configuration

The workspace includes a default `opencode.jsonc` configuration. You can modify it:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "theme": "opencode",
  "autoupdate": false,
  "tools": {
    "bash": true,
    "read": true,
    "write": true
  }
}
```

## Workspace Structure

```
/workspace/
├── .daytona/           # Daytona configuration
├── scripts/            # Setup scripts
├── opencode.jsonc      # OpenCode config
├── .env.example        # Environment template
└── Dockerfile.daytona  # Daytona-specific Dockerfile
```

## Daytona Commands

```bash
# List workspaces
daytona list

# Stop workspace
daytona stop

# Delete workspace
daytona delete

# SSH into workspace
daytona ssh

# View logs
daytona logs
```

## Persistence

- **Configuration**: Stored in `~/.config/opencode` (persists across sessions)
- **Project Files**: Stored in `/workspace` (persists across sessions)
- **Environment**: Rebuilt from Dockerfile each time (for consistency)

## Troubleshooting

### API Key Issues

```bash
# Check if keys are loaded
echo $ANTHROPIC_API_KEY

# Reconfigure OpenCode auth
opencode auth login
```

### Workspace Issues

```bash
# Restart workspace
daytona stop
daytona start

# Rebuild workspace
daytona delete
daytona create .
```

### OpenCode Issues

```bash
# Check OpenCode version
opencode --version

# Reinstall OpenCode
bun install -g opencode-ai
```

## Advanced Usage

### Custom Daytona Config

Modify `.daytona/config.yaml` to customize:

- Base image
- Environment variables
- Exposed ports
- VS Code extensions
- Git configuration

### Multiple Projects

```bash
# Create separate workspaces for different projects
daytona create ./project1 --name project1-workspace
daytona create ./project2 --name project2-workspace
```

### Team Collaboration

```bash
# Share workspace with team
daytona share

# Others can join with the provided URL
```

## Resources

- [Daytona Documentation](https://docs.daytona.io)
- [OpenCode Documentation](https://opencode.ai/docs)
- [Daytona GitHub](https://github.com/daytonaio/daytona)
- [OpenCode GitHub](https://github.com/sst/opencode)

## Support

- [Daytona Discord](https://discord.gg/daytona)
- [OpenCode Discord](https://opencode.ai/discord)
- [OpenCode GitHub Issues](https://github.com/sst/opencode/issues)