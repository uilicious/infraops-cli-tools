#!/bin/bash

#
# This is a utility bash script, which automatically download into `.bin`
# the respective kubectl to use with the given KUBECTL_VERSION env variiable
#
# With automated fallbacks of course
#

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
if [ -z "$KUBECTL_VERSION" ]; then
	KUBECTL_VERSION="v1.15.6"
fi

# Ensure the dir exists
KUBECTL_BIN_DIR="$SCRIPT_DIR/.bin/$OS_PLATFORM/$KUBECTL_VERSION"
if [ ! -d "$KUBECTL_BIN_DIR" ]; then
	mkdir -p "$KUBECTL_BIN_DIR"
fi

# Ensure the executable file exists
KUBECTL_BIN="$KUBECTL_BIN_DIR/kubectl"
KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/$OS_PLATFORM/amd64/kubectl"
if [ ! -f "$KUBECTL_BIN" ]; then
	$(cd "$KUBECTL_BIN_DIR" && curl -LO "$KUBECTL_URL")
fi
chmod +x "$KUBECTL_BIN"

# Execute the file respectively
"$KUBECTL_BIN" "$@"