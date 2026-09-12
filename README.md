# Workstation Arch Linux — Dell Inspiron 3442

Configuração pessoal leve para Hyprland, preservando a Intel HD 4400 como GPU
principal e a GeForce 820M com `nouveau` como secundária. Não há configuração de
bootloader, kernel, partições, firmware ou driver NVIDIA proprietário neste repo.

## Instalação

Em uma instalação Arch já funcional, clone este repositório no caminho
`~/dotfiles`. Revise as listas em `packages/` e então execute:

```sh
./bootstrap.sh          # somente links; cria backup de qualquer destino existente
./bootstrap.sh --all    # pacotes, links, Node LTS e configuração segura do sistema
```

As opções podem ser usadas separadamente: `--packages`, `--node` e `--system`.
O script é idempotente. Arquivos existentes nunca são apagados silenciosamente:
são movidos para `~/.local/state/dotfiles-backups/<data>/` antes da criação dos
symlinks. Operações de sistema usam `sudo` e não alteram boot ou discos.

Pacotes oficiais ficam em `packages/pacman.txt`; os dois itens sem equivalente
oficial ficam em `packages/aur.txt`. O Node é administrado exclusivamente pelo
`fnm`, com LTS, Corepack e pnpm — não é instalado um Node global pelo pacman.

## Configurações e serviços

- Login: `greetd` + `tuigreet`, iniciando `start-hyprland`.
- Sessão: Hyprland Lua, Waybar, Fuzzel, Foot, SwayNC e clipboard com cliphist.
- Usuário: `hypridle.service`, `hyprpaper.service`, PipeWire e WirePlumber.
- Sistema: NetworkManager, Bluetooth, greetd, limpeza conservadora do cache por
  `paccache.timer` e snapshots Snapper de `/` antes/depois do pacman.
- `/home`, `/var/log` e o cache do pacman são subvolumes separados e não entram
  nos snapshots de `/`. Não existe integração automática com bootloader.

O SSD já usa `discard=async`; por isso o bootstrap não habilita também
`fstrim.timer`. PipeWire e portais usam ativação systemd/D-Bus existente.

## Atalhos principais

- `Super+H/J/K/L`: foco; com `Shift`, move a janela.
- `Super+1..0`: workspace; com `Shift`, move a janela.
- `Super+Return`, `Super+Space`, `Super+E`, `Super+B`: terminal, launcher,
  arquivos e Firefox.
- `Super+Q`, `Super+F`, `Super+V`: fechar, fullscreen e floating/tiled.
- `Super+N`: central de notificações.
- `Super+Shift+V`: histórico do clipboard.
- `Super+Ctrl+L`: bloquear.
- `Super+Ctrl+Shift+Q`: menu de sessão/energia.
- `Print`, `Super+Print`, `Shift+Print`: screenshot anotado, clipboard e arquivo.

## Restauração e troubleshooting

- Restaure um arquivo copiando-o do backup em
  `~/.local/state/dotfiles-backups/` e removendo antes o symlink correspondente.
- Hyprland: `hyprctl configerrors`.
- Serviços: `systemctl --user status hyprpaper hypridle` e
  `systemctl status greetd NetworkManager bluetooth`.
- Áudio: `wpctl status`; portais: `systemctl --user status xdg-desktop-portal`.
- Wallpaper: confirme `WAYLAND_DISPLAY` em `systemctl --user show-environment`.
- GitHub: execute `gh auth login` manualmente; o bootstrap nunca autentica contas.
- Code: `~/.config/code-flags.conf` usa a seleção Wayland automática suportada
  pelo Electron empacotado pelo Arch.
- Snapshots: `sudo snapper -c root list`. Eles não aparecem no menu de boot.

Veja `docs/SETUP-REPORT.md` para a auditoria e as decisões desta máquina.
