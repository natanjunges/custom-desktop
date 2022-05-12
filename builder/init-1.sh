#!/usr/bin/env sh

set -e
wget http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2016.05.26_all.deb
sudo apt install -y ./linuxmint-keyring_*_all.deb
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
sudo apt install -y equivs
equivs-build ./ubuntu-system-adjustments
sudo apt purge -y autoconf automake autopoint autotools-dev binutils binutils-common binutils-x86-64-linux-gnu build-essential debhelper debugedit dh-autoreconf dh-strip-nondeterminism dpkg-dev dwz equivs fakeroot g++ g++-11 gcc gcc-11 gettext intltool-debian libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libarchive-cpio-perl libarchive-zip-perl libasan6 libatomic1 libbinutils libc-dev-bin libc-devtools libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdebhelper-perl libdpkg-perl libfakeroot libfile-fcntllock-perl libfile-stripnondeterminism-perl libgcc-11-dev libitm1 liblsan0 libltdl-dev libmail-sendmail-perl libnsl-dev libquadmath0 libsigsegv2 libstdc++-11-dev libsub-override-perl libsys-hostname-long-perl libtirpc-dev libtool libtsan0 libubsan1 linux-libc-dev lto-disabled-list m4 make manpages-dev po-debconf rpcsvc-proto
sudo apt install -y ./ubuntu-system-adjustments_*-dummy_all.deb
sudo apt-mark auto ubuntu-system-adjustments
sudo apt install -y firefox flatpak gnome-session gnome-software gnome-software-plugin-flatpak gnome-software-plugin-snap-

if [ $1 = --full ]; then
    sudo apt install -y qbittorrent vlc #only custom-desktop
fi

sudo apt-mark manual $(LC_ALL=POSIX apt-cache depends --no-recommends --installed ubuntu-desktop-minimal | grep Depends: | sed "s/  Depends: //" | sed ":a; $!N; s/\n/ /; ta")
sudo apt-mark manual $(LC_ALL=POSIX apt-cache depends --no-depends --installed ubuntu-desktop | grep Recommends: | sed "s/  Recommends: //" | sed ":a; $!N; s/\n/ /; ta")
sudo apt purge -y ubuntu-desktop ubuntu-desktop-minimal
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "logout and login into the GNOME session"
