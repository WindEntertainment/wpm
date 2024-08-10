#!/bin/bash

directoryToInstall=$HOME/.wpm
pathToDownload=$directoryToInstall/source.zip

echo "Downloading Wind Pacakge Manager from GitHub..."

mkdir "$HOME"/.wpm

latest_release=$(curl -s "https://api.github.com/repos/WindEntertainment/wpm/releases/latest")
download_url=$(echo "$latest_release" | jq -r '.assets[0].browser_download_url')
filename=$(basename "$download_url")

echo "Downloading $filename from $download_url..."
curl -L -o "$pathToDownload" "$download_url"
if [ $? -ne 0 ]; then
  echo "An unexpected error occurred while downloading"
  exit 1
fi

echo "Download complete: $filename"

echo "Extracting files..."
unzip -o "${pathToDownload}" -d "${HOME}/.wpm/"
if [ $? -ne 0 ]; then
  echo "Failed to extract $pathToDownload"
  exit 1
fi

echo "Extraction complete. Files are available in $directoryToInstall"

echo "Installing..."

chmod +x "${HOME}/.wpm/wpm"
sudo mv  "${HOME}/.wpm/wpm" "/usr/local/bin"

echo "Installed to /usr/local/bin"
