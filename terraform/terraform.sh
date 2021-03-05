#!/bin/bash

#
# This is a utility bash script, which automatically download into `.bin`
# the respective TERRAFORM cli to use with the given TERRAFORM_VERSION env variiable
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

# Detect TERRAFORM_VERSION version
if [ -z "$TERRAFORM_VERSION" ]; then
	TERRAFORM_VERSION="0.14.7"
fi

# Remove any `v` prefix if found
if [[ "$TERRAFORM_VERSION" == v* ]]; then
    TERRAFORM_VERSION="${TERRAFORM_VERSION:1}"
fi

# The directory path
CLI_BIN_DIR="$SCRIPT_DIR/.bin/$OS_PLATFORM/$TERRAFORM_VERSION"
# The final CLI bin path
CLI_BIN_PATH="$CLI_BIN_DIR/terraform"

# The download URL
CLI_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS_PLATFORM}_amd64.zip"

# Download the file if needed
if [ ! -f "$CLI_BIN_PATH" ]; then

    # Ensure the dir path exists
    if [ ! -d "$CLI_BIN_DIR" ]; then
        mkdir -p "$CLI_BIN_DIR"
    fi
    cd "$CLI_BIN_DIR" 
    
    # Download an unzip / untar
    curl -LO "$CLI_DOWNLOAD_URL"
	unzip terraform_${TERRAFORM_VERSION}_${OS_PLATFORM}_amd64.zip

    # Rename / move the filepath (if needed)
	# mv "$CLI_BIN_DIR/terraform-$TERRAFORM_VERSION/terraform" "$CLI_BIN_DIR/"

    # Reset to working dir
    cd "$CUR_WRK_DIR"
fi
chmod +x "$CLI_BIN_PATH"

# Execute the file respectively
"$CLI_BIN_PATH" $@
