#!/bin/bash

set -e

sudo apt update
sudo apt upgrade

#Installing system packages
packages=("i3" "lightdm" "feh" "picom" "dmenu" "ranger" "dunst" "vim" "syncthing" "ufw" "timeshift" "smartmontools" "focuswriter" "tlp" "polybar" "nmtui" "nmcli" "touch" "kitty" )

for package in "${packages[@]}"; do

	sudo apt install -y "$package"
	
done

mkdir -p "$HOME/Applications/Bitwarden" "$HOME/Applications/Obsidian"

#Brave Browser installation

sudo apt install curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

sudo apt update

sudo apt install brave-browser

#Bitwarden installation

curl https://bitwarden.com/download/?app=desktop&platform=linux&variant=appimage -o /home/user/Applications/Bitwarden/bitwarden.Appimage
chmod 755 "$HOME/Applications/Bitwarden/bitwarden.Appimage"
sudo curl blob:https://github.com/4982141e-3f78-4694-97e0-464dcfea6612 -o /home/user/Applications/Bitwarden/logo.png
touch /home/user/.local/share/applications/bitwarden.desktop
cat > /home/user/.local/share/applications/bitwarden.desktop << EOF
[Desktop Entry]
Name:Bitwarden
Exec:/home/user/Applications/Bitwarden/bitwarden.Appimage
Logo:/home/user/Applications/Bitwarden/logo.png
Type:Application
EOF

sudo update-desktop-database


#Obsidian installation
sudo curl https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/Obsidian-1.8.10.AppImage -o /home/user/Applications/Obsidian/obsidian.Appimage
chmod 755 "$HOME/Applications/Obsidian/obsidian.Appimage"
sudo curl https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/2023_Obsidian_logo.svg/250px-2023_Obsidian_logo.svg.png -o /home/user/Applications/Obsidian/logo.png
touch /home/user/.local/share/applications/obsidian.desktop
cat > /home/user/.local/share/applications/obsidian.desktop << EOF
[Desktop Entry]
Name:Obsidian
Exec:/home/user/Applications/Obsidian/obsidian.Appimage
Logo:/home/user/Applications/Obsidian/logo.png
Type:Application
EOF

sudo update-desktop-database


#hBlock installion(set-up after system config)
curl -o /user/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.5.1/hblock' \
	  && echo 'd010cb9e0f3c644e9df3bfb387f42f7dbbffbbd481fb50c32683bbe71f994451  /user/hblock' | shasum -c \
	    && sudo mv /user/hblock /usr/local/bin/hblock \
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

#Timeshift
sudo timeshift --create --comments "Post-Installation Of system" --tags O
sudo timeshift --schedule-monthly 2
sudo timeshift --schedule-weekly 3
sudo timeshift --schedule-daily 5
sudo timeshift --schedule-hourly 0
sudo timehsift --schedule-boot 3
