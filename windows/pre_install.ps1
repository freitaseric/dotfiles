$ProgramsToInstall = @()

Write-Host

Write-Host "Pre-Install script initialized" -ForegroundColor Blue
Write-Host "Checking for uninstalled dependencies..." -ForegroundColor Blue

if (-not (Get-Command -Name "winget" -ErrorAction SilentlyContinue)) {
 Write-Host "WinGet is not installed! We will install manually for you." -ForegroundColor Red
 iex ((New-Object System.Net.WebClient).DownloadString('https://aka.ms/winget-cli'))
}

if (-not (Get-Command -Name "oh-my-posh" -ErrorAction SilentlyContinue)) {
 Write-Host "OhMyPosh is not installed" -ForegroundColor DarkMagenta
 $ProgramsToInstall += "JanDeDobbeleer.OhMyPosh"
}

if (-not (Get-Command -Name "wsl" -ErrorAction SilentlyContinue)) {
 Write-Host "WSL is not installed" -ForegroundColor DarkMagenta
 $ProgramsToInstall += "Microsoft.WSL"
}

if (-not (Get-Command -name "git" -ErrorAction SilentlyContinue)) {
 Write-Host "Git is not installed" -ForegroundColor DarkMagenta
 $ProgramsToInstall += "Git.Git"
}

Write-Host "All dependencies checked!" -ForegroundColor Blue
if ($ProgramsToInstall.Length -eq 0) {
 Write-Host "No missing dependencies." -ForegroundColor Green
} else {
 Write-Host "$($ProgramsToInstall.Length) dependencies to install!"
}

$Env:DotFiles_ProgramsToInstall = $ProgramsToInstall