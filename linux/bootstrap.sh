fuchsia="\033[38;5;13m"
yellow="\033[38;5;11m"
deeppink="\033[38;5;125m"
aqua="\033[38;5;14m"
paru="${green}paru$reset"
reset="\033[0m"

echo -e "${fuchsia}Welcome to my Linux setup! This script was designed to be run on WSL, so some things may look strange on native Linux."
if type -n pacman &>/dev/null; then
 echo -e "${yellow}If you are running the script on a non-Arch based system it will not be able to install the necessary programs and you will have to do this manually."
fi

pre_install="./linux/pre_install.sh"
if [ -f "$pre_install" ]; then
 source "$pre_install"
fi

echo -e "${aqua}Running install and setup tasks...$reset"

if ! type -n oh-my-posh &>/dev/null; then
 echo -e "${aqua}Installing ${deeppink}oh-my-posh ${aqua}using $paru"
 paru -S oh-my-posh-bin
fi

if ! type -n zsh &>/dev/null; then
 echo -e "${aqua}Installing ${deeppink}zsh ${aqua} using $paru"
 paru -S zsh
fi

echo -e "${aqua}Changing the default shell to Zsh$reset"
chsh -s /usr/bin/zsh

echo -e "${aqua}Applying my OMP theme on Zsh$reset"
zeta_omp_theme="https://gist.githubusercontent.com/freitaseric/6ab2412223ab3931753c4659c380c015/raw/52b8f8221d140a3bf6318113697b963d287acc2f/zeta-theme.omp.json"
omp_config="eval \"$(oh-my-posh init zsh --config ${$zeta_omp_theme})\""

$omp_config >> "$HOME/.zshrc"

echo -e "${green}Nice! Your system has been successfully configured!$reset"