#!/bin/bash

echo "Starting entrypoint script..."

# Fail if one of the commands fails
set -e

# Retrieve the script parameters
SCRIPT_NAME=${1}
APP_PATH=${2}
DEVICE=${3}
TYPE_CHECK_LEVEL=${4}
CERTIFICATE=${5}

case "${SCRIPT_NAME}" in
	TEST)
		SCRIPT_PATH="/scripts/test.sh"
		;;
	INFO)
		SCRIPT_PATH="/scripts/info.sh"
		;;
	*)
		echo "Bad scipt name: '${SCRIPT_NAME}'."
		exit 1
esac


# Display the script parameters
echo "SCRIPT: ${SCRIPT_NAME}(${SCRIPT_PATH})"
echo "APP_PATH: ${APP_PATH}"
echo "DEVICE: ${DEVICE}"
echo "TYPE_CHECK_LEVEL: ${TYPE_CHECK_LEVEL}"
echo "CERTIFICATE: ${CERTIFICATE}"

# Restore the HOME enviroment variable
export HOME=/root

# Entering folder when the app is stored relatively to the GitHub workspace
echo "Entering folder $APP_PATH..."
cd "$APP_PATH"

# Run the script 
echo "********************************************************************************"
echo "**************************   Starting Script (TEST)   **************************"
echo "********************************************************************************"
/bin/bash ${SCRIPT_PATH} --device=${DEVICE} --type-check-level=${TYPE_CHECK_LEVEL}
result=$?
echo "********************************************************************************"
echo "*****************************   Script Completed  ******************************"
echo "********************************************************************************"
echo "Script exit code: $result"

#set output variable
if [[ $result -eq 0 ]];
then
	echo "status=success" >> "$GITHUB_OUTPUT"
else
	echo "status=failure" >> "$GITHUB_OUTPUT"
fi

exit "$result"
