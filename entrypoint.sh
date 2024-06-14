#!/bin/bash

echo "Starting entrypoint script..."

# Fail if one of the commands fails
set -e

# Retrieve the script parameters
APP_PATH=$1
DEVICE=$2
TYPE_CHECK_LEVEL=2
# CERTIFICATE=$3

# Display the script parameters
echo "APP_PATH: ${APP_PATH}"
echo "DEVICE: ${DEVICE}"
echo "TYPE_CHECK_LEVEL: ${TYPE_CHECK_LEVEL}"

# Override the HOME enviroment variable
# export HOME=/root

# Entering folder when the app is stored relatively to the GitHub workspace
if [[ -n $1 ]]
then
	echo "Entering folder $APP_PATH..."
	cd "$APP_PATH"
	echo "Now in folder $(pwd)"
fi

# Run tests
echo "Running tests on device [$DEVICE] with certificate [$CERTIFICATE_PATH]..."

/scripts/test.sh --device=${DEVICE} --type-check-level=${TYPE_CHECK_LEVEL}
result=$?
echo "Script exit code: $result"

#set output variable
if [[ $result -eq 0 ]];
then
	echo "status=success" >> "$GITHUB_OUTPUT"
else
	echo "status=failure" >> "$GITHUB_OUTPUT"
fi

exit "$result"
