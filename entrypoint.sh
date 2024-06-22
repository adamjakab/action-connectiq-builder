#!/bin/bash

echo "Starting ConnectIQ Builder GitHub Action entrypoint script..."

# Fail if one of the commands fails
set -e

# Retrieve the script parameters
OPERATION=${1}
APP_PATH=${2}
DEVICE=${3}
TYPE_CHECK_LEVEL=${4}
CERTIFICATE=${5}
PACKAGE_NAME=${6}

# Select the script based on the operation
case "${OPERATION}" in
	INFO)
		SCRIPT_PATH="/scripts/info.sh"
		;;
	TEST)
		SCRIPT_PATH="/scripts/test.sh"
		;;
	PACKAGE)
		SCRIPT_PATH="/scripts/package.sh"
		;;
	*)
		echo "Bad scipt name: '${OPERATION}'."
		exit 1
esac

# Base64 Decode the certificate and store it in a file
CERTIFICATE_PATH=""
if [[ ! -z "$CERTIFICATE" ]]
then
	CERTIFICATE_PATH="/tmp/key.der"
	echo "Certificate received. Decoding with base64..."
	echo ${CERTIFICATE} | base64 --decode > ${CERTIFICATE_PATH}
fi

# Display the script parameters / variables
echo "SCRIPT: ${OPERATION}(${SCRIPT_PATH})"
echo "APP_PATH: ${APP_PATH}"
echo "DEVICE: ${DEVICE}"
echo "TYPE_CHECK_LEVEL: ${TYPE_CHECK_LEVEL}"
# echo "CERTIFICATE: ${CERTIFICATE}" - we do not want to log this
echo "CERTIFICATE_PATH: ${CERTIFICATE_PATH}"
echo "PACKAGE_NAME: ${PACKAGE_NAME}"

# Restore the HOME enviroment variable
export HOME=/root

# Entering the applicaiton folder
APP_PATH_REAL="$(realpath "${APP_PATH}")"
echo "Entering the application folder: '${APP_PATH_REAL}'..."
cd "${APP_PATH_REAL}"

# Run the script
CMD_OUT_FILE="/tmp/cmd.out.txt"
echo "********************************************************************************"
echo "**********************   Starting Script (${OPERATION})   **********************"
echo "********************************************************************************"
/bin/bash ${SCRIPT_PATH} --device=${DEVICE} --type-check-level=${TYPE_CHECK_LEVEL} --certificate-path=${CERTIFICATE_PATH} --package-name=${PACKAGE_NAME} | tee ${CMD_OUT_FILE}
result=$?
echo "********************************************************************************"
echo "*****************************   Script Completed  ******************************"
echo "********************************************************************************"
echo "Script exit code: $result"

# Grab the path of the generated package from the output of the script
printenv
PACKAGE_FULL_PATH=$(grep "Package path:" ${CMD_OUT_FILE} | cut -d ":" -f2 | xargs)

# Set output variables (if running in Github context)
if [[ $result -eq 0 ]];
then
	if [[ ! -z "$CI" ]]
	then
		echo "status=success" >> "$GITHUB_OUTPUT"
		echo "package_path=${PACKAGE_FULL_PATH}" >> "$GITHUB_OUTPUT"
	else
		echo "Success."
	fi
else
	if [[ ! -z "$CI" ]]
	then
		echo "status=failure" >> "$GITHUB_OUTPUT"
		echo "package_path=" >> "$GITHUB_OUTPUT"
	else
		echo "Failure!"
	fi
fi

exit "$result"
