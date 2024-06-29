# My Personal Dotfiles

This repo store my minimal dev setup for Windows with Arch WSL.

## Windows Setup

To easily install the complete setup, simply run the startup script in PowerShell. ([./bootstrap.ps1](./bootstrap.ps1))

```powershell
$ Invoke-Expression $(Invoke-WebRequest -Uri "https://raw.githubusercontent.com/freitaseric/dotfiles/main/bootstrap.ps1")
```

or install all manually

### Terminal (Shell)

1. Shell interpreter: [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4)
2. Theme framework: [Oh My Posh](https://ohmyposh.dev/)
3. Oh My Posh theme: [ZetaTheme](./assets/omp/zeta-theme.omp.json) or [In this Gist](https://gist.githubusercontent.com/freitaseric/6ab2412223ab3931753c4659c380c015/raw/203cb9baca810835fb199e6263a4647d82427810/zeta-theme.omp.json)

### Terminal (Emulator)

1. Application: [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701)
2. Configurations: [settings.json](./assets/windows-terminal/settings.json) or [In this Gist](https://gist.githubusercontent.com/freitaseric/1b9d8b532cedd5035005248b20ef339c/raw/83dfa44635b06703a9eb67f238146f10622e3563/settings.json)
3. Arch logo: [arch-logo.png](./assets/windows-terminal/arch-logo.png)

## Linux Setup

### Terminal (Shell)

1. Shell Interpreter: [Zsh](https://www.zsh.org)
2. Theme framework: [OhMyPosh](https://ohmyposh.dev/)
3. Oh My Posh theme: [ZetaTheme](./assets/omp/zeta-theme.omp.json) or [In this Gist](https://gist.githubusercontent.com/freitaseric/6ab2412223ab3931753c4659c380c015/raw/203cb9baca810835fb199e6263a4647d82427810/zeta-theme.omp.json)

### Editor/IDE

1. [Neovim v0.10.0](https://neovim.io)
2. Neovim Config: [AstroNvim](https://astronvim.com)

## License

This repo is [MIT licensed](./LICENSE).