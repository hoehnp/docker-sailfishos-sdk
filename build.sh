#!/usr/bin/env bash
set -euo pipefail

SDK_VERSION="1807"
TARGET_VERSION="2.2.1.18"
SDK_NAME="Sailfish_OS-$TARGET_VERSION-Platform_SDK_Chroot-i486.tar.bz2"
SDK_URL="http://releases.sailfishos.org/sdk/installers/$SDK_VERSION/$SDK_NAME"

# Import it as a docker base image & build the full image
echo "Importing base image"
docker import "$SDK_URL" "coderus/sailfishos-platform-sdk-base:$TARGET_VERSION"
echo "Importing base image: DONE"

echo "Building image"
docker build \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "coderus/sailfishos-platform-sdk:$TARGET_VERSION" .
echo "Building image: DONE"
