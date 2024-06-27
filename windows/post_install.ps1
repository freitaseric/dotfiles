Write-Host "The post install script has been started!" -ForegroundColor DarkBlue

Write-Host "Installing Arch WSL" -ForegroundColor DarkBlue
winget.exe install "9MZNMNKSM73X"
arch.exe

Write-Host "Setting Arch WSL as the default distro and removing Ubuntu" -ForegroundColor DarkBlue
wsl.exe -s "Arch"
wsl.exe -t "Ubuntu"
wsl.exe --unregister "Ubuntu"

# Cleaning system
Write-Host "We are cleaning your system..." -ForegroundColor DarkBlue
$env:DotFiles_ProgramsToInstall = $null

if (Test-Path "$($PROFILE.CurrentUserCurrentHost)\Documents\.dotfiles") {
 Remove-Item -Path "$($PROFILE.CurrentUserCurrentHost)\Documents\.dotfiles"
}

Write-Host "Nice! The Windows setup was successfully doned!" -ForegroundColor Green
Write-Host "Now, you can to run the linux/bootstrap.sh in WSL to setup your linux." -ForegroundColor DarkBlue