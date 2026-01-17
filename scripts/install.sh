#!/bin/bash

# Ag-Khoata Installer Script
# Usage: curl -sL https://raw.githubusercontent.com/phamminhkhoa2k4/khoata-tool/master/scripts/install.sh | bash

set -e

REPO="phamminhkhoa2k4/khoata-tool"
BINARY_NAME="ag-khoata"
INSTALL_DIR="/usr/local/bin"

# Detect OS and Arch
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
    ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

if [ "$OS" == "darwin" ]; then
  FILE_NAME="${BINARY_NAME}-darwin-${ARCH}"
elif [ "$OS" == "linux" ]; then
  FILE_NAME="${BINARY_NAME}-linux-${ARCH}"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo "Detected $OS $ARCH..."

# Get latest release URL
LATEST_URL="https://github.com/${REPO}/releases/latest/download/${FILE_NAME}"

echo "Downloading $BINARY_NAME from $LATEST_URL..."
curl -sL -o "$BINARY_NAME" "$LATEST_URL"

chmod +x "$BINARY_NAME"

echo "Installing to $INSTALL_DIR..."
sudo mv "$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"

echo "Successfully installed $BINARY_NAME!"
echo "Run '$BINARY_NAME --help' to get started."
