#!/bin/bash

#
# This is a utility bash script, which automatically download into `.bin`
# the respective kubectl to use with the given DOCTL_VERSION env variiable
#
# With automated fallbacks of course
#

# The current working directory
CUR_WRK_DIR="$(pwd)"

# Get the current script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Lets detect linux or mac os platform
OS_PLATFORM="linux"
if [ "$(uname)" == "Darwin" ]; then
	OS_PLATFORM="darwin"
# elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
#     # Do something under GNU/Linux platform
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
#     # Do something under 32 bits Windows NT platform
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
#     # Do something under 64 bits Windows NT platform
fi

# Detect kubectl version
if [ -z "$DOCTL_VERSION" ]; then
	DOCTL_VERSION="1.61.0"
fi

# Remove any `v` prefix if found
if [[ "$DOCTL_VERSION" == v* ]]; then
    DOCTL_VERSION="${DOCTL_VERSION:1}"
fi

# Ensure the dir exists
BIN_DIR="$SCRIPT_DIR/.bin/$OS_PLATFORM/$DOCTL_VERSION"
if [ ! -d "$BIN_DIR" ]; then
	mkdir -p "$BIN_DIR"
fi

# Prepare the download URL
BIN_PKG_URL="https://github.com/digitalocean/doctl/releases/download/v$DOCTL_VERSION/doctl-$DOCTL_VERSION-$OS_PLATFORM-amd64.tar.gz"

# Ensure the executable file exists
BIN_FILE="$BIN_DIR/doctl"
if [ ! -f "$BIN_FILE" ]; then

    # Ensure the dir path exists
    if [ ! -d "$BIN_DIR" ]; then
        mkdir -p "$BIN_DIR"
    fi
    cd "$BIN_DIR" 
    
    # Download an unzip / untar
    curl -LO "$BIN_PKG_URL"
	tar -zxvf doctl-$DOCTL_VERSION-$OS_PLATFORM-amd64.tar.gz

    # Reset to working dir
    cd "$CUR_WRK_DIR"
fi
chmod +x "$BIN_FILE"

# Execute the file respectively
"$BIN_FILE" "$@"