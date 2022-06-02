#!/usr/bin/env sh

# This script is part of Custom Desktop Builder.
# Copyright (C) 2022  Natan Junges <natanajunges@gmail.com>
#
# Custom Desktop Builder is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# Custom Desktop Builder is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Custom Desktop Builder.  If not, see <https://www.gnu.org/licenses/>.

set -e
mkdir -p ./build/
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

if [ ! -f ./build/ubuntu-system-adjustments_*-dummy_all.deb -o ./build/ubuntu-system-adjustments_*-dummy_all.deb -ot ../ubuntu-system-adjustments ]; then
    rm -f ./build/ubuntu-system-adjustments_*-dummy_all.deb
    sudo apt install -y equivs
    make -C ../ ubuntu-system-adjustments
    mv ../build/ubuntu-system-adjustments_*-dummy_all.deb ./build/
    make -C ../ clean
    sudo apt purge -y autoconf automake autopoint autotools-dev binutils binutils-common binutils-x86-64-linux-gnu build-essential debhelper debugedit dh-autoreconf dh-strip-nondeterminism dpkg-dev dwz equivs fakeroot g++ g++-11 gcc gcc-11 gettext intltool-debian libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libarchive-cpio-perl libarchive-zip-perl libasan6 libatomic1 libbinutils libc-dev-bin libc-devtools libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdebhelper-perl libdpkg-perl libfakeroot libfile-fcntllock-perl libfile-stripnondeterminism-perl libgcc-11-dev libitm1 liblsan0 libltdl-dev libmail-sendmail-perl libnsl-dev libquadmath0 libsigsegv2 libstdc++-11-dev libsub-override-perl libsys-hostname-long-perl libtirpc-dev libtool libtsan0 libubsan1 linux-libc-dev lto-disabled-list m4 make manpages-dev po-debconf rpcsvc-proto
fi

sudo apt install -y ./build/ubuntu-system-adjustments_*-dummy_all.deb
sudo apt-mark auto ubuntu-system-adjustments
sudo apt install -y firefox flatpak gnome-session gnome-software gnome-software-plugin-flatpak gnome-software-plugin-snap-
sudo apt-mark auto gnome-software-plugin-flatpak

if [ "$1" = --full ]; then
    sudo apt install -y qbittorrent ubuntu-restricted-extras ttf-mscorefonts-installer- unrar- gstreamer1.0-vaapi- #only custom-desktop
fi

sudo apt-mark manual $(LC_ALL=POSIX apt-cache depends --no-recommends --installed ubuntu-desktop-minimal | grep Depends: | sed "s/^  Depends: //" | sed ":a; $!N; s/\n/ /; ta")
sudo apt-mark manual $(LC_ALL=POSIX apt-cache depends --no-depends --installed ubuntu-desktop | grep Recommends: | sed "s/^  Recommends: //" | sed ":a; $!N; s/\n/ /; ta")
sudo apt purge -y ubuntu-desktop ubuntu-desktop-minimal
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
