#!/bin/bash

# Install Homebrew if not already installed.
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
brew bundle install --file="$(dirname "$0")/../packages/Brewfile"

echo "Done!"
