# Constants
$BANNER = "Welcome to my public dotfiles for gamer and developer setup on Windows with WSL."

# Functions
function CheckIfSystemIsWindows {
  $OsName = Get-ComputerInfo | Select-Object -ExpandProperty OsName

  if ($OsName.ToLower().Contains("windows")) {
    return $true
  } else {
    return $false
  }
}

function Confirm-Prompt {
  param (
      [string]$Message,
      [int]$Default = 0
  )

  $choices = '&Yes', '&No'
  $decision = $Host.UI.PromptForChoice('Make your choice', $Message, $choices, $Default)

  if ($decision -eq 0) {
    return $true
  } else {
    return $false
  }
}

function Select-Prompt {
  param (
    [string]$Title,
    [string]$Question,
    [string[]]$Choices,
    [int]$DefaultChoice = 0,
    [switch]$UseFirstLetter
  )

  $choiceDescriptions = @()
  for ($i = 0; $i -lt $Choices.Length; $i++) {
    $key = if ($UseFirstLetter) { $Choices[$i][0] } else { $i }
    $choiceDescriptions += [System.Management.Automation.Host.ChoiceDescription]::new("&$key $($Choices[$i])", "Select $($Choices[$i])")
  }
  $decision = $Host.UI.PromptForChoice($Title, $Question, $choiceDescriptions, $DefaultChoice)

  return $decision
}

# Program
Write-Host $BANNER -ForegroundColor Cyan

Write-Host "Checking the system requirements..." -ForegroundColor DarkGreen
$IsWindows = $(CheckIfSystemIsWindows)

if ($IsWindows -eq $false) {
  Write-Host "We detected that you aren't using Windows!" -ForegroundColor Yellow
  Write-Host "This script is only for Windows, but you can to run the script located in linux/bootstrap.sh to apply my WSL setup in your system." -ForegroundColor Yellow

  Exit 0
}

# Windows Pre-Install
.\windows\pre_install.ps1

# Install dependencies (if necessary)
if (-not ($env:DotFiles_ProgramsToInstall.Length -eq 0)) {
  .\windows\install_deps.ps1
}

# Customizing dotfiles setup
Write-Host "Starting customization setup" -ForegroundColor Cyan

$OmpThemeFileSource = Select-Prompt -Title $null -Question "How you want to apply the OhMyPosh theme?" -Choices "Using Github Dist", "Using a local file"

if ($OmpThemeFileSource -eq 0) {
  $env:ZetaOmpThemePath = "https://gist.githubusercontent.com/freitaseric/6ab2412223ab3931753c4659c380c015/raw/52b8f8221d140a3bf6318113697b963d287acc2f/zeta-theme.omp.json"
  Write-Host "The OMP theme file has been setted to Github Gist URL." -ForegroundColor Green
} else {
  if (Test-Path "$env:USERPROFILE\Documents\.dotfiles") {
    Remove-Item "$env:USERPROFILE\Documents\.dotfiles" -Force -Recurse
  }
  
  git.exe clone --depth=1 https://github.com/freitaseric/dotfiles.git $env:USERPROFILE\Documents\.dotfiles

  if (-not (Test-Path "$env:USERPROFILE\Documents\OhMyPosh")) {
    New-Item -Path "$env:USERPROFILE\Documents\OhMyPosh" -ItemType Directory
  }

  Copy-Item -Path "$env:USERPROFILE\Documents\.dotfiles\assets\zeta-theme.omp.json" -Destination "$env:USERPROFILE\Documents\OhMyPosh\"

  $env:ZetaOmpThemePath = "$env:USERPROFILE\Documents\OhMyPosh\zeta-theme.omp.json"
  Write-Host "The OMP theme file has been setted to local file path." -ForegroundColor Green
}

Write-Host "Modifying your PowerShell profile" -ForegroundColor Cyan

if (-not (Test-Path $PROFILE.CurrentUserCurrentHost)) {
  New-Item -Path $PROFILE.CurrentUserCurrentHost -ItemType File
}

$OhMyPoshConfig = "oh-my-posh init pwsh --config $env:ZetaOmpThemePath | InvokeExpression"
$OhMyPoshConfig | Out-File -FilePath $PROFILE.CurrentUserCurrentHost

Write-Host "The OMP theme has been setted in your PowerShell profile." -ForegroundColor Green

# WSL Setup
Write-Host "Starting the WSL setup with Arch Linux" -ForegroundColor Cyan

wsl.exe --install -d "Ubuntu"

$PostInstallScriptContent = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/freitaseric/dotfiles/main/windows/post_install.ps1" | Select-Object -ExpandProperty Content
$PostInstallScriptBlock = [ScriptBlock]::Create($PostInstallScriptContent)

$TaskAction = New-ScheduledTaskAction -Execute { Invoke-Command -ScriptBlock $PostInstallScriptBlock }
$TaskTrigger = New-ScheduledTaskTrigger -Once -At Get-Date

$ConfirmRestart = Confirm-Prompt -Message "Do you want to restart your system to apply all configurations?"
if ($ConfirmRestart) {
  Register-ScheduledTask -TaskName "DotFilesRestartSystem" -Trigger $TaskTrigger -Action $TaskAction
} else {
  Write-Host "The WSL has been completed configurated, but you need to restart your system to continue the setup." -ForegroundColor Yellow
  Write-Host "You can to restart your system manually, then run the post install script located on this github repository https://github.com/freitaseric/dotfiles" -ForegroundColor Yellow
  Exit 0
}
