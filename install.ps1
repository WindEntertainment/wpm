Add-Type -AssemblyName "System.IO.Compression.FileSystem"

$packageURL = "https://github.com/WindEntertainment/wpm/releases/download/latest/source.zip"
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
$userRootDirectory = [System.Environment]::GetFolderPath('UserProfile')
$directoryToInstall = Join-Path -Path $userRootDirectory -ChildPath ".wpm"
$directoryToDownload = Join-Path -Path $directoryToInstall -ChildPath "source.zip"

if (-not (Test-Path $directoryToInstall)) {
    New-Item -Path $directoryToInstall -ItemType Directory -Force
}

Write-Output "Downloading Wind Pacakge Manager $Version from GitHub..."
Write-Output $packageURL

try {
    Invoke-WebRequest -Uri $packageURL -OutFile $directoryToDownload
} catch {
    Write-Error "An unexpected error occurred in WebRequest: $_"
    return
}

if (-not (Test-Path $directoryToDownload)) {
    Write-Error  "Failed to download ZIP file."
    return
} 

Write-Output "Download complete."

Write-Output "Extracting files..."
try {
    [System.IO.Compression.ZipFile]::ExtractToDirectory($directoryToDownload, $directoryToInstall)

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