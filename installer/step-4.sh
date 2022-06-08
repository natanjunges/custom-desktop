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
sudo apt purge -y dmz-cursor-theme gnome-accessibility-themes gnome-session-canberra gnome-shell-extension-desktop-icons-ng gnome-shell-extension-ubuntu-dock gstreamer1.0-pulseaudio ibus-gtk libreoffice-ogltrans libreoffice-pdfimport libreoffice-style-breeze libu2f-udev snapd transmission-gtk ubuntu-session xcursor-themes xorg yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-sound

if [ "$1" = --full ]; then
    grep Suggests: ../custom-desktop | sed "s/^Suggests: /#/; s/, /\n#/g" > ./build/suggested
else
    sudo apt purge -y gnome-disk-utility
    grep Suggests: ../custom-desktop-minimal | sed "s/^Suggests: /#/; s/, /\n#/g" > ./build/suggested
fi
