#!/bin/sh

# Install all pacman packages
echo "Installing basic packages..."
pacman -S --noconfirm nvidia sudo git vim nano fish base-devel xorg lightdm lightdm-gtk-greeter qtile pulseaudio pavucontrol alacritty &> /dev/null

# Enable lightdm
systemctl enable lightdm &> /dev/null

# Enable sudo
echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo &> /dev/null

# Create user profile
echo "Enter your username: "
read user_name
useradd -G wheel,audio,video -m "$user_name" &> /dev/null
passwd "$user_name"
echo "Added new user with name: $user_name!"

# Sign in as created user
echo "Installing apps and confuguring your system..."
{
sudo -i -u "$user_name" bash << EOF

# Install Yay
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R "$user_name":"$user_name" ./yay-git
cd yay-git
makepkg -si

# Install other packages
yay --noconfirm -S google-chrome pfetch

# Configure your system
echo "Configuring your system..."
dir="$(dirname "$(realpath $0)")/config"
cp -a "$dir/." "/home/$user_name/.config/"

EOF
} &> /dev/null

echo "Finished installation. Reboot your computer..."
