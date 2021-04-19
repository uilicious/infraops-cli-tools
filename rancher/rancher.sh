#!/bin/bash

#
# This is a utility bash script, which automatically download into `.bin`
# the respective RANCHER_CLI to use with the given RANCHER_CLI_VERSION env variiable
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

# Detect RANCHER_CLI version
if [ -z "$RANCHER_CLI_VERSION" ]; then
	RANCHER_CLI_VERSION="v2.3.1"
fi

# Ensure the dir exists
RANCHER_CLI_BIN_DIR="$SCRIPT_DIR/.bin/$OS_PLATFORM/$RANCHER_CLI_VERSION"
if [ ! -d "$RANCHER_CLI_BIN_DIR" ]; then
	mkdir -p "$RANCHER_CLI_BIN_DIR"
fi

# Ensure the executable file exists
RANCHER_CLI_BIN="$RANCHER_CLI_BIN_DIR/rancher"
RANCHER_CLI_URL="https://releases.rancher.com/cli2/$RANCHER_CLI_VERSION/rancher-$OS_PLATFORM-amd64-$RANCHER_CLI_VERSION.tar.gz"
if [ ! -f "$RANCHER_CLI_BIN" ]; then
	$(cd "$RANCHER_CLI_BIN_DIR" && curl -LO "$RANCHER_CLI_URL")
	$(cd "$RANCHER_CLI_BIN_DIR" && tar -zxvf rancher-$OS_PLATFORM-amd64-$RANCHER_CLI_VERSION.tar.gz )
	$(mv "$RANCHER_CLI_BIN_DIR/rancher-$RANCHER_CLI_VERSION/rancher" "$RANCHER_CLI_BIN_DIR/" )
fi
chmod +x "$RANCHER_CLI_BIN"

# Rancher home dir detection
# this work around known issues for detecting cli2.json
#
# This is a hackish workaround for `$RANCHER_HOME/.rancher/cli2.json`
#
# See: https://github.com/rancher/rancher/issues/15195
if [ -d "$RANCHER_HOME" ]; then
	# Execute with custom home dir
	HOME="$RANCHER_HOME" "$RANCHER_CLI_BIN" "$@"
else
	# Execute directly
	HOME="$SCRIPT_DIR" "$RANCHER_CLI_BIN" "$@"
fi
