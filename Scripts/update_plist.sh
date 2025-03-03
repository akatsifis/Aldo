#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status
set -x  # Print commands and their arguments as they are executed

# Path to the Info.plist file
PLIST_PATH="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

# Debugging: Print the resolved path
echo "Resolved Info.plist path: $PLIST_PATH"

# Check if PLIST_PATH exists
if [ ! -f "$PLIST_PATH" ]; then
  echo "Error: Info.plist file not found at $PLIST_PATH"
  exit 1
fi

# Add NSHealthUpdateUsageDescription if it doesn't exist
/usr/libexec/PlistBuddy -c "Print :NSHealthUpdateUsageDescription" "$PLIST_PATH" || \
/usr/libexec/PlistBuddy -c "Add :NSHealthUpdateUsageDescription string 'This app requires access to your health data to track and analyze your workouts and heart rate during golf sessions.'" "$PLIST_PATH"

# Add NSHealthShareUsageDescription if it doesn't exist
/usr/libexec/PlistBuddy -c "Print :NSHealthShareUsageDescription" "$PLIST_PATH" || \
/usr/libexec/PlistBuddy -c "Add :NSHealthShareUsageDescription string 'This app requires access to your health data to display and analyze your workout history and other health metrics.'" "$PLIST_PATH"

echo "Updated Info.plist at $PLIST_PATH"
