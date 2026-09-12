#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
backup_stamp=$(date +%Y%m%d-%H%M%S)
backup_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-backups/$backup_stamp"

usage() {
    printf '%s\n' \
        "Uso: ./bootstrap.sh [--packages] [--node] [--system] [--all]" \
        "Sem opções: instala os links das configurações do usuário." \
        "--packages  instala pacotes oficiais/AUR (exige sudo)" \
        "--node      instala Node LTS e ativa Corepack/pnpm via fnm" \
        "--system    configura greetd, serviços e Snapper seguro (exige sudo)" \
        "--all       executa todas as etapas"
}

backup_target() {
    local target=$1 relative
    if [[ -L $target || -e $target ]]; then
        relative=${target#"$HOME"/}
        mkdir -p "$backup_dir/$(dirname -- "$relative")"
        mv -- "$target" "$backup_dir/$relative"
        printf 'Backup: %s -> %s\n' "$target" "$backup_dir/$relative"
    fi
}

link_one() {
    local source=$1 target=$2 current=''
    mkdir -p "$(dirname -- "$target")"
    if [[ -L $target ]]; then
        current=$(readlink -f -- "$target" 2>/dev/null || true)
        [[ $current == "$(readlink -f -- "$source")" ]] && return 0
    fi
    backup_target "$target"
    ln -s -- "$source" "$target"
    printf 'Link: %s -> %s\n' "$target" "$source"
}

deploy_user() {
    link_one "$repo_dir/hypr/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"
    link_one "$repo_dir/hyprpaper/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
    link_one "$repo_dir/hyprlock/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
    link_one "$repo_dir/hypridle/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
    link_one "$repo_dir/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
    link_one "$repo_dir/waybar/style.css" "$HOME/.config/waybar/style.css"
    link_one "$repo_dir/fuzzel/fuzzel.ini" "$HOME/.config/fuzzel/fuzzel.ini"
    link_one "$repo_dir/foot/foot.ini" "$HOME/.config/foot/foot.ini"
    link_one "$repo_dir/fish/config.fish" "$HOME/.config/fish/config.fish"
    link_one "$repo_dir/starship/starship.toml" "$HOME/.config/starship.toml"
    link_one "$repo_dir/swaync/config.json" "$HOME/.config/swaync/config.json"
    link_one "$repo_dir/swaync/style.css" "$HOME/.config/swaync/style.css"
    link_one "$repo_dir/scripts/powermenu" "$HOME/.local/bin/powermenu"
    link_one "$repo_dir/gtk/settings-gtk3.ini" "$HOME/.config/gtk-3.0/settings.ini"
    link_one "$repo_dir/gtk/settings-gtk4.ini" "$HOME/.config/gtk-4.0/settings.ini"
    link_one "$repo_dir/gtk/xsettingsd.conf" "$HOME/.config/xsettingsd/xsettingsd.conf"
    link_one "$repo_dir/code/code-flags.conf" "$HOME/.config/code-flags.conf"
    local unit
    for unit in hypridle.service hyprpaper.service hyprpolkitagent.service; do
        systemctl --user cat "$unit" >/dev/null 2>&1 && systemctl --user enable "$unit"
    done
}

install_packages() {
    local -a official aur
    mapfile -t official < <(sed -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' "$repo_dir/packages/pacman.txt" | grep -v '^snap-pac$')
    sudo pacman -Syu --needed -- "${official[@]}"
    if command -v yay >/dev/null 2>&1; then
        mapfile -t aur < <(sed -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' "$repo_dir/packages/aur.txt")
        ((${#aur[@]} == 0)) || yay -S --needed -- "${aur[@]}"
    else
        printf 'Aviso: yay ausente; pacotes AUR não foram instalados.\n' >&2
    fi
}

setup_node() {
    command -v fnm >/dev/null 2>&1 || { printf 'Instale fnm primeiro com --packages.\n' >&2; return 1; }
    eval "$(fnm env --shell bash)"
    fnm install --lts
    fnm default lts-latest
    fnm exec --using=lts-latest npm install --global corepack@latest
    fnm exec --using=lts-latest corepack enable
    fnm exec --using=lts-latest corepack install --global pnpm@latest
}

setup_system() {
    local root_fs root_source home_source
    sudo install -d -m 0755 /etc/greetd
    if ! sudo cmp -s "$repo_dir/greetd/config.toml" /etc/greetd/config.toml; then
        sudo cp -a /etc/greetd/config.toml "/etc/greetd/config.toml.backup-$backup_stamp" 2>/dev/null || true
        sudo install -m 0644 "$repo_dir/greetd/config.toml" /etc/greetd/config.toml
    fi
    sudo systemctl enable NetworkManager.service bluetooth.service greetd.service
    sudo systemctl enable --now paccache.timer
    sudo install -d -m 0755 /etc/php/conf.d
    if ! sudo cmp -s "$repo_dir/php/20-workstation.ini" /etc/php/conf.d/20-workstation.ini; then
        sudo cp -a /etc/php/conf.d/20-workstation.ini "/etc/php/conf.d/20-workstation.ini.backup-$backup_stamp" 2>/dev/null || true
        sudo install -m 0644 "$repo_dir/php/20-workstation.ini" /etc/php/conf.d/20-workstation.ini
    fi

    root_fs=$(findmnt -n -o FSTYPE /)
    root_source=$(findmnt -n -o SOURCE /)
    home_source=$(findmnt -n -o SOURCE /home)
    if [[ $root_fs == btrfs && $root_source == *'[/@]' && $home_source == *'[/@home]' ]]; then
        if [[ ! -e /etc/snapper/configs/root ]]; then
            sudo snapper -c root create-config /
        fi
        if ! sudo grep -qx 'TIMELINE_CREATE="no"' /etc/snapper/configs/root \
            || ! sudo grep -qx 'NUMBER_LIMIT="10"' /etc/snapper/configs/root \
            || ! sudo grep -qx 'NUMBER_LIMIT_IMPORTANT="5"' /etc/snapper/configs/root; then
            sudo cp -a /etc/snapper/configs/root "/etc/snapper/configs/root.backup-$backup_stamp"
            sudo sed -i \
                -e 's/^TIMELINE_CREATE=.*/TIMELINE_CREATE="no"/' \
                -e 's/^NUMBER_LIMIT=.*/NUMBER_LIMIT="10"/' \
                -e 's/^NUMBER_LIMIT_IMPORTANT=.*/NUMBER_LIMIT_IMPORTANT="5"/' \
                /etc/snapper/configs/root
        fi
        sudo pacman -S --needed -- snap-pac
        sudo systemctl enable --now snapper-cleanup.timer
    else
        printf 'Snapper ignorado: layout Btrfs @/@home esperado não foi confirmado.\n' >&2
    fi
}

do_packages=false do_node=false do_system=false
if (($# == 0)); then
    deploy_user
    exit 0
fi
for arg in "$@"; do
    case $arg in
        --packages) do_packages=true ;;
        --node) do_node=true ;;
        --system) do_system=true ;;
        --all) do_packages=true; do_node=true; do_system=true ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

$do_packages && install_packages
deploy_user
$do_node && setup_node
$do_system && setup_system
