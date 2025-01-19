#!/bin/bash

# Add Repos
# wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
# i3
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list

# kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Essential development tools
sudo apt install -y build-essential curl wget git \
    gcc g++ make cmake cmake-gui libboost-all-dev libeigen3-dev libusb-1.0-0-dev libpq-dev \
    htop jq neovim vim tmux docker-compose nodejs npm yarn golang-go rustup \
    ffmpeg imagemagick sqlite3 openjdk-11-jdk openjdk-17-jdk maven gradle \
    fonts-hack-ttf fonts-jetbrains-mono fonts-noto-color-emoji apt-transport-https ca-certificates curl gnupg


# Networking tools
sudo apt install -y aria2 bat dos2unix iputils-ping ifstat net-tools \
    traceroute telnet sshuttle s3cmd kubectl

#i3
sudo apt install -y i3

# CLI tools
sudo apt install -y zoxide fd-find ripgrep glances exa fzf duf bpytop \
    act lsd git-lfs

# Graphics and multimedia
sudo apt install -y libjpeg-dev libpng-dev libtiff-dev libwebp-dev libopenjp2-7-dev \
    libheif-dev libraw-dev libass-dev libbluray-dev libharfbuzz-dev libglib2.0-dev \
    libpango1.0-dev libtbb-dev

# Libraries and scientific tools
sudo apt install -y \
    libhdf5-dev libnetcdf-dev
# Containers and Kubernetes
sudo apt install -y docker.io kubectl
# Version control and CI/CD tools
sudo apt install -y git git-filter-repo git-lfs

# Vim
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Github Monaspace
git clone git@github.com:githubnext/monaspace.git ~/fonts
bash ~/fonts/monaspace/util/install_linux.sh
rm -rf ~/fonts

