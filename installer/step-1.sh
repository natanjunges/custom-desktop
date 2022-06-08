#!/usr/bin/env sh

# This script is part of Custom Desktop Installer.
# Copyright (C) 2022  Natan Junges <natanajunges@gmail.com>
#
# Custom Desktop Installer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# Custom Desktop Installer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Custom Desktop Installer.  If not, see <https://www.gnu.org/licenses/>.

set -e

if [ ! -e ./build/ubuntu-system-adjustments_*-dummy_all.deb ]; then
    echo "./build/ubuntu-system-adjustments_*-dummy_all.deb not found"
    exit 1
elif [ ! -e ./build/custom-desktop-minimal_*_all.deb ]; then
    echo "./build/custom-desktop-minimal_*_all.deb not found"
    exit 2
elif [ ! -e ./build/custom-desktop_*_all.deb ]; then
    echo "./build/custom-desktop_*_all.deb not found"
    exit 3
fi

wget -c -P ./build/ http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2016.05.26_all.deb
sudo apt install -y ./build/linuxmint-keyring_*_all.deb
sudo apt-key del 451BBBF2
sudo mv /usr/share/keyrings/linuxmint-keyring.gpg /usr/share/keyrings/linuxmint-keyring
sudo gpg --dearmor /usr/share/keyrings/linuxmint-keyring
sudo rm /usr/share/keyrings/linuxmint-keyring

sudo tee /etc/apt/sources.list.d/mint-una.list << EOF
deb [signed-by=/usr/share/keyrings/linuxmint-keyring.gpg] http://packages.linuxmint.com una main
deb [signed-by=/usr/share/keyrings/linuxmint-keyring.gpg] http://packages.linuxmint.com una upstream
EOF

sudo tee /etc/apt/preferences.d/pin-chromium-firefox << EOF
Package: *
Pin: release o=linuxmint
Pin-Priority: -1

Package: chromium
Pin: release o=linuxmint
Pin-Priority: 1000

Package: firefox
Pin: release o=linuxmint
Pin-Priority: 1000

Package: linuxmint-keyring
Pin: release o=linuxmint
Pin-Priority: 1000
EOF

sudo apt update
sudo apt install -y ./build/ubuntu-system-adjustments_*-dummy_all.deb
sudo apt-mark auto ubuntu-system-adjustments
sudo apt install -y ./build/custom-desktop-minimal_*_all.deb gnome-software-plugin-flatpak gnome-software-plugin-snap-
sudo apt-mark auto gnome-software-plugin-flatpak

if [ "$1" = --full ]; then
    sudo apt install -y ./build/custom-desktop_*_all.deb ttf-mscorefonts-installer- unrar- gstreamer1.0-vaapi-
else
    sudo apt install -y --no-install-recommends ./build/custom-desktop_*_all.deb
fi

sudo apt purge -y ubuntu-desktop ubuntu-desktop-minimal
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
