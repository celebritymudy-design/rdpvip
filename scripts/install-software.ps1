$ErrorActionPreference = 'Stop'

# These five applications are shared by every matrix job.
$apps = @(
    @{ Name='Google Chrome'; Package='googlechrome'; Paths=@('C:\Program Files\Google\Chrome\Application\chrome.exe','C:\Program Files (x86)\Google\Chrome\Application\chrome.exe') },
    @{ Name='7-Zip'; Package='7zip'; Paths=@('C:\Program Files\7-Zip\7z.exe') },
    @{ Name='Notepad++'; Package='notepadplusplus'; Paths=@('C:\Program Files\Notepad++\notepad++.exe') },
    @{ Name='Visual Studio Code'; Package='vscode'; Paths=@('C:\Program Files\Microsoft VS Code\Code.exe','C:\Users\runneradmin\AppData\Local\Programs\Microsoft VS Code\Code.exe') },
    @{ Name='Git'; Package='git'; Paths=@('C:\Program Files\Git\cmd\git.exe') }
)

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { throw 'Chocolatey is not available.' }
foreach ($app in $apps) {
    $installed = @($app.Paths | Where-Object { Test-Path $_ }).Count -gt 0
    if ($installed) {
        Write-Host "Already installed: $($app.Name) - skipping."
        continue
    }
    Write-Host "Installing: $($app.Name)"
    & choco install $app.Package --yes --no-progress --limit-output
    if ($LASTEXITCODE -notin @(0, 1641, 3010)) { throw "Failed: $($app.Name) (exit code $LASTEXITCODE)" }
    Write-Host "Package installation finished: $($app.Name)"
}
Write-Host 'All requested application installations checked.'
