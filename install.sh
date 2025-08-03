#!/bin/bash

set -e
set -euxo pipefail
LOGFILE=/tmp/install-debug.log
exec > >(tee "$LOGFILE") 2>&1

sudo apt update
sudo apt upgrade

#Installing system packages
packages=("i3" "lightdm" "feh" "picom" "dmenu" "ranger" "dunst" "vim" "syncthing" "ufw" "timeshift" "smartmontools" "focuswriter" "tlp" "polybar" "network-manager" "kitty" )

for package in "${packages[@]}"; do

	sudo apt install -y "$package"
	
done
echo "19"

mkdir -p /home/user/Applications/Bitwarden 
mkdir -p /home/user/Applications/Obsidian
echo "23"
#Brave Browser installation

sudo apt install curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

sudo apt update

sudo apt install brave-browser
echo "35"
#Bitwarden installation
curl -L -o "/home/user/Applications/Bitwarden/bitwarden.deb" https://github.com/bitwarden/clients/releases/download/desktop-v2025.7.0/Bitwarden-2025.7.0-amd64.deb
sudo apt install "/home/user/Applications/Bitwarden/bitwarden.deb"
#Obsidian installation
curl -L -o "/home/user/Applications/Obsidian/obsidian.deb" https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/obsidian_1.8.10_amd64.deb
sudo apt install "/home/user/Applications/Obsidian/obsidian.deb"

#hBlock installion(set-up after system config)
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.5.1/hblock' \
  && echo 'd010cb9e0f3c644e9df3bfb387f42f7dbbffbbd481fb50c32683bbe71f994451  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown 0:0 /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock

#change computer name !!!!!



#System configuration 


#UFW CONFIG
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow out 80 #HTTP/HTTPS
sudo ufw allow out 443 #HTTP/HTTPS
sudo ufw allow 21 #FTP
sudo ufw allow 25 #Email
sudo ufw allow 53 #DNS
ufw enable

#hblock
sudo curl https://raw.githubusercontent.com/najiun/Dotfiles/refs/heads/main/my-sources.list -o /home/user/my-sources.list
sudo hblock
sudo hblock --sources /home/user/my-sources.list
# add automatic source updates in the furture

#Timeshift
sudo timeshift --create --comments "Post-Installation Of system" --tags O
sudo timeshift --schedule-monthly 2
sudo timeshift --schedule-weekly 3
sudo timeshift --schedule-daily 5
sudo timeshift --schedule-hourly 0
sudo timehsift --schedule-boot 3
