#!/bin/bash

# Daytona OpenCode Workspace Manager
# Usage: ./daytona-opencode.sh [command]

set -e

WORKSPACE_NAME=${DAYTONA_WORKSPACE_NAME:-"opencode-workspace"}

COMMAND=${1:-"status"}

case $COMMAND in
    "create")
        echo "Creating Daytona OpenCode workspace..."
        daytona create . --name "$WORKSPACE_NAME"
        ;;
    "start")
        echo "Starting Daytona workspace: $WORKSPACE_NAME"
        daytona start "$WORKSPACE_NAME"
        ;;
    "stop")
        echo "Stopping Daytona workspace: $WORKSPACE_NAME"
        daytona stop "$WORKSPACE_NAME"
        ;;
    "delete")
        echo "Deleting Daytona workspace: $WORKSPACE_NAME"
        daytona delete "$WORKSPACE_NAME"
        ;;
    "code")
        echo "Opening workspace in VS Code: $WORKSPACE_NAME"
        daytona code "$WORKSPACE_NAME"
        ;;
    "ssh")
        echo "SSH into workspace: $WORKSPACE_NAME"
        daytona ssh "$WORKSPACE_NAME"
        ;;
    "logs")
        echo "Showing workspace logs: $WORKSPACE_NAME"
        daytona logs "$WORKSPACE_NAME"
        ;;
    "status")
        echo "Daytona workspace status:"
        daytona list
        ;;
    "info")
        echo "Workspace info: $WORKSPACE_NAME"
        daytona info "$WORKSPACE_NAME"
        ;;
    "setup")
        echo "Setting up Daytona OpenCode workspace..."
        echo "1. Creating workspace..."
        daytona create . --name "$WORKSPACE_NAME"
        echo "2. Starting workspace..."
        daytona start "$WORKSPACE_NAME"
        echo "3. Opening in VS Code..."
        sleep 5
        daytona code "$WORKSPACE_NAME"
        ;;
    *)
        echo "Daytona OpenCode Workspace Manager"
        echo ""
        echo "Usage: $0 {create|start|stop|delete|code|ssh|logs|status|info|setup}"
        echo ""
        echo "Commands:"
        echo "  create   - Create new workspace"
        echo "  start    - Start workspace"
        echo "  stop     - Stop workspace"
        echo "  delete   - Delete workspace"
        echo "  code     - Open in VS Code"
        echo "  ssh      - SSH into workspace"
        echo "  logs     - Show workspace logs"
        echo "  status   - List all workspaces"
        echo "  info     - Show workspace info"
        echo "  setup    - Create, start, and open workspace"
        echo ""
        echo "Environment variables:"
        echo "  DAYTONA_WORKSPACE_NAME - Custom workspace name (default: opencode-workspace)"
        exit 1
        ;;
esac