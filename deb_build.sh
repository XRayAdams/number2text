#!/bin/bash

# --- Configuration ---
PUBSPEC_FILE="pubspec.yaml"
DEBIAN_YAML_FILE="debian/debian.yaml"
DEBIAN_DESKTOP_FILE="debian/gui/app.rayadams.number2text.desktop"
# ---------------------


# Check if flutter_to_debian is installed
if ! command -v flutter_to_debian &> /dev/null
then
    echo "Error: flutter_to_debian is not installed."
    echo "Please install it by running the following command:"
    echo "dart pub global activate flutter_to_debian"
    exit 1
fi

flutter clean
flutter build linux --release

# Check if files exist
if [ ! -f "$PUBSPEC_FILE" ] || [ ! -f "$DEBIAN_YAML_FILE" ] || [ ! -f "$DEBIAN_DESKTOP_FILE" ]; then
    echo "Error: Make sure $PUBSPEC_FILE, $DEBIAN_YAML_FILE and $DEBIAN_DESKTOP_FILE exist."
    exit 1
fi

# Read version from pubspec.yaml (extracts the line with 'version:' and gets the value after the space)
APP_VERSION=$(grep 'version:' $PUBSPEC_FILE | cut -d ' ' -f 2)

if [ -z "$APP_VERSION" ]; then
    echo "Error: Could not read version from $PUBSPEC_FILE."
    exit 1
fi

echo "Version '$APP_VERSION' found in $PUBSPEC_FILE"

# Use sed to find and replace the Version line in debian.yaml and desktop file
# This command looks for the line starting with '  Version:' and replaces the entire line.
sed -i "s/^\(\s*Version:\s*\).*\$/\1$APP_VERSION/" "$DEBIAN_YAML_FILE"
sed -i "s/^\(\s*Version=\s*\).*\$/\1$APP_VERSION/" "$DEBIAN_DESKTOP_FILE"

echo "Successfully updated 'Version' in $DEBIAN_YAML_FILE and $DEBIAN_DESKTOP_FILE"


flutter_to_debian 
cp -r build/linux/x64/release/debian/ dist/
