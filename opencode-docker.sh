#!/bin/bash

# OpenCode Docker Helper Script
# Usage: ./opencode-docker.sh [command]

set -e

COMMAND=${1:-"up"}

case $COMMAND in
    "build")
        echo "Building OpenCode Docker image..."
        docker-compose build --no-cache
        ;;
    "up")
        echo "Starting OpenCode..."
        docker-compose up
        ;;
    "up-d")
        echo "Starting OpenCode in detached mode..."
        docker-compose up -d
        ;;
    "down")
        echo "Stopping OpenCode..."
        docker-compose down
        ;;
    "restart")
        echo "Restarting OpenCode..."
        docker-compose restart
        ;;
    "logs")
        echo "Showing OpenCode logs..."
        docker-compose logs -f
        ;;
    "shell")
        echo "Opening shell in OpenCode container..."
        docker-compose exec opencode bash
        ;;
    "clean")
        echo "Cleaning up OpenCode containers and volumes..."
        docker-compose down -v
        docker system prune -f
        ;;
    "reset-config")
        echo "Resetting OpenCode configuration..."
        docker-compose down
        docker volume rm opencode_opencode_config 2>/dev/null || true
        docker-compose up -d
        ;;
    *)
        echo "Usage: $0 {build|up|up-d|down|restart|logs|shell|clean|reset-config}"
        echo ""
        echo "Commands:"
        echo "  build        - Build the Docker image"
        echo "  up           - Start OpenCode (attached)"
        echo "  up-d         - Start OpenCode (detached)"
        echo "  down         - Stop OpenCode"
        echo "  restart      - Restart OpenCode"
        echo "  logs         - Show container logs"
        echo "  shell        - Open shell in container"
        echo "  clean        - Remove containers and volumes"
        echo "  reset-config - Reset OpenCode configuration"
        exit 1
        ;;
esac