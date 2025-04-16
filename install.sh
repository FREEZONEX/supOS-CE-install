#!/bin/bash

set -e

# Step 1: Detect operating system
OS=$(uname -s)
case "$OS" in
  MINGW64_NT*)
    echo "✅ Detected Windows environment (Git Bash), proceeding..."

    if ! command -v wsl >/dev/null 2>&1; then
      echo "❌ Error: 'wsl' command not found. Please make sure WSL is enabled."
      exit 1
    fi

    echo "🔍 Checking if Docker is using WSL2..."
    WSL_OUT=$(wsl -l -v | tr -d '\r\0')

    if ! echo "$WSL_OUT" | grep -E "\*?\s*docker-desktop\s+Running\s+2" >/dev/null 2>&1; then
      echo "❌ Error: Docker is not using the WSL2 backend."
      echo "👉 Please open Docker Desktop settings -> General, and enable 'Use the WSL 2 based engine'."
      exit 1
    fi

    echo "✅ WSL2 check passed. Docker backend is valid."
    ;;

  Linux)
    echo "✅ Detected Linux environment, proceeding with installation..."
    ;;

  *)
    echo "❌ Unsupported operating system: $OS"
    exit 1
    ;;
esac

# Step 2: Check if git is installed
echo "🔍 Checking for git..."
if ! command -v git >/dev/null 2>&1; then
  echo "❌ Error: git is not installed. Please install git and try again."
  exit 1
fi

# Step 3: Check for docker and docker compose
echo "🔍 Checking for docker..."
if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Error: docker is not installed. Please install Docker and try again."
  exit 1
fi

echo "🔍 Checking for docker compose..."
if ! command -v docker compose >/dev/null 2>&1; then
  echo "❌ Error: 'docker compose' command not found (note: not 'docker-compose')."
  exit 1
fi

# Prompt user before proceeding
echo ""
echo "✅ All pre-installation checks passed."
read -p "Do you want to clone the repository and start the installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "❎ Installation aborted by user."
  exit 0
fi

# Step 4: Clone the repository
echo "📦 Cloning repository supOS-CE..."
git clone https://github.com/FREEZONEX/supOS-CE.git

# Step 5: Run the installation script
echo "🚀 Running installation script..."
bash supOS-CE/bin/startup.sh

