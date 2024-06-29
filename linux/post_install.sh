skyblue="\033[38;5;111m"
reset="\033[0m"

echo -e "${skyblue}Running post-install tasks...$reset"

tmp_folder_path="/tmp/freitaseric-dotfiles/"
rm -rf $tmp_folder_path

echo -e "${skyblue}All post-install tasks are doned!$reset"