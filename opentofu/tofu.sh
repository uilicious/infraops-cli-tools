#!/bin/sh
set -e

# Version / OS / Arch
if [ -z "$TOFU_VERSION" ]; then
	TOFU_VERSION="1.6.0-alpha5"
fi
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')"

# The current working directory
CUR_WRK_DIR="$(pwd)"

# Get the current script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# The directory path
CLI_BIN_DIR="$SCRIPT_DIR/.bin/$OS/$TOFU_VERSION"
# The final CLI bin path
CLI_BIN_PATH="$CLI_BIN_DIR/tofu"

# The download URL
CLI_DOWNLOAD_URL="https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_${OS}_${ARCH}.zip"

# Download the file if needed
if [ ! -f "$CLI_BIN_PATH" ]; then

	# Ensure the dir path exists
	if [ ! -d "$CLI_BIN_DIR" ]; then
		mkdir -p "$CLI_BIN_DIR"
	fi
	cd "$CLI_BIN_DIR" 
	
	# Download an unzip / untar
	curl -LO "$CLI_DOWNLOAD_URL"
	unzip "tofu_${TOFU_VERSION}_${OS}_${ARCH}.zip"

	# Remove the old zip file
	rm "tofu_${TOFU_VERSION}_${OS}_${ARCH}.zip"

	# Reset to working dir
	cd "$CUR_WRK_DIR"
fi
chmod +x "$CLI_BIN_PATH"

# Execute the file respectively
"$CLI_BIN_PATH" "$@"
