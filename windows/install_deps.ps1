function InstallProgram {
 param (
  [string]$Program
 )
 
 Write-Host "Installing $($Program)" -ForegroundColor DarkMagenta
 winget install $Program
}

$ProgramsToInstall = $Env:DotFiles_ProgramsToInstall

Write-Host

Write-Host "Preparing to install $($ProgramsToInstall.Length) dependencies." -ForegroundColor DarkCyan

foreach ($Program in $ProgramsToInstall) {
 InstallProgram -Program $Program
}

Write-Host "All $($ProgramsToInstall.Length) dependencies are installed!" -ForegroundColor Green