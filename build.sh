#!/usr/bin/env bash
set -euo pipefail

SDK_VERSION="1804"
TARGET_VERSION="2.2.0.29"
SDK_NAME="Jolla-$TARGET_VERSION-SailfishOS-Platform_SDK_Chroot-i486"
SDK_URL="http://releases.sailfishos.org/sdk/installers/$SDK_VERSION/$SDK_NAME.tar.bz2"

# Download the base image
echo "Downloading base image: $SDK_URL"
curl -s -O "$SDK_URL"
echo "Downloading base image: DONE"

echo "Extracting base image"
bzip2 -d "$SDK_NAME.tar.bz2"
echo "Extracting base image: DONE"

# Import it as a docker base image & build the full image
echo "Importing base image"
docker import "$SDK_NAME.tar" coderus/sailfishos-platform-sdk-base
echo "Importing base image: DONE"

echo "Building image"
docker build \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t sailfishos-platform-sdk .
echo "Building image: DONE"
