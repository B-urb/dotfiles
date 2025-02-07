#!/bin/bash


REPO="B-urb/dotfiles"  # Replace with actual repo
BRANCH="master"
TEMP_DIR="$(mktemp -d)"
TARGET_DIR="$HOME/.dotfiles"

# Function to install Bitwarden CLI
install_bw_cli() {
    echo "Bitwarden CLI not found. Attempting to install..."

    # Detect OS and install
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y bitwarden-cli
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y bitwarden-cli
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy --noconfirm bitwarden-cli
        elif command -v zypper &> /dev/null; then
            sudo zypper install -y bitwarden-cli
        else
            echo "Unsupported Linux distribution. Please install Bitwarden CLI manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install bitwarden-cli
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        winget install --id Bitwarden.CLI -e
    else
        echo "Unsupported operating system. Please install Bitwarden CLI manually."
        exit 1
    fi
}

get_dotfiles() {

# Download and extract into temp dir
curl -L "https://github.com/$REPO/archive/$BRANCH.tar.gz" | tar xz -C "$TEMP_DIR"

# Move extracted content to target directory
mv "$TEMP_DIR/$REPO-$BRANCH" "$TARGET_DIR"

# Cleanup temp directory
#
rm -rf "$TEMP_DIR"
}

install_deps() {
    echo "Install all dependencies"

    # Detect OS and install
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            $TARGET_DIR/ubuntu/install_deps.sh
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y bitwarden-cli
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy --noconfirm bitwarden-cli
        elif command -v zypper &> /dev/null; then
            sudo zypper install -y bitwarden-cli
        else
            echo "Unsupported Linux distribution. Please install Bitwarden CLI manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew bundle $TARGET_DIR/macos/Brewfile
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        $TARGET_DIR/windows/install_deps.sh
    else
        echo "Unsupported operating system. Please install Bitwarden CLI manually."
        exit 1
    fi
    install_cargo.sh
    install_extensions.sh
    install
}

get_dotfiles
install_deps

# Check if Bitwarden CLI is installed, otherwise install it
if ! command -v bw &> /dev/null; then
    install_bw_cli
fi

# Ensure BW_SESSION is set
if [ -z "$BW_SESSION" ]; then
    echo "BW_SESSION is not set. Logging in..."
    bw config server https://warden/burbn.de
    BW_OUTPUT=$(bw login --raw)

    # Extract the session key using grep and awk
    BW_SESSION=$(echo "$BW_OUTPUT" | grep 'export BW_SESSION=' | awk -F '"' '{print $2}')
    export BW_SESSION
fi


## get ssh key from bitwarden and set
SSH_KEY=$(bw get item ssh-key --session "$BW_SESSION" | jq -r '.notes')

# Check if the key was found
if [ -z "$SSH_KEY" ]; then
    echo "Error: SSH key not found in Bitwarden."
    exit 1
fi

# Define the file path
SSH_KEY_FILE="$HOME/.ssh/id_rsa"

# Write the key to the file
echo "$SSH_KEY" > "$SSH_KEY_FILE"

# Set correct permissions
chmod 600 "$SSH_KEY_FILE"

# Ensure ssh-agent is running
eval "$(ssh-agent -s)"

# Remove old keys
ssh-add -D

# Add the new key
ssh-add "$SSH_KEY_FILE"





