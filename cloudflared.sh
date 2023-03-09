#!/bin/bash

# ---------------------------------------------------------------------------
#
# This is a utility bash script, which automatically download into `.bin`
# the respective kubectl to use with the given VERSION env variiable
#
# With default fallbacks of course
#
# ---------------------------------------------------------------------------

# Default version configuration
# ---------------------------------------------------------------------------

# The current script namespace
PKG_NAME="cloudflared"

# Configure the default version
if [ -z "$CLOUDFLARED_VERSION" ]; then
	BIN_VERSION="2022.9.0"
fi

# Remove any `v` prefix if found
if [[ "$CLOUDFLARED_VERSION" == v* ]]; then
    BIN_VERSION="${CLOUDFLARED_VERSION:1}"
fi

# Config cleanup
# ---------------------------------------------------------------------------

# The current working directory
CUR_WRK_DIR="$(pwd)"

# Get the current script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get the full uname -a
UNAME_A="$(uname -a)"

# Lets detect linux or mac os platform
OS_PLATFORM="linux"

# Lets detet the architecture
OS_ARCH="amd64"
if [ "$UNAME_A" == *"arm64"* ]; then
	OS_ARCH="arm64"
fi

if [ "$UNAME_A" == *"Darwin"* ]; then
    # Use the darwin x64 build, for the macos environment
	OS_PLATFORM="darwin"
    OS_ARCH="amd64"
elif [ "$UNAME_A" == *"Linux"* ]; then
    # Do something under GNU/Linux platform
elif [ "$UNAME_A" == *"MINGW32_NT"* ]; then
    # Do something under 32 bits Windows NT platform
elif [ "$UNAME_A" == *"MINGW64_NT"* ]; then
    # Do something under 64 bits Windows NT platform
fi

# Ensure the dir exists
BIN_DIR="$SCRIPT_DIR/.bin/$PKG_NAME/$OS_PLATFORM/$BIN_VERSION"
if [ ! -d "$BIN_DIR" ]; then
	mkdir -p "$BIN_DIR"
fi

# Prepare the download URL
BIN_PKG_URL="https://github.com/cloudflare/cloudflared/releases/download/$BIN_VERSION/$PKG_NAME-$OS_PLATFORM-$OS_ARCH"

# Ensure the executable file exists
BIN_FILE="$BIN_DIR/cloudflared"
if [ ! -f "$BIN_FILE" ]; then

    # Ensure the dir path exists
    if [ ! -d "$BIN_DIR" ]; then
        mkdir -p "$BIN_DIR"
    fi
    cd "$BIN_DIR" 
    
    # Download the package
    curl -LO "$BIN_PKG_URL"

    # Unzip / untar
	# tar -zxvf $PKG_NAME-$OS_PLATFORM-$OS_ARCH.tar.gz

    # Rename the binary file
    mv $PKG_NAME-$OS_PLATFORM-$OS_ARCH $PKG_NAME

    # Reset to working dir
    cd "$CUR_WRK_DIR"
fi
chmod +x "$BIN_FILE"

# Execute the file respectively
"$BIN_FILE" "$@"