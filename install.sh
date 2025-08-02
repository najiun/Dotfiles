#!/bash/bin

sudo apt update
sudo apt upgrade

#Installing system packages
packages=("i3" "lightdm" "feh" "picom" "dmenu" "ranger" "dunst" "vim" "syncthing" "ufw" "timeshift" "smartmontools" "focuswriter" "tlp" "polybar" "nmtui" "nmcli" "touch" "kitty" )

for package in "${packages[@]}"; do

	sudo apt install -y "$package"
	
done

mkdir /home/tmp/Applications
mkdir /home/tmp/Applications/Bitwarden
mkdir /home/tmp/Applications/Obsidian

#Brave Browser installation

sudo apt install curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

sudo apt update

sudo apt install brave-browser

#Bitwarden installation

curl https://bitwarden.com/download/?app=desktop&platform=linux&variant=appimage -o /home/tmp/Applications/Bitwarden/bitwarden.Appimage
sudo chmod 755 bitwarden.Appimage
sudo curl blob:https://github.com/4982141e-3f78-4694-97e0-464dcfea6612 -o /home/tmp/Applications/Bitwarden/logo.png
touch /home/tmp/.local/share/applications/bitwarden.desktop
echo >> [Desktop Entry]
Name:Bitwarden
Exec:/home/tmp/Applications/Bitwarden/bitwarden.Appimage
Logo:/home/tmp/Applications/Bitwarden/logo.png
Type:Application

>> /home/tmp/.local/share/applications/bitwarden.desktop

update-desktop-database ~/.local/share/applications

#Obsidian installation
sudo curl https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/Obsidian-1.8.10.AppImage -o /home/tmp/Applications/Obsidian/obsidian.Appimage
sudo chmod 755 obsidian.Appimage
sudo curl https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/2023_Obsidian_logo.svg/250px-2023_Obsidian_logo.svg.png -o /home/tmp/Applications/Obsidian/logo.png
touch /home/tmp/.local/share/applications/obsidian.desktop
echo >> [Desktop Entry]
Name:Obsidian
Exec:/home/tmp/Applications/Obsidian/obsidian.Appimage
Logo:/home/tmp/Applications/Obsidian/logo.png
Type:Application
>> /home/tmp/.local/share/applications/obsidian.desktop

update-desktop-database ~/.local/share/applications

#hBlock installion(set-up after system config)
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.5.1/hblock' \
	  && echo 'd010cb9e0f3c644e9df3bfb387f42f7dbbffbbd481fb50c32683bbe71f994451  /tmp/hblock' | shasum -c \
	    && sudo mv /tmp/hblock /usr/local/bin/hblock \
	      && sudo chown 0:0 /usr/local/bin/hblock \
	        && sudo chmod 755 /usr/local/bin/hblock


#change computer name !!!!!



#System configuration 


#UFW CONFIG
ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow out 80 #HTTP/HTTPS
sudo ufw allow out 443 #HTTP/HTTPS
sudo ufw allow 21 #FTP
sudo ufw allow 25 #Email
sudo ufw allow 53 #DNS

#hblock
sudo curl https://raw.githubusercontent.com/najiun/Dotfiles/refs/heads/main/my-sources.list -o /home/nazo/my-sources.list
sudo hblock
sudo hblock --sources /home/nazo/my-sources.list

#Timeshift
sudo timeshift --create --comments "Post-Installation Of system" --tags O
sudo timeshift --schedule-monthly 2
sudo timeshift --schedule-weekly 3
sudo timeshift --schedule-daily 5
sudo timeshift --schedule-hourly 0
sudo timehsift --schdule-boot 3
