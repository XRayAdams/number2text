#!/bin/bash

echo "Creating deb and rpm files"

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

./set_app_versions.sh

flutter_to_debian 
mkdir -p dist
cp -r build/linux/x64/release/debian/* dist/

echo "DEB package created in dist/"
echo "Preparing RPM package"
# RPM build setup
RPM_BUILD_ROOT="$(pwd)/rpmbuild"

# App details from pubspec.yaml
APP_NAME=$(grep 'name:' pubspec.yaml | awk '{print $2}')
APP_VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
APP_BUILD=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)

# Create RPM build directories
mkdir -p "$RPM_BUILD_ROOT/BUILD"
mkdir -p "$RPM_BUILD_ROOT/RPMS"
mkdir -p "$RPM_BUILD_ROOT/SOURCES"
mkdir -p "$RPM_BUILD_ROOT/SPECS"
mkdir -p "$RPM_BUILD_ROOT/SRPMS"

cp number2text.spec "$RPM_BUILD_ROOT/SPECS/"

# Copy desktop and icon files
sed 's/Icon=app.rayadams.number2text/Icon=number2text/' debian/gui/app.rayadams.number2text.desktop > "$RPM_BUILD_ROOT/SOURCES/app.rayadams.number2text.desktop"
cp debian/gui/app.rayadams.number2text.png "$RPM_BUILD_ROOT/SOURCES/"

# Package the application files into a tarball
pushd build/linux/x64/release
tar -czvf "$RPM_BUILD_ROOT/SOURCES/$APP_NAME-$APP_VERSION.tar.gz" bundle
popd

# Build the RPM
rpmbuild -bb \
    --define "_topdir $RPM_BUILD_ROOT" \
    --define "_name $APP_NAME" \
    --define "_version $APP_VERSION" \
    --define "_release $APP_BUILD" \
    "$RPM_BUILD_ROOT/SPECS/number2text.spec"

# Move the RPM to the dist directory
mkdir -p dist
find "$RPM_BUILD_ROOT/RPMS" -name "*.rpm" -exec mv {} dist/ \;

# Clean up
rm -rf "$RPM_BUILD_ROOT"

echo "RPM package created in dist/"
