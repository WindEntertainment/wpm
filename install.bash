#!/bin/bash

packageURL="https://github.com/WindEntertainment/wpm/releases/download/latest/source.zip"
directoryToInstall=$HOME/.wpm
pathToDownload=$directoryToInstall/source.zip

echo "Downloading Wind Pacakge Manager from GitHub..."
echo $packageURL

mkdir $HOME/.wpm

curl -L -o "$pathToDownload" "$packageURL"
if [ $? -ne 0 ]; then
    echo "An unexpected error occurred while download: $packageURL"
    exit 1
fi

echo "Download complete."

echo "Extracting files..."
unzip -o "${pathToDownload}" -d "${HOME}/.wpm/"
if [ $? -ne 0 ]; then
    echo "Failed to extract $ARCHIVE"
    exit 1
fi

echo "Extraction complete. Files are available in $directoryToInstall"

echo "Installing..."

chmod +x "${HOME}/.wpm/wpm"
sudo mv  "${HOME}/.wpm/wpm" "/usr/local/bin"

echo "Installed to /usr/local/bin"