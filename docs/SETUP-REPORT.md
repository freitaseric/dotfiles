# Relatório de configuração — 2026-09-12

## Estado encontrado

- Dell Inspiron 3442, Intel Core i5-4210U, 7,7 GiB de RAM.
- Arch Linux x86_64, kernel `7.2.4-arch1-2`, Hyprland `0.56.2`.
- Intel HD Graphics 4400 em `00:02.0` com `i915`, usada pelo monitor interno
  `eDP-1` em 1366x768, escala 1. GeForce 820M em `08:00.0` com `nouveau`.
- SSD Kingston SA400S37 de 480 GB. Raiz Btrfs em `@`, `/home` em `@home`,
  `/var/log` em `@log` e cache do pacman em `@pkg`; compressão zstd e
  `discard=async`. Cerca de 440 GB livres.
- zram de 3,8 GiB com zstd; nenhuma swap em disco.
- `pt_BR.UTF-8`, `America/Boa_Vista`, NTP sincronizado, console `br-abnt2`, X11
  `br`/`abnt2`; Fish já era o shell cadastrado.
- greetd/tuigreet era o único display manager e iniciava `start-hyprland`.
- NetworkManager, PipeWire, pipewire-pulse, WirePlumber, portais GTK/Hyprland,
  gvfs/udisks2, Bluetooth e os componentes principais do desktop estavam ativos.
- Bluetooth QCA9565 real foi detectado, desbloqueado, ligado e oferecendo perfis
  de áudio via BlueZ.
- Firefox já executava nativamente em Wayland (`xwayland=false`,
  `MOZ_ENABLE_WAYLAND=1`).
- Inter, JetBrains Mono, Symbols Nerd Font Mono, Noto Sans e Noto Emoji já
  resolviam corretamente via fontconfig. Papirus já estava com pastas teal.
- Nenhum serviço de rede estava escutando; apenas DHCPv6 client UDP aparecia em
  `ss -tulpn`. SSH server não estava habilitado.
- Boot sem unidades falhas, em cerca de 13,3 s. O journal mostrou avisos antigos
  do firmware/nouveau, falta de RTKit, plugins opcionais do Tumbler e um crash do
  hyprpaper durante a transição entre sessões; a sessão corrente se recuperou.
- `~/dotfiles` existia vazio, em branch `main`, sem commits e sem histórico a
  preservar.

## Alterações realizadas

- Criado backup inicial completo das configurações selecionadas em
  `~/.local/state/dotfiles-backups/2026-09-12T1535/`.
- Migradas somente configurações deliberadamente selecionadas para este repo;
  Firefox, dconf, caches, histórico e credenciais não foram incluídos.
- Implantação por symlinks explícitos com backup automático e idempotência em
  `bootstrap.sh`.
- `hyprpaper.service` foi habilitado para `graphical-session.target`; o autostart
  existente continua exportando o ambiente Wayland antes de reiniciar a unidade.
- Powermenu passou a preferir `hyprshutdown` quando disponível e usar exatamente
  `hyprctl dispatch 'hl.dsp.exit()'` como fallback. O atalho de sessão abre o menu.
- Corrigidas duas chaves digitadas incorretamente na Waybar: `max-length` e
  `format-alt`; o layout e a identidade visual foram preservados.
- Fish ganhou inicialização condicional do `fnm`, sem adicionar outro gerenciador
  de versões.

## Pacotes e serviços

Foi executado `pacman -Syu --needed`; o sistema já estava atualizado. Foram
instalados diretamente:

- desenvolvimento: `github-cli`, `zip`, `fnm`, `php`, `php-sqlite`,
  `php-pgsql`, `composer` e `postgresql-libs`;
- editor: `code` oficial e sua dependência `electron42`;
- desktop: `hyprpolkitagent`, `rtkit`, `ffmpegthumbnailer`, `poppler-glib` e
  `libgsf`;
- diagnóstico/manutenção: `libva-utils`, `usbutils`, `pacman-contrib`, `snapper`
  e `snap-pac`.

As dependências foram resolvidas pelo pacman; nenhum servidor de banco, Redis,
Docker ou SSH server foi instalado/habilitado. Nenhum pacote novo do AUR foi
necessário. `bibata-cursor-theme` e `papirus-folders-git`, que já existiam, foram
preservados.

Serviços/timers habilitados nesta configuração:

- usuário: `hyprpaper.service`, `hypridle.service` e
  `hyprpolkitagent.service` em `graphical-session.target`;
- sistema: `paccache.timer` (limpeza semanal conservadora, padrão de três
  versões) e `snapper-cleanup.timer`;
- já existentes e preservados: `greetd`, `NetworkManager`, `bluetooth`,
  PipeWire/WirePlumber e seus sockets/unidades.

O RTKit permanece por ativação D-Bus; não foi criado um daemon duplicado. Após
reiniciar PipeWire/WirePlumber, `rtkit-daemon.service` foi ativado normalmente.

## Decisões

- `fnm` foi escolhido em vez de mise por ser oficial, focado em Node e muito
  menor nesta máquina; Node do sistema não será instalado em paralelo.
