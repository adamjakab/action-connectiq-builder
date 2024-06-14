#!/bin/bash

echo "Starting entrypoint script..."
which echo



#fail if one of the commands fails
#set -e

#retrieve parameters
APP_PATH=$1
DEVICE_ID=$2
CERTIFICATE_PATH=$3

function loginfo {
	if [[ -n $1 ]]
	then
		message="$1"
		/bin/echo "::debug::$message"
	else
		while read -r message
		do
			loginfo "$message"
		done
	fi
}

# Override the HOME enviroment variable
# When executing a Docker Action, GitHub overrides the HOME variable 
# in the command used to run the Docker (it is set to the home of the runner user)
# the HOME must be restored to the standard home of the root user because 
# ConnectIQ depends on it (the devices files are stored in the home folder of the root user)
export HOME=/root

# Entering folder when the app is stored relatively to the GitHub workspace
if [[ -n $1 ]]
then
	echo "Entering folder $APP_PATH..."
	cd "$APP_PATH"
	echo "Now in folder $(pwd)"
fi

# Run tests
loginfo "Running tests on device [$DEVICE_ID] with certificate [$CERTIFICATE_PATH]..."

/scripts/test.sh "$DEVICE_ID" "$CERTIFICATE_PATH" | loginfo

result="${PIPESTATUS[0]}"
loginfo "Result code $result"

#set output variable
if [[ $result -eq 0 ]];
then
	echo "status=success" >> "$GITHUB_OUTPUT"
else
	echo "status=failure" >> "$GITHUB_OUTPUT"
fi

exit "$result"
