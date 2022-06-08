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
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface cursor-theme

if [ "$1" = --full ]; then
    xdg-mime default shotwell-viewer.desktop $(grep ^MimeType= /usr/share/applications/shotwell-viewer.desktop | sed "s/^MimeType=//; s/;/ /g")
fi

if [ "$1" = --preserve -o "$2" = --preserve ]; then
    gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")"
else
    gsettings reset org.gnome.shell favorite-apps
fi