- `code` oficial do Arch foi escolhido; não será instalada a variante proprietária
  do AUR. O teste abriu em Wayland nativo e usou `/dev/dri/renderD129`, o render
  node Intel.
- O driver Intel legado `libva-intel-driver` já existente foi preservado para
  Haswell; nenhuma configuração experimental do Firefox foi aplicada.
- `fstrim.timer` não é habilitado porque todas as montagens Btrfs já usam
  `discard=async`; manter ambos seria redundante.
- Nenhum firewall foi ativado, pois não havia listener servidor e regras poderiam
  interferir no desenvolvimento LAN/móvel futuro.
- Nenhum pacote foi removido. O órfão `go` e `yay-debug` foram apenas registrados,
  não removidos.

## Arquivos modificados/criados

- Links em `~/.config`: Hyprland, Hyprpaper, Hyprlock, Hypridle, Waybar,
  Fuzzel, Foot, Fish, Starship, SwayNC, GTK 3/4, xsettingsd e flags do Code.
- Link `~/.local/bin/powermenu`.
- `/etc/php/conf.d/20-workstation.ini`, habilitando somente `intl`,
  `pdo_sqlite`, `sqlite3`, `pdo_pgsql` e `pgsql`.
- Configuração Snapper `root` criada para `/`, com timeline desativada,
  `NUMBER_LIMIT=10` e `NUMBER_LIMIT_IMPORTANT=5`.
- Estrutura deste repositório, `README.md`, `bootstrap.sh`, listas de pacotes e
  este relatório.

O greetd já correspondia ao arquivo versionado e não precisou ser alterado.

## Deliberadamente não alterado

- Partições, filesystem, bootloader, kernel, firmware, criptografia e parâmetros
  de boot.
- Drivers e prioridade das GPUs; Intel permanece principal e NVIDIA/nouveau
  secundária.
- Aparência aprovada do Hyprland, Fuzzel, Foot, Starship e SwayNC.
- NetworkManager-wait-online e demais serviços existentes sem evidência de dano.
- Login no GitHub, chaves SSH e dados pessoais.

## Validação e ações manuais

Validações concluídas com sucesso:

- `hyprctl configerrors` vazio; eDP-1 em 1366x768, escala 1.
- Foot aceitou a configuração; Fish iniciou sem erro; Starship renderizou o
  prompt compacto; Waybar iniciou e configurou a barra; Fuzzel abriu.
- SwayNC recebeu notificação e a central abriu/fechou; configuração JSON válida.
- Hyprpaper foi reiniciado pelo systemd, encontrou um output e permaneceu com
  exatamente uma instância; Hypridle ficou ativo com quatro listeners.
- greetd é o único display manager. NetworkManager e Bluetooth estão ativos.
- PipeWire, pipewire-pulse e WirePlumber ativos; sink e microfone ALSA detectados.
- Portais GTK/Hyprland ativos; interfaces FileChooser e ScreenCast disponíveis e
  ScreenCast conectado ao PipeWire sem novos warnings após o restart.
- Cópia/cola e armazenamento no cliphist testados; screenshot PNG real em
  1366x768 criado; todas as ramificações do powermenu testadas com comandos
  simulados para não desligar a máquina.
- GVFS UDisks2 e monitor MTP ativos; Thunar, Tumbler e suporte a arquivos
  instalados.
- Firefox confirmado como Wayland nativo, com cursor Bibata e acesso ao render
  node Intel. VA-API Intel i965 expôs perfis de decodificação Haswell.
- Code - OSS abriu nativamente em Wayland e selecionou o render node Intel.
- Node `v24.21.0`, npm `11.19.0`, Corepack `0.36.0` e pnpm `12.4.1` no Fish.
- PHP `8.5.10`, Composer `2.10.3`, SQLite CLI e psql `18.6`; todas as extensões
  solicitadas carregadas. O diagnose do Composer passou, exceto pelas chaves de
  `self-update`, irrelevantes ao pacote mantido pelo pacman.
- Snapper confirmou os subvolumes `@`, `@home`, `@log`, `@pkg` e criou `.snapshots`
  sob `@`. O primeiro snapshot `snap-pac` existe; transações futuras terão hooks
  pre/post. Não houve integração com bootloader.
- Nenhuma unidade systemd falhou após a configuração.

Ações manuais deliberadamente pendentes:

- Fazer logout/login uma vez e confirmar visualmente o wallpaper no login frio.
  A sequência systemd e um restart controlado foram validados, mas encerrar a
  sessão interromperia este trabalho.
- Acionar `Super+Ctrl+L` e autenticar o Hyprlock. A configuração está válida, mas
  autenticação PAM não deve ser automatizada.
- Conectar fisicamente um telefone Android para validar o dispositivo específico;
  o monitor MTP está ativo, porém nenhum telefone estava conectado.
- Executar `gh auth login` quando desejar. Nenhuma conta foi autenticada.
- Fazer o primeiro commit Git deste repositório após revisar o conteúdo.
