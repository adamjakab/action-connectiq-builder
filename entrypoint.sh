#!/bin/bash

echo "Starting ConnectIQ Builder GitHub Action entrypoint script..."

# Retrieve the script parameters
OPERATION=${1}
APP_PATH=${2}
DEVICE=${3}
DEVICES=${4}
TYPE_CHECK_LEVEL=${5}
PACKAGE_NAME=${6}
VERBOSE=${7}

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

# Get the developer key from the environment variable, Base64 Decode it and store it in a file
CERTIFICATE_PATH=""
if [[ ! -z "${CONNECTIQ_DEVELOPER_KEY}" ]]
then
	echo "Developer key found in CONNECTIQ_DEVELOPER_KEY variable."
	CERTIFICATE_PATH="/tmp/key.der"
	echo "Decoding with base64..."
	echo ${CONNECTIQ_DEVELOPER_KEY} | base64 --decode > ${CERTIFICATE_PATH}	
else
	echo "No developer key was provided."
fi

# Display the script parameters / variables
echo "SCRIPT: ${OPERATION}(${SCRIPT_PATH})"
echo "APP_PATH: ${APP_PATH}"
echo "DEVICE: ${DEVICE}"
echo "DEVICES: ${DEVICES}"
echo "TYPE_CHECK_LEVEL: ${TYPE_CHECK_LEVEL}"
echo "CERTIFICATE_PATH: ${CERTIFICATE_PATH}"
echo "PACKAGE_NAME: ${PACKAGE_NAME}"
echo "VERBOSE: ${VERBOSE}"

# Restore the HOME enviroment variable
export HOME=/root

# Entering the applicaiton folder
echo "Entering the application folder: '${APP_PATH}'..."
cd "${APP_PATH}"

# Run the script
echo "********************************************************************************"
echo "**********************   Starting Script (${OPERATION})   **********************"
echo "********************************************************************************"
/bin/bash ${SCRIPT_PATH} --verbose=${VERBOSE} --device=${DEVICE} --devices=${DEVICES} --type-check-level=${TYPE_CHECK_LEVEL} --certificate-path=${CERTIFICATE_PATH} --package-name=${PACKAGE_NAME}
result=$?
echo "********************************************************************************"
echo "*****************************   Script Completed  ******************************"
echo "********************************************************************************"
echo "Script exit code: $result"


# Prepare the relative package path for output
# Note: GITHUB_WORKSPACE points to /github/workspace which is not usable after the process exits
PACKAGE_PATH=""
if [[ ${OPERATION} = "PACKAGE" ]]
then
	PACKAGE_PATH="bin/${PACKAGE_NAME}"
fi


# Set output variables (if running in Github context)
if [[ $result -eq 0 ]];
then
	if [[ ! -z "$CI" ]]
	then
		echo "status=success" >> "$GITHUB_OUTPUT"
		echo "package_path=${PACKAGE_PATH}" >> "$GITHUB_OUTPUT"
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
