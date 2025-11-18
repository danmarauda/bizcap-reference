# OpenCode Docker Setup

This Docker setup provides a reproducible OpenCode environment with persistent file storage and memory.

## Features

- **Reproducible**: Consistent environment across different machines
- **Persistent Config**: OpenCode configuration persists between container runs
- **Persistent Data**: Session history and project data are preserved
- **Volume Mounts**: Access to your local project files
- **Environment Variables**: Secure API key management

## Quick Start

1. **Clone or copy this setup** into your project directory

2. **Set your API keys** in a `.env` file or export them:
   ```bash
   export ANTHROPIC_API_KEY="your-anthropic-key"
   export OPENAI_API_KEY="your-openai-key"
   ```

3. **Build and run**:
   ```bash
   docker-compose up --build
   ```

## Usage

### Basic Usage
```bash
# Start OpenCode
docker-compose up

# Run in detached mode
docker-compose up -d

# Stop the container
docker-compose down
```

### With Environment Variables
Create a `.env` file in the project root:
```
ANTHROPIC_API_KEY=sk-ant-api03-...
OPENAI_API_KEY=sk-...
OPENCODE_MODEL=anthropic/claude-sonnet-4-5
```

### Custom Configuration
The container uses persistent volumes for:
- `/root/.config/opencode` - OpenCode configuration
- `/root/.opencode` - OpenCode data and sessions

Your project files are mounted at `/workspace`.

## Configuration

### OpenCode Config
You can create an `opencode.jsonc` file in your project root. It will be automatically loaded:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "theme": "opencode",
  "autoupdate": false
}
```

### Environment Variables
- `ANTHROPIC_API_KEY` - Anthropic API key
- `OPENAI_API_KEY` - OpenAI API key
- `OPENCODE_MODEL` - Default model to use
- `OPENCODE_CONFIG_DIR` - Config directory (auto-set)

## Persistent Storage

The setup creates two Docker volumes:
- `opencode_config` - Stores OpenCode configuration
- `opencode_data` - Stores session data and history

To reset configuration:
```bash
docker-compose down
docker volume rm opencode_opencode_config
docker-compose up
```

## Development

### Rebuilding
```bash
docker-compose build --no-cache
```

### Accessing Container Shell
```bash
docker-compose exec opencode bash
```

### Logs
```bash
docker-compose logs -f opencode
```

## Troubleshooting

### Permission Issues
If you encounter permission issues with mounted volumes:
```bash
# Fix permissions on mounted directories
docker-compose exec opencode chown -R $(id -u):$(id -g) /workspace
```

### API Key Issues
Make sure your API keys are properly set:
```bash
docker-compose exec opencode opencode auth login
```

### Git Access
SSH keys are mounted read-only. If you need git access:
```bash
# Make sure your SSH keys have correct permissions
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

## Advanced Usage

### Server Mode
To run OpenCode in server mode (for integrations):
```yaml
# Modify docker-compose.yml
services:
  opencode:
    command: ["opencode", "server"]
    ports:
      - "4096:4096"
```

### Custom Base Image
For different Node.js versions, modify the Dockerfile:
```dockerfile
FROM node:18-slim  # or node:21-slim
```

### Multiple Projects
For multiple projects, create separate compose files:
```bash
cp docker-compose.yml docker-compose.project2.yml
# Edit project2 compose file with different container name and volumes
```