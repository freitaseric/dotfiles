green="\033[38;5;2m"
blue="\033[38;5;26m"
yellow="\033[38;5;11m"
deeppink="\033[38;5;125m"
reset="\033[0m"

pacman="${green}pacman$reset"

echo -e "${blue}Running pre-install tasks...$reset"

tmp_folder_path="/tmp/freitaseric-dotfiles/"
mkdir -p $tmp_folder_path

echo -e "${blue}Updating your system using $pacman"
# Skip this during tests
# sudo pacman -Syu

echo -e "${blue}Installing ${deeppink}base-devel ${blue}and ${deeppink}git ${blue}using $pacman"
sudo pacman -S --needed base-devel git

if ! type -n cargo &>/dev/null; then
 echo -e "${blue}Installing ${deeppink}rust ${blue}using $pacman"
 sudo pacman -S rust
fi

if ! type -n paru &>/dev/null; then
 echo -e "${blue}Installing ${deeppink}paru ${blue}using ${green}git$reset"
 git clone https://aur.archlinux.org/paru.git "$tmp_folder_path/paru"
 cd "$tmp_folder_path/paru"
 makepkg -si
fi

echo -e "${blue}All pre-install tasks are doned!$reset"