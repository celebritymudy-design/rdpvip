$ErrorActionPreference = 'Stop'

# Edit just this array to customize all five runners.
$packages = @(
    'googlechrome',
    '7zip',
    'notepadplusplus',
    'vscode',
    'git'
)

$choco = Get-Command choco -ErrorAction SilentlyContinue
if (-not $choco) {
    throw 'Chocolatey is not installed on this runner. Choose a supported Windows image or configure a trusted package manager.'
}

choco --version
foreach ($package in $packages) {
    Write-Host "Installing $package ..."
    & choco install $package --yes --no-progress --limit-output
    if ($LASTEXITCODE -ne 0) {
        throw "Installation failed for $package (exit code $LASTEXITCODE)"
    }
}
Write-Host 'All requested packages installed successfully.'
