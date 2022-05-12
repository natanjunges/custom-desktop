#!/usr/bin/env sh

set -e
gsettings set org.gnome.desktop.interface icon-theme Yaru
gsettings set org.gnome.desktop.interface cursor-theme Yaru
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")"
sudo apt purge -y snapd transmission-gtk ubuntu-session
sudo apt autoremove --purge -y
