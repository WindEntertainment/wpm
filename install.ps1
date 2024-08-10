Add-Type -AssemblyName "System.IO.Compression.FileSystem"

$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
$userRootDirectory = [System.Environment]::GetFolderPath('UserProfile')
$directoryToInstall = Join-Path -Path $userRootDirectory -ChildPath ".wpm"
$pathToDownload = Join-Path -Path $directoryToInstall -ChildPath "source.zip"

if (-not (Test-Path $directoryToInstall)) {
    New-Item -Path $directoryToInstall -ItemType Directory -Force
}

Write-Output "Downloading Wind Pacakge Manager from GitHub..."

$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/WindEntertainment/wpm/releases/latest"
$downloadUrl = $latestRelease.assets[0].browser_download_url

Write-Output "Downloading $filename from $downloadUrl..."

try {
  Invoke-WebRequest -Uri $downloadUrl -OutFile $pathToDownload
} catch {
  Write-Error "An unexpected error occurred while WebRequest: $_"
  return
}

Write-Output "Download complete: $filename"

Write-Output "Extracting files..."
try {
  [System.IO.Compression.ZipFile]::ExtractToDirectory($pathToDownload, $directoryToInstall)
  Write-Output "Extraction complete. Files are available in $directoryToInstall"
} catch [System.IO.IOException] {
  Write-Error $_
  Write-Warning "Make sure you remove the previous version of Wind Package Manager before installing the new one."
  return
} catch {
  Write-Error $_
  return
}

Write-Output "Adding to PATH..."

if (-not ($currentPath.Split(';') -contains $directoryToInstall)) {
    $newPath = "$currentPath;$directoryToInstall"

    try {
        [System.Environment]::SetEnvironmentVariable("PATH", $newPath, [System.EnvironmentVariableTarget]::User)

        Write-Output "Directory added to PATH for the current user."
    } catch {
        Write-Error $_
        return
    }
} else {
    Write-Output "Directory is already in the PATH for the current user."
}
