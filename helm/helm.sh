#!/bin/bash

#
# This is a utility bash script, which automatically download into `.bin`
# the respective helm cli to use with the given HELM_VERSION env variiable
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

# Detect HELM_VERSION version
if [ -z "$HELM_VERSION" ]; then
	HELM_VERSION="3.5.2"
fi

# Remove any `v` prefix if found
if [[ "$HELM_VERSION" == v* ]]; then
    HELM_VERSION="${HELM_VERSION:1}"
fi

# The directory path
CLI_BIN_DIR="$SCRIPT_DIR/.bin/$OS_PLATFORM/$HELM_VERSION"
# The final CLI bin path
CLI_BIN_PATH="$CLI_BIN_DIR/helm"

# The download URL
CLI_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM_VERSION}-${OS_PLATFORM}-amd64.tar.gz"

# Download the file if needed
if [ ! -f "$CLI_BIN_PATH" ]; then

    # Ensure the dir path exists
    if [ ! -d "$CLI_BIN_DIR" ]; then
        mkdir -p "$CLI_BIN_DIR"
    fi
    cd "$CLI_BIN_DIR" 
    
    # Download an unzip / untar
    curl -LO "$CLI_DOWNLOAD_URL"
	tar -zxvf helm-v${HELM_VERSION}-${OS_PLATFORM}-amd64.tar.gz

    # Rename / move the filepath (if needed)
	mv "$CLI_BIN_DIR/${OS_PLATFORM}-amd64/helm" "$CLI_BIN_DIR/"

    # Reset to working dir
    cd "$CUR_WRK_DIR"
fi
chmod +x "$CLI_BIN_PATH"

# Execute the file respectively
"$CLI_BIN_PATH" $@
